#Problem Statement
##How do regional geographic locations in the US impact the frequency and severity of extreme weather events like heavyrains, heatwaves and heavy precipitation?”

This project builds an end-to-end batch data pipeline to analyze  weather data across major U.S. climate regions for the years 2024 and 2025
and derive insights through structured modeling and dashboards.

<img width="975" height="645" alt="image" src="https://github.com/user-attachments/assets/de135ffa-0b4e-444e-b118-3a69a6cd7451" /> 
This report compares daily maximum temperatures across different U.S. climate regions, highlighting consistent differences in temperature patterns. 

<img width="975" height="646" alt="image" src="https://github.com/user-attachments/assets/96e6e431-1096-4734-b1db-44d56998b476" />
This report compares the frequency of heavy rain days versus clear days across different climate regions. It highlights that regions like the Gulf Coast experience significantly more heavy rainfall compared to others.


#Data pipeline flow architecture:
NOAA API
   ↓
Python Ingestion Script (Prefect Flow)
   ↓
Google Cloud Storage (Raw Layer )
   ↓
BigQuery (Data Warehouse)
   ↓
dbt (Staging → Intermediate → Marts)
   ↓
Fact + Dimension Tables (Star Schema)
   ↓
Looker Studio Dashboard

#Tech Stack
Infrastructure → Terraform (GCS Bucket, BigQuery Dataset)
Orchestration → Prefect
Ingestion → Python (Requests, Pandas)
Storage (Data Lake) → Google Cloud Storage (GCS)
Data Warehouse → BigQuery
Transformation → dbt (Medallion Architecture)
Visualization → Looker Studio

#Data Pipeline Overview
##1. Ingestion Layer
Extracts weather data from NOAA GSOD API
Processes data for selected U.S. stations
Loads data into GCS as partitioned Parquet files
##2. Batch Processing (Prefect)
Flow defined using Prefect
Deployment created using deployment.yaml
Scheduled to run daily for batch ingestion
##3. Storage Layer
Raw data stored in GCS:
raw/weather/year=YYYY/station_name.parquet
##4. Transformation Layer (dbt)
Staging models clean raw data
Intermediate models standardize transformations
Marts layer builds:
Fact table (weather metrics)
Dimension table (station metadata)
Enriched model (joined dataset)
##5. Reporting Layer
Looker Studio connected to BigQuery
Built 2 analytical dashboards to answer problem statement


#Data Model
⭐ Fact Table
Temperature metrics
Precipitation
Extreme event flags:
Heatwave
Freeze
Heavy rain

📘 Dimension Table
Station id
Climate region
State

#Reproducibility Guide

##1. Clone Repository
git clone <your-repo-url>
cd US_Weather_Analysis
##2. Setup Infrastructure (Terraform)
cd terraform
terraform init
terraform apply

This creates:
GCS bucket
BigQuery dataset


##3. Start Prefect Server (Docker)
docker-compose up

 Open Prefect server UI accessible at http://localhost:4200

##Configure Prefect Blocks (Manual Step)
In Prefect UI:
Search for Gcp integrations:
<img width="975" height="478" alt="image" src="https://github.com/user-attachments/assets/725e083d-64f3-4438-b337-9d13b0ce2831" />

Create a GCP Credentials Block, where in paste the service account details so prefect server can authenticate with GCP.
And Create GCS Bucket Block, very important in the bucket name make sure you have the same name that you have set in GCP.
<img width="975" height="687" alt="image" src="https://github.com/user-attachments/assets/a06e0fe9-c6c7-49c8-8abb-d5358f44dc79" />

--Once you enter the bucket name, For the GCP credentials, when you hit the Add button shown in the image,
the gcp credentials block that you have created before will show up, select that save the block.

##5. Run Ingestion Pipeline
python3 ingest_weather.py

👉 This registers the flow and ingests data into GCS bucket.

##6. Create Deployment (Batch Scheduling)
prefect deployment apply deployment.yaml

👉 This sets up:
Daily scheduled batch pipeline


##7. Run dbt Transformations
cd dbt_project
dbt run
dbt test

Eventually you can run reports in Looker studio with the fact, dimension and enriched_data table for analytics.










