from flask import Flask
from flask_cors import CORS
from routes.reporting_api import reporting_api

app = Flask(__name__)
CORS(app)

# Register blueprints
app.register_blueprint(reporting_api, url_prefix="/generate_report")

if __name__ == "__main__":
    app.run(port=5000)