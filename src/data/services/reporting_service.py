import psycopg2
from config import config, config_blob
from datetime import datetime, timedelta
from azure.storage.blob import BlobServiceClient
import pandas as pd
#TURHAA KOODIA:
    # #Grouping by consultant_name and start_time and summing up the work_hours
    # df = pd.merge(df, (df.groupby(["consultant_name", "start_time"]).agg(daily_working_hours=('work_hours', 'sum')).reset_index())[['daily_working_hours', 'consultant_name', "start_time"]], on=["consultant_name", "start_time"], how="left")
    # #Calculating the average of daily_working_hours per consultant
    # df = pd.merge(df, (df[~df.duplicated(subset=["consultant_name", "start_time"], keep="first")].groupby(["consultant_name"])["daily_working_hours"].mean().reset_index()), on=["consultant_name"], how="left")
    # #Calculating the total of daily_working_hours per consultant
    # df = pd.merge(df, (df.groupby(["consultant_name", "customer_name"]).agg(total_hours_customer=('work_hours', 'sum')).reset_index())[['total_hours_customer', 'consultant_name', "customer_name"]], on=["consultant_name", "customer_name"], how="left")
    # #Calculating the total of daily_working_hours per consultant
    # df = pd.merge(df, (df.groupby(["consultant_name"]).agg(total_hours_consultant=('work_hours', 'sum')).reset_index())[['total_hours_consultant', 'consultant_name']], on=["consultant_name"], how="left")
    # #Renaming columns
    # df.columns = ["Id", "Date", "Consultant Name", "Customer Name", "Working Hours Per Consult Per Day", "Working Hours Daily Total", "Working Hours Average Weekly Per Consultant", "Working Hours Weekly Total Per Customer Per Customer", "Working Hours Weekly Total Per Consultant"]
    # print(df)

#fetching all working hours
def get_weekly_working_hours():
    try:
        with psycopg2.connect(**config()) as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM working_hours WHERE start_time::date >= date_trunc('week', CURRENT_DATE) AND start_time::date < date_trunc('week', CURRENT_DATE) + INTERVAL '7 days';")
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

def manipulate_data(df: pd.DataFrame):
    # Creating column work_hours
    df["work_hours"] = pd.to_datetime(df['end_time']) - pd.to_datetime(df["start_time"])
    #Converting lunch_break to timedelta
    df["lunch_break"] = df["lunch_break"].apply(lambda x: pd.to_timedelta(x) if x != None else timedelta(hours=0))
    #Subtracting lunch_break from work_hours. This is now the value for work_hours
    df["work_hours"] = df["work_hours"] - pd.to_timedelta(df["lunch_break"])
    #Converting start_time to date
    df["start_time"] = pd.to_datetime(df["start_time"]).dt.strftime('%Y-%m-%d')
    #Dropping columns end_time and lunch_break, because they are not needed anymore
    df.drop(columns=["end_time", "lunch_break"], inplace=True)
    return df

def create_text_file(df: pd.DataFrame):
    text_file_data = f"Weekly Summary Report\n{'-'*50}\n\n"
    consult_text = "Consults:\n\n"
    customer_text = f"\n\n{'-'*50}\n\nCustomers:\n\n"
    consult_names = []
    customer_names = []

    for index, row in df.iterrows():
        if row["consultant_name"] not in consult_names:
            # print(row["consultant_name"])
            # print(df.loc[df['consultant_name'] == row['consultant_name'], 'work_hours'].sum())
            customer_list_per_consult = []
            consult_names.append(row["consultant_name"])
            consult_text += f"{row['consultant_name']:}\n"
            temp_timedelta = df.loc[df['consultant_name'] == row['consultant_name'], 'work_hours'].sum()
            consult_text += f"\tTotal weekly work: {f'{(temp_timedelta.seconds // 3600)}:{(temp_timedelta.seconds % 3600 // 60)}'}\n"
            for i, r in df.iterrows():
                if row["consultant_name"] == r["consultant_name"] and r["customer_name"] not in customer_list_per_consult:
                    customer_list_per_consult.append(r["customer_name"])
                    temp_timedelta = df.loc[df['customer_name'] == r['customer_name'], 'work_hours'].sum()
                    consult_text += f"\tWork for customer {r['customer_name']}: {f'{(temp_timedelta.seconds // 3600)}:{(temp_timedelta.seconds % 3600 // 60)}'}\n"
            consult_text += "\n"

        if row["customer_name"] not in customer_names:
            consult_list_per_customer = []
            customer_names.append(row["customer_name"])
            customer_text += f"{row['customer_name']:}\n"
            temp_timedelta = df.loc[df['customer_name'] == row['customer_name'], 'work_hours'].sum()
            customer_text += f"\tTotal weekly work: {f'{(temp_timedelta.seconds // 3600)}:{(temp_timedelta.seconds % 3600 // 60)}'}\n"
            for i, r in df.iterrows():
                if row["customer_name"] == r["customer_name"] and r["consultant_name"] not in consult_list_per_customer:
                    consult_list_per_customer.append(r["consultant_name"])
                    temp_timedelta = df.loc[df['consultant_name'] == r['consultant_name'], 'work_hours'].sum()
                    customer_text += f"\tWork by consult {r['consultant_name']}: {f'{(temp_timedelta.seconds // 3600)}:{(temp_timedelta.seconds % 3600 // 60)}'}\n"
            customer_text += "\n"
        
        
    text_file_data+= consult_text + customer_text
    return text_file_data

def upload_to_blob(data: pd.DataFrame):
    config = config_blob()
    name = f"daily_report_{datetime.now().strftime('%Y-%m-%d')}.csv"
    blob_service_client = BlobServiceClient.from_connection_string(config['connection_string'])
    blob_client = blob_service_client.get_blob_client(config["container_name"], blob=name)

    text_file_data = create_text_file(data)

    print(text_file_data)
    # blob_client.upload_blob(data, overwrite=True)

if __name__ == '__main__':
    # upload_to_blob()
    # get_all_working_hours()
    pass