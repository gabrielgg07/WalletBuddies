from datetime import datetime
from sqlalchemy import (
    Column,
    Integer,
    Text,
    String,
    ForeignKey,
    TIMESTAMP,
)
from sqlalchemy.orm import relationship
from Utils.db.base import Base  # adjust import path if needed


class PlaidItem(Base):
    __tablename__ = "items"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)

    plaid_item_id = Column(Text, unique=True, nullable=False)  # from Plaid
    institution_name = Column(Text)
    status = Column(String)  # e.g. active, error, etc.
    created_at = Column(TIMESTAMP, default=datetime.utcnow)

    # --- Relationships ---
    user = relationship("User", back_populates="items")
    accounts = relationship("Account", back_populates="plaid_item", cascade="all, delete")