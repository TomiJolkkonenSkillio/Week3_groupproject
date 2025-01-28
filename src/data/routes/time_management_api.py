from flask import Blueprint, jsonify, request
from datetime import datetime, timedelta
from services.time_management_service import (
    get_all_working_hours,
    get_working_hours_by_id,
    create_working_hours,
    update_working_hours,
    delete_working_hours
)

# Create a Blueprint for time management related routes
time_management_api = Blueprint('time_management_api', __name__)

# Get all working_hours
@time_management_api.route('/', methods=['GET'])
def fetch_working_hours():
    try:
        working_hours = get_all_working_hours()
        return jsonify(working_hours), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Get working_hour by ID
@time_management_api.route('/<int:id>', methods=['GET'])
def fetch_working_hour(id):
    try:
        working_hour = get_working_hours_by_id(id)
        if working_hour:
            return jsonify(working_hour), 200
        return jsonify({'message': 'Working hours not found'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Create a new working_hour
@time_management_api.route('/', methods=['POST'])
def add_working_hour():
    try:
        data = request.json
        start_time = data.get('start_time')
        end_time = data.get('end_time')
        lunch_break = data.get('lunch_break')
        consultant_name = data.get('consultant_name')
        customer_name = data.get('customer_name')
        id = create_working_hours(start_time, end_time, lunch_break, consultant_name, customer_name)
        return jsonify({'id': id, 'message': 'Working hours created successfully'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Update a working_hour
@time_management_api.route('/<int:id>', methods=['PUT'])
def modify_working_hour(id):
    try:
        data = request.json
        start_time = data.get('start_time')
        end_time = data.get('end_time')
        lunch_break = data.get('lunch_break')
        consultant_name = data.get('consultant_name')
        customer_name = data.get('customer_name')
        update_working_hours(id, start_time, end_time, lunch_break, consultant_name, customer_name)
        return jsonify({'message': 'Working hours updated successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Delete a working_hour
@time_management_api.route('/<int:id>', methods=['DELETE'])
def remove_working_hour(id):
    try:
        delete_working_hours(id)
        return jsonify({'message': 'Working hours deleted successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500