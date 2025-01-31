from flask import Blueprint, jsonify, request, current_app
from services.reporting_service import get_weekly_working_hours, upload_to_blob, manipulate_data, download_file
import pandas as pd
from apscheduler.schedulers.background import BackgroundScheduler


# Create a Blueprint for reporting related routes
reporting_api = Blueprint('reporting_api', __name__)

# Create a function for generating a weekly report manually
@reporting_api.route('/', methods=['POST'])
def generate_report():
    try:
        df = pd.DataFrame(get_weekly_working_hours())
        df = manipulate_data(df)
        upload_to_blob(df)
        return download_file(df)
        # return jsonify({'message': 'Weekly report generated successfully'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500