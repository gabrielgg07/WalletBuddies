from sqlalchemy.orm import Session
from Utils.db.models import Account
from datetime import datetime

# Create account
def create_account(db: Session, item_id: int, plaid_account_id: str, name: str = None,
                   mask: str = None, official_name: str = None, type: str = None,
                   subtype: str = None, current_balance: float = None,
                   available_balance: float = None, iso_currency_code: str = None):
    account = Account(
        item_id=item_id,
        plaid_account_id=plaid_account_id,
        name=name,
        mask=mask,
        official_name=official_name,
        type=type,
        subtype=subtype,
        current_balance=current_balance,
        available_balance=available_balance,
        iso_currency_code=iso_currency_code
    )
    db.add(account)
    db.commit()
    db.refresh(account)
    return account

# Get account by ID
def get_account(db: Session, account_id: int):
    return db.query(Account).filter(Account.id == account_id).first()

# Get account by Plaid ID
def get_account_by_plaid_id(db: Session, plaid_account_id: str):
    return db.query(Account).filter(Account.plaid_account_id == plaid_account_id).first()

# Update account
def update_account(db: Session, account_id: int, **kwargs):
    account = get_account(db, account_id)
    if not account:
        return None
    for key, value in kwargs.items():
        setattr(account, key, value)
    db.commit()
    db.refresh(account)
    return account

# Delete account
def delete_account(db: Session, account_id: int):
    account = get_account(db, account_id)
    if account:
        db.delete(account)
        db.commit()
    return account

def suspend_account(db: Session, account_id: int, reason: str, admin_id: int | None = None):
    account = db.query(Account).filter(Account.id == account_id).first()
    if not account:
        return None

    account.is_suspended = True
    account.suspended_at = datetime.utcnow()
    account.suspension_reason = reason

    # Log suspension if using the history table
    suspension = AccountSuspension(
        account_id=account_id,
        suspended_by=admin_id,
        reason=reason,
    )
    db.add(suspension)

    db.commit()
    db.refresh(account)
    return account


def lift_suspension(db: Session, account_id: int):
    account = db.query(Account).filter(Account.id == account_id).first()
    if not account:
        return None

    account.is_suspended = False
    account.suspended_at = None
    account.suspension_reason = None

    # Update open suspension record
    open_suspension = (
        db.query(AccountSuspension)
        .filter(AccountSuspension.account_id == account_id, AccountSuspension.lifted_at.is_(None))
        .first()
    )
    if open_suspension:
        open_suspension.lifted_at = datetime.utcnow()

    db.commit()
    db.refresh(account)
    return account