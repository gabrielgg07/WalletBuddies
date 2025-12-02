from sqlalchemy.orm import Session
from Utils.db.models import Transaction

# Create transaction
def create_transaction(db: Session, account_id: int, plaid_transaction_id: str, amount: float,
                       iso_currency_code: str = None, date=None, name: str = None,
                       merchant_name: str = None, category: list = None, pending: bool = None):
    transaction = Transaction(
        account_id=account_id,
        plaid_transaction_id=plaid_transaction_id,
        amount=amount,
        iso_currency_code=iso_currency_code,
        date=date,
        name=name,
        merchant_name=merchant_name,
        category=category,
        pending=pending
    )
    db.add(transaction)
    db.commit()
    db.refresh(transaction)
    return transaction

# Get transaction by ID
def get_transaction(db: Session, transaction_id: int):
    return db.query(Transaction).filter(Transaction.id == transaction_id).first()

# Get transaction by Plaid ID
def get_transaction_by_plaid_id(db: Session, plaid_transaction_id: str):
    return db.query(Transaction).filter(Transaction.plaid_transaction_id == plaid_transaction_id).first()

# Update transaction
def update_transaction(db: Session, transaction_id: int, **kwargs):
    txn = get_transaction(db, transaction_id)
    if not txn:
        return None
    for key, value in kwargs.items():
        setattr(txn, key, value)
    db.commit()
    db.refresh(txn)
    return txn

# Delete transaction
def delete_transaction(db: Session, transaction_id: int):
    txn = get_transaction(db, transaction_id)
    if txn:
        db.delete(txn)
        db.commit()
    return txn