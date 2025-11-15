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

@user_bp.route('/adminSignup', methods=["POST"])
def createAdminAccount():
    db = SessionLocal()
    signupData = request.get_json() or {}
    print(signupData)

    userName = signupData.get('userName')
    userEmail = signupData.get('emailAddress', '').lower()
    userPassword = signupData.get('password')
    roleA = 'admin'

    # --- Validate inputs ---
    if not all([userName, userEmail, userPassword,roleA]):
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
        name = userName,
        email=userEmail,
        password_hash=hashed_pw,
        role = roleA
    )

    db.add(new_user)
    db.commit()
    db.close()

    return jsonify({"success": True, "message": "Account successfully created"}), 201


@user_bp.route('/signup', methods=["POST"])
def createAccount():
    db = SessionLocal()
    signupData = request.get_json() or {}
    print(signupData)

    userName = signupData.get('userName')
    userEmail = signupData.get('emailAddress', '').lower()
    userPassword = signupData.get('password')
    roleU ='user'

    # --- Validate inputs ---
    if not all([userName, userEmail, userPassword,roleU]):
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
        name = userName,
        email=userEmail,
        password_hash=hashed_pw,
        role = roleU
    )

    db.add(new_user)
    db.commit()
    db.close()

    return jsonify({"success": True, "message": "Account successfully created"}), 201

  

# User login by Email

@user_bp.route('/login', methods=["POST"])
def logIn():
    db = SessionLocal()
    try:
        data = request.get_json() or {}
        user_email = data.get('emailAddress', '').lower()
        user_password = data.get('password')

        if not user_email or not user_password:
            return jsonify({"success": False, "message": "Missing email or password"}), 400

        user = db.query(User).filter(User.email == user_email).first()
        if not user:
            return jsonify({"success": False, "message": "User not found"}), 404

        # ✅ Check hashed password correctly

        if not bcrypt.checkpw(user_password.encode('utf-8'), user.password_hash.encode('utf-8')):
            return jsonify({"success": False, "message": "Incorrect password"}), 401

        # ✅ Return clean user info
        return jsonify({
            "success": True,
            "message": "Logged In",
            "user": {
                "id": user.id,
                "name" : user.name,
                "email": user.email,
                "role" : user.role,
                "created_at": user.created_at.isoformat() if user.created_at else None
            }
        }), 200

    except Exception as e:
        print("❌ Login error:", e)
        return jsonify({"success": False, "message": "Server error"}), 500
    finally:
        db.close()



@user_bp.route('/updateUserPrivilege',methods=["POST"])
def updateUserPrivileges():
    get_database = SessionLocal()
    updateFormData = request.get_json() or {}
    print(updateFormData)
    requestRole = updateFormData.get('requestRole')
    print(requestRole)
    targetUserEmail = updateFormData.get('targetUserEmail').lower()
    userObj = get_database.query(User).filter(User.email == targetUserEmail).first()

    if requestRole != 'admin' or not userObj:
        return jsonify({"success": False, "message": "Not allowed"}),400
    else:

        if userObj.role == 'admin':
            userObj.role = 'user'
            get_database.commit()
            get_database.close()
            return jsonify({"success":True, "message": "Role changed to user"}),200
        elif userObj.role == 'user':
            userObj.role = 'admin'
            get_database.commit()
            get_database.close()
            return jsonify({"success":True, "message": "Role changed to admin"}),200
    return jsonify({"success": False, "message": "Not successful"}), 200

#Delete user
@user_bp.route('/deleteAccount',methods=["DELETE"])
def deleteUser():
   get_database = SessionLocal()
   deleteFormData = request.get_json() or {}
   print(deleteFormData)
   userEmail = deleteFormData.get('userEmail')
   userObj = get_database.query(User).filter(User.email == userEmail).first()
   if not userObj:
       return jsonify({"success": False, "message": "No user to delete"}),400
   elif userEmail == userObj.email:
       get_database.delete(userObj)
       get_database.commit()
       get_database.close()
       return jsonify({"success":True, "message": "User Deleted"}),200
   return jsonify({"success": False, "message": "Not successful"}),400

@user_bp.route('/deleteUserAccount',methods=["DELETE"])
def deleteUserAccount():
    get_database = SessionLocal()
    deleteFormData = request.get_json() or {}
    print(deleteFormData)
    requestRole = deleteFormData.get('requestRole')
    print(requestRole)
    targetUserEmail = deleteFormData.get('targetUserEmail').lower()
    userObj = get_database.query(User).filter(User.email == targetUserEmail).first()

    if requestRole != 'admin' or not userObj:
        return jsonify({"success": False, "message": "Not allowed"}),400
    else:
        get_database.delete(userObj)
        get_database.commit()
        get_database.close()
        return jsonify({"success": True, "message": "User Deleted"}), 200

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
