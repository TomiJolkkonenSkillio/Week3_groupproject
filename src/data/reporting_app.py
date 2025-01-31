from flask import Flask
from flask_cors import CORS
from routes.reporting_api import reporting_api
from apscheduler.schedulers.background import BackgroundScheduler
from flask import Blueprint, jsonify, request, current_app
from services.reporting_service import get_weekly_working_hours, upload_to_blob, manipulate_data
import pandas as pd
from threading import Thread

#Initialize the Flask app
app = Flask(__name__)
CORS(app)

# Create a Blueprint for reporting related routes
# reporting_api = Blueprint('reporting_api', __name__)
# Register blueprints
app.register_blueprint(reporting_api, url_prefix="/generate_report")

# Create a function for generating a weekly report automatically
def generate_report_auto():
    try:
        with app.app_context():
            df = pd.DataFrame(get_weekly_working_hours())
            df = manipulate_data(df)
            upload_to_blob(df)
            return jsonify({'message': 'Weekly report generated automatically'}), 201
    except Exception as e:
        with app.app_context():
            return jsonify({'error': str(e)}), 500
        
#Cteate a scheduler for generating a weekly report automatically
def start_scheduler():
    with app.app_context():
        scheduler = BackgroundScheduler()

        scheduler.add_job(generate_report_auto, 'interval', minutes=5, start_date='2025-01-30 00:00:00')

        scheduler.start()

scheduler_thread = Thread(target=start_scheduler)
scheduler_thread.daemon = True
scheduler_thread.start()

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, threaded=True)
