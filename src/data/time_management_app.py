from flask import Flask
from flask_cors import CORS
from routes.time_management_api import time_management_api

app = Flask(__name__)
CORS(app)

# Register blueprints
app.register_blueprint(time_management_api, url_prefix="/time_management")

if __name__ == "__main__":
    app.run(port=5000)