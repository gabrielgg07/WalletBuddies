import os
from datetime import date, timedelta
from flask import Blueprint, jsonify, request
from plaid import Configuration, ApiClient, Environment
from plaid.api import plaid_api
from plaid.model.link_token_create_request import LinkTokenCreateRequest
from plaid.model.products import Products
from plaid.model.country_code import CountryCode
from plaid.model.item_public_token_exchange_request import ItemPublicTokenExchangeRequest
from plaid.model.transactions_get_request import TransactionsGetRequest




from Utils.db.base import SessionLocal
from Utils.db.models import PlaidItem
from Utils.db.models import Transaction
from Utils.crud.user_crud import get_user_by_email
from Utils.crud.transaction_crud import (
    create_transaction,
    get_transaction_by_plaid_id,
    update_transaction,
    store_added_transactions,
    store_modified_transactions
)
from Utils.db.models import Transaction
from plaid.model.transactions_sync_request import TransactionsSyncRequest


# --- Load environment variables ---
from dotenv import load_dotenv
load_dotenv()

# --- Configure Plaid ---
PLAID_ENV = os.getenv("PLAID_ENV", "sandbox").lower()
env_map = {
    "sandbox": Environment.Sandbox,
    "production": Environment.Production,
}
config = Configuration(
    host=env_map[PLAID_ENV],
    api_key={
        "clientId": os.getenv("PLAID_CLIENT_ID"),
        "secret": os.getenv("PLAID_SECRET"),
    },
)
client = plaid_api.PlaidApi(ApiClient(config))

# --- Demo store ---
ACCESS_TOKEN = None

# --- Create Blueprint ---
plaid_bp = Blueprint("plaid_bp", __name__)

# --- Create link token ---
@plaid_bp.post("/create_link_token")
def create_link_token():
    print("📡 [Plaid] create_link_token() called")

    try:
        req = LinkTokenCreateRequest(
            user={"client_user_id": "demo-user-123"},
            client_name="WalletBuddies",
            products=[Products("transactions")],
            country_codes=[CountryCode("US")],
            language="en",
        )
        resp = client.link_token_create(req)
        print("✅ [Plaid] Link token created successfully")
        return jsonify(resp.to_dict())

    except Exception as e:
        print(f"❌ [Plaid] Link token creation failed: {e}")
        return jsonify({"error": str(e)}), 500


# --- Exchange public token ---
@plaid_bp.post("/exchange_public_token")
def exchange_public_token():
    print("📡 [Plaid] exchange_public_token() called")
    db = SessionLocal()

    try:
        data = request.get_json() or {}
        print("📨 [Plaid] Received data:", data)

        public_token = data.get("public_token")
        email = data.get("email")

        if not public_token or not email:
            print("⚠️ [Plaid] Missing public_token or email")
            return jsonify({"error": "Missing public_token or email"}), 400

        print("🔑 [Plaid] Attempting token exchange with Plaid API...")
        exch = client.item_public_token_exchange(
            ItemPublicTokenExchangeRequest(public_token=public_token)
        )
        print("✅ [Plaid] Exchange successful:", exch.to_dict())

        access_token = exch.to_dict()["access_token"]
        item_id = exch.to_dict()["item_id"]

        print(f"👤 [DB] Looking up user by email: {email}")
        user = get_user_by_email(db, email)
        if not user:
            print(f"❌ [DB] No user found for {email}")
            return jsonify({"error": f"No user found for {email}"}), 404

        print(f"💾 [DB] Storing Plaid item for user_id={user.id}")
        plaid_item = PlaidItem(
            user_id=user.id,
            access_token=access_token,        # ✅ new column
            plaid_item_id=item_id,            # ✅ use plaid_item_id (matches model)
            institution_name="Demo Bank",
            cursor=None
        )
        db.add(plaid_item)
        db.commit()

        print(f"✅ [Plaid] Token exchange + DB save complete for user {email}")
        return jsonify({
            "status": "ok",
            "user_id": user.id,
            "item_id": item_id
        })

    except Exception as e:
        db.rollback()
        import traceback
        print("💥 [Plaid] Exception during exchange_public_token:", e)
        print(traceback.format_exc())  # <-- ADD THIS LINE
        return jsonify({"error": str(e)}), 500

    finally:
        db.close()
        print("🧹 [Plaid] Database session closed")

@plaid_bp.get("/transactions")
def list_transactions():
    db = SessionLocal()
    email = request.args.get("email")

    user = get_user_by_email(db, email)
    if not user:
        return jsonify([])

    item_ids = [item.id for item in user.items]

    txs = (
        db.query(Transaction)  # rename model to avoid conflict
        .filter(Transaction.plaid_item_id.in_(item_ids))
        .order_by(Transaction.date.desc())
        .all()
    )

    results = []
    for t in txs:
        results.append({
            "id": t.id,
            "name": t.name,
            "amount": float(t.amount),
            "date": t.date.isoformat() if t.date else None,
            "merchant_name": t.merchant_name,
            "category": t.category,
            "pending": t.pending
        })

    return jsonify(results)



from plaid.model.transactions_sync_request import TransactionsSyncRequest


@plaid_bp.get("/transactions/sync")
def transactions_sync():
    print("📡 [Plaid] transactions_sync() called")
    db = SessionLocal()

    try:
        email = request.args.get("email")
        if not email:
            return jsonify({"error": "Missing email"}), 400

        user = get_user_by_email(db, email)
        if not user:
            return jsonify({"error": "User not found"}), 404

        plaid_item = (
            db.query(PlaidItem)
            .filter(PlaidItem.user_id == user.id)
            .order_by(PlaidItem.created_at.desc())
            .first()
        )
        if not plaid_item:
            return jsonify({"error": "No Plaid item found"}), 400

        # Current cursor (None on first sync)
        cursor = plaid_item.cursor
        print(f"🔁 [Plaid] Using cursor: {cursor}")

        if cursor:
            req = TransactionsSyncRequest(access_token=plaid_item.access_token, cursor=cursor)
        else:
            req = TransactionsSyncRequest(access_token=plaid_item.access_token)


        sync_resp = client.transactions_sync(req).to_dict()
        print("🔥 [Plaid] Sync response:", sync_resp)

        added = sync_resp.get("added", [])
        modified = sync_resp.get("modified", [])

        print(f"🟢 Added: {len(added)}, 🟡 Modified: {len(modified)}")

        # STORE THE DATA (important!)
        store_added_transactions(db, plaid_item, added)
        store_modified_transactions(db, modified)

        # Save next cursor
        next_cursor = sync_resp.get("next_cursor")
        plaid_item.cursor = next_cursor
        db.commit()

        return jsonify({
            "status": "synced",
            "added": len(added),
            "modified": len(modified),
            "cursor": next_cursor
        })

    except Exception as e:
        print("💥 Error during /transactions/sync:", e)
        return jsonify({"error": str(e)}), 500

    finally:
        db.close()
        print("🧹 DB session closed")

@plaid_bp.get("/net")
def get_net_gain_loss():
    db = SessionLocal()

    try:
        email = request.args.get("email")
        if not email:
            return jsonify({"error": "Missing email"}), 400

        user = get_user_by_email(db, email)
        if not user:
            return jsonify({"error": "User not found"}), 404

        # Get all PlaidItem IDs for this user
        item_ids = [item.id for item in user.items]

        if not item_ids:
            return jsonify({"net": 0.0})

        # IMPORT YOUR SQLALCHEMY MODEL
        from Utils.db.models.transaction import Transaction as TransactionModel

        # Query all transactions for those PlaidItems
        txs = (
            db.query(TransactionModel)
            .filter(TransactionModel.plaid_item_id.in_(item_ids))
            .all()
        )

        # Sum amounts — make sure amount is cast to float
        net = sum(float(tx.amount) for tx in txs if tx.amount is not None)

        return jsonify({"net": net})

    except Exception as e:
        print("💥 Error in /net:", e)
        return jsonify({"error": str(e)}), 500

    finally:
        db.close()
