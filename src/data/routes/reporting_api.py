from flask import Blueprint, jsonify, request
from datetime import datetime, timedelta
from services.reporting_service import get_weekly_working_hours, upload_to_blob, manipulate_data
import pandas as pd
from io import StringIO


# Create a Blueprint for reporting related routes
reporting_api = Blueprint('reporting_api', __name__)

@reporting_api.route('/', methods=['POST'])
def generate_report():
    try:
        df = pd.DataFrame(get_weekly_working_hours())
        df = manipulate_data(df)
        upload_to_blob(df)
        # csv_buffer = StringIO()
        # df.to_csv(csv_buffer, index=False)
        # csv_buffer.seek(0)
        # upload_to_blob(csv_buffer.getvalue())
        # print(df)
        return jsonify({'message': 'Weekly report generated successfully'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500