from datetime import datetime
from sqlalchemy import (
    Column,
    Integer,
    Text,
    TIMESTAMP,
)
from sqlalchemy.orm import relationship
from Utils.db.base import Base  # adjust import path if needed


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(Text, nullable=False)
    source = Column(Text, nullable=True)
    email = Column(Text, unique=True, nullable=False)
    password_hash = Column(Text, nullable=True)
    GID_Token = Column(Text, nullable=True)
    role = Column(Text, nullable=False)
    created_at = Column(TIMESTAMP, default=datetime.utcnow)
    updated_at = Column(TIMESTAMP, default=datetime.utcnow, onupdate=datetime.utcnow)

    # --- Relationships ---
    items = relationship("PlaidItem", back_populates="user", cascade="all, delete")

    def dictRepresentation(user):
        return {
            "id":user.id,
            "name" :user.name,
            "email":user.email,
            "role" :user.role
        }