from sqlalchemy.orm import Session
from Utils.db.models import User

# Create a new user
def create_user(db: Session, fname:str, lname:str, email: str, password_hash: str):
    user = User(fname=fname,lname=lname, email=email, password_hash=password_hash)
    db.add(user)
    db.commit()
    db.refresh(user)
    return user

# Get user by ID
def get_user(db: Session, user_id: int):
    return db.query(User).filter(User.id == user_id).first()

# Get user by email
def get_user_by_email(db: Session, email: str):
    return db.query(User).filter(User.email == email).first()

# Update user
def update_user(db: Session, user_id: int, **kwargs):
    user = get_user(db, user_id)
    if not user:
        return None
    for key, value in kwargs.items():
        setattr(user, key, value)
    db.commit()
    db.refresh(user)
    return user

# Delete user
def delete_user(db: Session, user_id: int):
    user = get_user(db, user_id)
    if user:
        db.delete(user)
        db.commit()
    return user