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

    access_token = Column(Text, nullable=False)              # ✅ add this
    plaid_item_id = Column(Text, unique=True, nullable=False)  # keep this as the Plaid item_id
    institution_name = Column(Text)
    status = Column(String)
    cursor = Column(Text, nullable=True)

    created_at = Column(TIMESTAMP, default=datetime.utcnow)

    # --- Relationships ---
    user = relationship("User", back_populates="items")
    accounts = relationship("Account", back_populates="plaid_item", cascade="all, delete")
