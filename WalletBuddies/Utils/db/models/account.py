from datetime import datetime
from sqlalchemy import (
    Column,
    Integer,
    String,
    Text,
    Numeric,
    CHAR,
    ForeignKey,
    TIMESTAMP,
)
from sqlalchemy.orm import relationship
from Utils.db.base import Base  # adjust import path if needed


class Account(Base):
    __tablename__ = "accounts"

    id = Column(Integer, primary_key=True, index=True)
    item_id = Column(Integer, ForeignKey("items.id", ondelete="CASCADE"), nullable=False)
    plaid_account_id = Column(Text, unique=True, nullable=False)

    name = Column(Text)
    mask = Column(String(4))
    official_name = Column(Text)
    type = Column(Text)
    subtype = Column(Text)
    current_balance = Column(Numeric)
    available_balance = Column(Numeric)
    iso_currency_code = Column(CHAR(3))

    created_at = Column(TIMESTAMP, default=datetime.utcnow)
    updated_at = Column(TIMESTAMP, default=datetime.utcnow, onupdate=datetime.utcnow)

    # --- Relationships ---
    plaid_item = relationship("PlaidItem", back_populates="accounts")
    transactions = relationship("Transaction", back_populates="account", cascade="all, delete")
