import pandas as pd
from io import BytesIO
import requests
from prefect import flow, task
from prefect_gcp.cloud_storage import GcsBucket
from prefect_gcp import GcpCredentials


# 5 representative US stations
STATIONS = {
    "NYC_LGA": "72503014732.csv",
    "LAX": "72295023174.csv",
    "HOUSTON": "72243012960.csv",
    "CHICAGO": "72530094846.csv",
    "MIAMI": "72202012839.csv"
}

@task(retries=3, log_prints=True)
def extract_weather(year: int, station_id: str):
    """ Extract data from NOAA GSOD"""
    url = f"https://www.ncei.noaa.gov/data/global-summary-of-the-day/access/{year}/{station_id}"
    r = requests.get(url)
    if r.status_code == 200:
        return pd.read_csv(BytesIO(r.content))
    r.raise_for_status()


@task(log_prints=True)
def load_to_gcs(df: pd.DataFrame, year: int, station_name: str):
   
    ##Define the target path in your bucket
    path = f"raw/weather/year={year}/{station_name}.parquet"
    gcs_bucket = GcsBucket.load("gcs-bucket-block")
    gcs_bucket.upload_from_dataframe(
        df=df, 
        to_path=path, 
        serialization_format="parquet"
    )
    return path
    

@flow(name="US Climate Pulse Ingestion")
def us_weather_ingestion_flow(years: list = [2024, 2025]):
    """The main manager for your orchestrated DAG [cite: 154, 574]"""
    for year in years:
        for name, station_id in STATIONS.items():
            raw_data = extract_weather(year, station_id)
            if raw_data is not None:
                load_to_gcs(raw_data, year, name)

if __name__ == "__main__":
    us_weather_ingestion_flow()