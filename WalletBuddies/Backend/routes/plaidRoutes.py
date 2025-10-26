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
from Utils.crud.user_crud import get_user_by_email

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
            institution_name="Demo Bank"
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


# --- Get transactions ---
@plaid_bp.get("/transactions")
def get_transactions():
    print("📡 [Plaid] get_transactions() called")
    db = SessionLocal()

    try:
        email = request.args.get("email")
        print(f"📨 [Plaid] Fetching transactions for email: {email}")

        if not email:
            print("⚠️ [Plaid] Missing email in request")
            return jsonify({"error": "Missing email"}), 400

        user = get_user_by_email(db, email)
        if not user:
            print(f"❌ [DB] No user found for {email}")
            return jsonify({"error": f"No user found for {email}"}), 404

        plaid_item = (
            db.query(PlaidItem)
            .filter(PlaidItem.user_id == user.id)
            .order_by(PlaidItem.created_at.desc())
            .first()
        )

        if not plaid_item:
            print("⚠️ [DB] No Plaid item found for this user")
            return jsonify({"error": "No Plaid items linked to this user"}), 400

        print(f"📅 [Plaid] Fetching transactions from {email}’s account")
        end = date.today()
        start = end - timedelta(days=30)

        try:
            resp = client.transactions_get(
                TransactionsGetRequest(
                    access_token=plaid_item.access_token,
                    start_date=start,
                    end_date=end,
                    options={"count": 25, "offset": 0},
                )
            )
            print("✅ [Plaid] Transactions fetched successfully")
            return jsonify(resp.to_dict())

        except Exception as e:
            print("💥 [Plaid] Error fetching transactions:", e)
            return jsonify({"error": str(e)}), 500

    except Exception as e:
        print("💥 [Plaid] General error in get_transactions:", e)
        return jsonify({"error": str(e)}), 500

    finally:
        db.close()
        print("🧹 [Plaid] Database session closed")