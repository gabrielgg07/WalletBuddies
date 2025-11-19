from sqlalchemy.orm import Session
from Utils.db.models import Transaction

# Create transaction
def create_transaction(db: Session, plaid_item_id: int, plaid_transaction_id: str, amount: float,
                       iso_currency_code: str = None, date=None, name: str = None,
                       merchant_name: str = None, category: list = None, pending: bool = None):
    transaction = Transaction(
        plaid_item_id=plaid_item_id,
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


from Utils.crud.transaction_crud import create_transaction, get_transaction_by_plaid_id, update_transaction

def store_added_transactions(db, plaid_item, added_list):
    for t in added_list:

        if get_transaction_by_plaid_id(db, t["transaction_id"]):
            continue

        create_transaction(
            db=db,
            plaid_item_id=plaid_item.id,
            plaid_transaction_id=t["transaction_id"],
            amount=t["amount"],
            iso_currency_code=t.get("iso_currency_code"),
            date=t.get("date"),
            name=t.get("name"),
            merchant_name=t.get("merchant_name"),
            category=t.get("category"),
            pending=t.get("pending")
        )

def store_modified_transactions(db, modified_list):
    for t in modified_list:
        tx = get_transaction_by_plaid_id(db, t["transaction_id"])
        if not tx:
            continue

        update_transaction(
            db=db,
            plaid_transaction_id=tx.id,
            amount=t.get("amount", tx.amount),
            date=t.get("date", tx.date),
            name=t.get("name", tx.name),
            merchant_name=t.get("merchant_name", tx.merchant_name),
            category=t.get("category", tx.category),
            pending=t.get("pending", tx.pending)
        )
