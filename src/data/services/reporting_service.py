import psycopg2
from config import config, config_blob
from datetime import datetime, timedelta
from azure.storage.blob import BlobServiceClient


#fetching all working hours
def get_all_working_hours():
    try:
        with psycopg2.connect(**config()) as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM working_hours where start_time::date = CURRENT_DATE")
                rows = cur.fetchall()
                result = []
                for row in rows:
                    result.append({
                        "id": row[0],
                        "start_time": row[1],
                        "end_time": row[2],
                        "lunch_break": str(row[3]) if row[3] else None,
                        "consultant_name": row[4],
                        "customer_name": row[5]
                    })
                return result
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)

def upload_to_blob(data):
    config = config_blob()
    
    blob_service_client = BlobServiceClient.from_connection_string(config['connection_string'])
    blob_client = blob_service_client.get_blob_client(config["container_name"], blob="test_report.csv")
    blob_client.upload_blob(data, overwrite=True)

if __name__ == '__main__':
    # upload_to_blob()
    get_all_working_hours()