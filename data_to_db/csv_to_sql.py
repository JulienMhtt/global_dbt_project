from sqlalchemy import create_engine
import pandas as pd
import glob
import os
import logging

# Setup logging
logging.basicConfig(filename='data_import.log', level=logging.DEBUG,
                    format='%(asctime)s - %(levelname)s - %(message)s')

# Environment variables
db_host = "localhost"
db_user = "user_dbt_project"
db_password = "password_dbt_project"
db_name = "db_dbt_project"

# Connection string
connection_string = f'postgresql://{db_user}:{db_password}@{db_host}/{db_name}'

try:
    engine = create_engine(connection_string)
except Exception as e:
    logging.error(f"Error connecting to database: {e}")
    # Exit the script or take alternative action
    exit(1)

# Directory where your CSV files are located
csv_directory = './data/'

# Function to check if a file has been successfully processed
def is_file_processed(filename):
    try:
        with open('success_files.log', 'r') as f:
            processed_files = f.read().splitlines()
        return filename in processed_files
    except FileNotFoundError:
        return False

# Function to log a successfully processed file
def log_success_file(filename):
    with open('success_files.log', 'a') as f:
        f.write(f"{filename}\n")

# Automatically list all CSV files in the directory
csv_files = glob.glob(os.path.join(csv_directory, '*.csv'))

for file_path in csv_files:
    csv_filename = os.path.splitext(os.path.basename(file_path))[0].lower()
    
    # Skip processing if file has already been successfully processed
    if is_file_processed(csv_filename):
        logging.info(f"Skipping {csv_filename}, already processed.")
        continue

    try:
        if not os.path.exists(file_path):
            raise FileNotFoundError(f"File {file_path} not found.")
        df = pd.read_csv(file_path)
        df.to_sql(csv_filename, engine, if_exists='replace', index=False)
        logging.info(f"Successfully imported {csv_filename}")
        # Log the successful import
        log_success_file(csv_filename)
    except FileNotFoundError as fnf_error:
        logging.error(fnf_error)
    except pd.errors.EmptyDataError as ede:
        logging.error(f"No data: {ede} in file {csv_filename}.")
    except Exception as e:
        logging.error(f"An unexpected error occurred with {csv_filename}: {e}")

# After the loop, log an empty line to separate batches
logging.info("\n")
