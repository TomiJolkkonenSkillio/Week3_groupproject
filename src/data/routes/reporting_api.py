from flask import Blueprint, jsonify, request
from datetime import datetime, timedelta
from services.reporting_service import get_all_working_hours, upload_to_blob
import pandas as pd
from io import StringIO


# Create a Blueprint for reporting related routes
reporting_api = Blueprint('reporting_api', __name__)

@reporting_api.route('/', methods=['POST'])
def generate_report():
    try:
        data = get_all_working_hours()
        df = pd.DataFrame(data)
        csv_buffer = StringIO()
        df.to_csv(csv_buffer, index=False)
        csv_buffer.seek(0)
        upload_to_blob(csv_buffer.getvalue())
        print(df)
        return jsonify({'message': 'Report generated successfully'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500