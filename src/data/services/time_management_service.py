import psycopg2
from config import config
from datetime import datetime, timedelta

#fetching all working hours
def get_all_working_hours():
    try:
        with psycopg2.connect(**config()) as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM working_hours")
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

#fetching working hours by id
def get_working_hours_by_id(record_id: int):
    try:
        with psycopg2.connect(**config()) as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM working_hours WHERE id = %s", (record_id,))
                row = cur.fetchone()
                return {
                    "id": row[0],
                    "start_time": row[1],
                    "end_time": row[2],
                    "lunch_break": str(row[3]) if row[3] else None,
                    "consultant_name": row[4],
                    "customer_name": row[5]
                }
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)

#create working hours entry
def create_working_hours(start_time: datetime, end_time: datetime, lunch_break: timedelta, consultant_name: str, customer_name: str):
    try:
        with psycopg2.connect(**config()) as conn:
            with conn.cursor() as cur:
                cur.execute(
                    """
                    INSERT INTO working_hours (start_time, end_time, lunch_break, consultant_name, customer_name)
                    VALUES (%s, %s, %s, %s, %s) RETURNING id
                    """,
                    (start_time, end_time, lunch_break, consultant_name, customer_name)
                )
                return cur.fetchone()[0]
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)

#update working hours by id
def update_working_hours(record_id: int, start_time: datetime, end_time: datetime, lunch_break: timedelta, consultant_name: str, customer_name: str):
    try:
        with psycopg2.connect(**config()) as conn:
            with conn.cursor() as cur:
                cur.execute(
                    """
                    UPDATE working_hours
                    SET start_time = %s, end_time = %s, lunch_break = %s, consultant_name = %s, customer_name = %s
                    WHERE id = %s
                    """,
                    (start_time, end_time, lunch_break, consultant_name, customer_name, record_id)
                )
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)

#delete working hours by id
def delete_working_hours(record_id: int):
    try:
        with psycopg2.connect(**config()) as conn:
            with conn.cursor() as cur:
                cur.execute("DELETE FROM working_hours WHERE id = %s", (record_id,))
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)

if __name__ == '__main__':
    print(get_all_working_hours())
