import os
from datetime import date, timedelta

import os
from datetime import date, timedelta

from flask import Flask, jsonify, render_template, request
from dotenv import load_dotenv
from plaid import Configuration, ApiClient, Environment
from plaid.api import plaid_api

# 👇 import models from their specific modules (v18 style)
from plaid.model.link_token_create_request import LinkTokenCreateRequest
from plaid.model.products import Products
from plaid.model.country_code import CountryCode
from plaid.model.item_public_token_exchange_request import ItemPublicTokenExchangeRequest
from plaid.model.accounts_get_request import AccountsGetRequest
from plaid.model.transactions_get_request import TransactionsGetRequest

load_dotenv()

PLAID_ENV = os.getenv("PLAID_ENV", "sandbox").lower()
env_map = {"sandbox": Environment.Sandbox, "development": Environment.Development, "production": Environment.Production}

config = Configuration(
    host=env_map[PLAID_ENV],
    api_key={"clientId": os.getenv("PLAID_CLIENT_ID"), "secret": os.getenv("PLAID_SECRET")},
)

app = Flask(__name__)
client = plaid_api.PlaidApi(ApiClient(config))

# demo in-memory store (swap for DB per user)
ACCESS_TOKEN = None

@app.get("/")
def index():
    return render_template("index.html")

@app.post("/api/create_link_token")
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

@app.post("/api/exchange_public_token")
def exchange_public_token():
    """Exchange token, then FETCH & PRINT data server-side."""
    global ACCESS_TOKEN
    public_token = request.json.get("public_token")
    exch = client.item_public_token_exchange(ItemPublicTokenExchangeRequest(public_token=public_token))
    ACCESS_TOKEN = exch.to_dict()["access_token"]
    print("\n✅ Access token stored.\n")
    print(get_transactions())
    return jsonify({"status": "ok"})

@app.get("/api/transactions")
def get_transactions():
    if not ACCESS_TOKEN:
        return jsonify({"error": "No access token yet"}), 400
    end = date.today()
    start = end - timedelta(days=30)
    resp = client.transactions_get(TransactionsGetRequest(
        access_token=ACCESS_TOKEN, start_date=start, end_date=end, options={"count": 25, "offset": 0}
    ))
    return jsonify(resp.to_dict())

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5001)
