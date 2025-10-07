from sqlalchemy import (
    Column,
    Integer,
    String,
    Numeric,
    Date,
    Text,
    Boolean,
    TIMESTAMP,
    ForeignKey,
    ARRAY,
    func
)
from sqlalchemy.orm import relationship
from Utils.db.base import Base  # assuming Base = declarative_base()

class Transaction(Base):
    __tablename__ = "transactions"

    id = Column(Integer, primary_key=True)
    account_id = Column(Integer, ForeignKey("accounts.id", ondelete="CASCADE"))

    plaid_transaction_id = Column(Text, unique=True, nullable=False)
    amount = Column(Numeric, nullable=False)
    iso_currency_code = Column(String(3))
    date = Column(Date)

    name = Column(Text)             # Transaction or merchant name
    merchant_name = Column(Text)
    category = Column(ARRAY(Text))  # Postgres array of category strings
    pending = Column(Boolean)

    created_at = Column(TIMESTAMP, server_default=func.now())
    updated_at = Column(
        TIMESTAMP,
        server_default=func.now(),
        onupdate=func.now()
    )

    # Relationship to Account model
    account = relationship("Account", back_populates="transactions")