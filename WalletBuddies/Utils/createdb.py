from .db.base import engine, Base
from .db.models import user, plaid_item, account, transaction

Base.metadata.create_all(bind=engine)
print("✅ All tables created successfully!")