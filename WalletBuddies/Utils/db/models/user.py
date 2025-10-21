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
    fname = Column(Text, nullable=False)
    lname =  Column(Text, nullable=True)
    email = Column(Text, unique=True, nullable=False)
    password_hash = Column(Text, nullable=False)
    created_at = Column(TIMESTAMP, default=datetime.utcnow)
    updated_at = Column(TIMESTAMP, default=datetime.utcnow, onupdate=datetime.utcnow)

    # --- Relationships ---
    items = relationship("PlaidItem", back_populates="user", cascade="all, delete")
