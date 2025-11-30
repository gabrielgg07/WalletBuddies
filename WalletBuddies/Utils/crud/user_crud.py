from sqlalchemy.orm import Session
from Utils.db.models import User

# Create a new user
def create_user(db: Session, name:str, source:str, email: str, password_hash: str,GID_Token:str,role: str):
    user = User(name= name, source=source,email=email, password_hash=password_hash, GID_Token=GID_Token,role=role)
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

#Get all users
def get_all_users(db:Session):
    return db.query(User).all()