from flask import Blueprint, request, jsonify
from Utils.db.base import SessionLocal
from Utils.db.models import User
from Utils.crud.user_crud import (
    create_user,
    get_user,
    get_user_by_email,
    update_user,
    delete_user
)
import bcrypt

user_bp = Blueprint("user_bp", __name__)

# Signup 

@user_bp.route('/signup', methods=["POST"])
def createAcc():
    db = SessionLocal()
    signupData = request.get_json() or {}
    print(signupData)

    firstName = signupData.get('firstName')
    lastName = signupData.get('lastName')
    userEmail = signupData.get('emailAddress', '').lower()
    userPassword = signupData.get('password')

    # --- Validate inputs ---
    if not all([firstName, lastName, userEmail, userPassword]):
        return jsonify({"success": False, "message": "Missing required fields"}), 400

    # --- Hash password ---
    hashed_pw = bcrypt.hashpw(userPassword.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')

    # --- Check if user already exists ---
    userObj = db.query(User).filter(User.email == userEmail).first()
    if userObj:
        db.close()
        return jsonify({"success": False, "message": "User already exists"}), 400

    # --- Create new user ---
    new_user = User(
        fname=firstName,
        lname=lastName,
        email=userEmail,
        password_hash=hashed_pw
    )

    db.add(new_user)
    db.commit()
    db.close()

    return jsonify({"success": True, "message": "Account successfully created"}), 201

  

# User login by Email

@user_bp.route('/login',methods=["POST"])
def logIn():
   get_database = SessionLocal()
   loginData = request.get_json() or {}
   print(loginData)
   userEmail = loginData.get('emailAddress').lower()
   userPassword = loginData.get('password')
   userObj = get_database.query(User).filter(User.email == userEmail).first()
   print(userObj.email)
   if userEmail == userObj.email :
       return jsonify({"success":True, "message": "Logged In"}),200
   else:
      return jsonify({"success":False, "message": "User doesn't Exist"}),400
    

# -------------------------------
# 🧱 Create new user
# -------------------------------
@user_bp.post("/create")
def create_user_route():
    db = SessionLocal()
    try:
        data = request.get_json()
        email = data.get("email")
        password = data.get("password")

        if not email or not password:
            return jsonify({"error": "Missing email or password"}), 400

        # Hash password
        hashed_pw = bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt()).decode("utf-8")

        # Check if user already exists
        if get_user_by_email(db, email):
            return jsonify({"error": "User already exists"}), 409

        user = create_user(db, email, hashed_pw)
        return jsonify({
            "id": user.id,
            "email": user.email,
            "message": "User created successfully"
        }), 201
    except Exception as e:
        db.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        db.close()


# -------------------------------
# 🔍 Get user by ID or email
# -------------------------------
@user_bp.get("/get")
def get_user_route():
    db = SessionLocal()
    try:
        user_id = request.args.get("id")
        email = request.args.get("email")

        if not user_id and not email:
            return jsonify({"error": "Provide either 'id' or 'email'"}), 400

        user = get_user(db, int(user_id)) if user_id else get_user_by_email(db, email)
        if not user:
            return jsonify({"error": "User not found"}), 404

        return jsonify({
            "id": user.id,
            "email": user.email,
            "created_at": str(user.created_at) if hasattr(user, "created_at") else None
        })
    finally:
        db.close()


# -------------------------------
# ✏️ Update user info
# -------------------------------
@user_bp.put("/update/<int:user_id>")
def update_user_route(user_id):
    db = SessionLocal()
    try:
        data = request.get_json()
        user = update_user(db, user_id, **data)
        if not user:
            return jsonify({"error": "User not found"}), 404
        return jsonify({"message": "User updated", "user": {"id": user.id, "email": user.email}})
    except Exception as e:
        db.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        db.close()


# -------------------------------
# ❌ Delete user
# -------------------------------
@user_bp.delete("/delete/<int:user_id>")
def delete_user_route(user_id):
    db = SessionLocal()
    try:
        user = delete_user(db, user_id)
        if not user:
            return jsonify({"error": "User not found"}), 404
        return jsonify({"message": f"User {user.email} deleted"})
    except Exception as e:
        db.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        db.close()
