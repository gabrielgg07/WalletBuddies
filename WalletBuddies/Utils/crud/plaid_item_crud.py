from sqlalchemy.orm import Session
from Utils.db.models import PlaidItem

# Create a new Plaid item
def create_plaid_item(db: Session, user_id: int, plaid_item_id: str, institution_name: str, status: str):
    item = PlaidItem(
        user_id=user_id,
        plaid_item_id=plaid_item_id,
        institution_name=institution_name,
        status=status
    )
    db.add(item)
    db.commit()
    db.refresh(item)
    return item

# Get Plaid item by ID
def get_plaid_item(db: Session, item_id: int):
    return db.query(PlaidItem).filter(PlaidItem.id == item_id).first()

# Get by Plaid ID
def get_plaid_item_by_plaid_id(db: Session, plaid_item_id: str):
    return db.query(PlaidItem).filter(PlaidItem.plaid_item_id == plaid_item_id).first()

# Update Plaid item
def update_plaid_item(db: Session, item_id: int, **kwargs):
    item = get_plaid_item(db, item_id)
    if not item:
        return None
    for key, value in kwargs.items():
        setattr(item, key, value)
    db.commit()
    db.refresh(item)
    return item

# Delete Plaid item
def delete_plaid_item(db: Session, item_id: int):
    item = get_plaid_item(db, item_id)
    if item:
        db.delete(item)
        db.commit()
    return item