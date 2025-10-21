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
    "development": Environment.Development,
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

@plaid_bp.post("/create_link_token")
def create_link_token():
    req = LinkTokenCreateRequest(
        user={"client_user_id": "demo-user-123"},
        client_name="WalletBuddies",
        products=[Products("transactions")],
        country_codes=[CountryCode("US")],
        language="en",
    )
    resp = client.link_token_create(req)
    return jsonify(resp.to_dict())



@plaid_bp.post("/exchange_public_token")
def exchange_public_token():
    db = SessionLocal()
    try:
        data = request.get_json()
        public_token = data.get("public_token")
        email = data.get("email")  # 👈 or "username" depending on your model

        if not public_token or not email:
            return jsonify({"error": "Missing public_token or email"}), 400

        exch = client.item_public_token_exchange(
            ItemPublicTokenExchangeRequest(public_token=public_token)
        )
        access_token = exch.to_dict()["access_token"]
        item_id = exch.to_dict()["item_id"]

        # 🔍 Find user
        user = get_user_by_email(db, email)
        if not user:
            return jsonify({"error": f"No user found for {email}"}), 404

        # 🧱 Store Plaid item linked to user
        plaid_item = PlaidItem(
            user_id=user.id,
            access_token=access_token,
            item_id=item_id,
            institution_name="Demo Bank"
        )
        db.add(plaid_item)
        db.commit()

        return jsonify({
            "status": "ok",
            "user_id": user.id,
            "item_id": item_id
        })
    except Exception as e:
        db.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        db.close()


@plaid_bp.get("/transactions")
def get_transactions():
    db = SessionLocal()
    try:
        email = request.args.get("email")  # example: /api/transactions?email=gus@example.com
        if not email:
            return jsonify({"error": "Missing email"}), 400

        # 🔍 Find user
        user = get_user_by_email(db, email)
        if not user:
            return jsonify({"error": f"No user found for {email}"}), 404

        # 🔍 Find user's first (or most recent) Plaid item
        plaid_item = (
            db.query(PlaidItem)
            .filter(PlaidItem.user_id == user.id)
            .order_by(PlaidItem.created_at.desc())
            .first()
        )
        if not plaid_item:
            return jsonify({"error": "No Plaid items linked to this user"}), 400

        access_token = plaid_item.access_token

        # 📅 Fetch transactions
        end = date.today()
        start = end - timedelta(days=30)
        resp = client.transactions_get(
            TransactionsGetRequest(
                access_token=access_token,
                start_date=start,
                end_date=end,
                options={"count": 25, "offset": 0},
            )
        )
        return jsonify(resp.to_dict())

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        db.close()



