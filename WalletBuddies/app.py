from flask import Flask, render_template
from Backend.routes.plaidRoutes import plaid_bp
from Backend.routes.userRoutes import user_bp

app = Flask(__name__)
app.register_blueprint(plaid_bp, url_prefix="/api/plaid")
app.register_blueprint(user_bp, url_prefix="/api/users")

@app.get("/")
def index():
    return render_template("index.html")

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5001)
