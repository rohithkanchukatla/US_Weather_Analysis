# 🌎 A Nation of Extremes: Weather Data Engineering Pipeline

![Python](https://img.shields.io/badge/Python-3.10-blue)
![Prefect](https://img.shields.io/badge/Orchestration-Prefect-orange)
![GCP](https://img.shields.io/badge/Cloud-GCP-green)
![dbt](https://img.shields.io/badge/Transformation-dbt-yellow)
![BigQuery](https://img.shields.io/badge/Warehouse-BigQuery-blueviolet)

---

## 📌 Problem Statement

> **How do regional geographic locations in the US impact the frequency and severity of extreme weather events like heavy rain and heatwaves?**

This project builds a data pipeline to analyze weather data across major U.S. climate regions for the years 2024–2025, enabling structured analytics and visualization.

---

## 📊 Reports

### 📈 Regional Climate Gap: Daily Temperature Trends

![Climate Gap](https://github.com/user-attachments/assets/de135ffa-0b4e-444e-b118-3a69a6cd7451)

✔ Highlights seasonal variation  
✔ Shows temperature differences across climate regions  

---

### 🌧️ Heavy Rain vs Clear Days by Region

![Rain vs Clear](https://github.com/user-attachments/assets/96e6e431-1096-4734-b1db-44d56998b476)

✔ Compares extreme precipitation events  
✔ Identifies high-rainfall regions (e.g., Gulf Coast)  

---

## 🏗️ Architecture





---

## ⚙️ Tech Stack

| Layer | Tools |
|------|------|
| Infrastructure | Terraform |
| Orchestration | Prefect |
| Ingestion | Python (Requests, Pandas) |
| Storage | Google Cloud Storage (GCS) |
| Data Warehouse | BigQuery |
| Transformation | dbt |
| Visualization | Looker Studio |

---

## 🔄 Pipeline Overview

### 🟢 Ingestion Layer
- Extracts data from NOAA GSOD API  
- Processes 5 U.S. stations  
- Stores data in GCS as **partitioned Parquet files**


---

##  ⏱️ Batch Processing
- The pipeline is made to run daily using Prefect deployment.
- Currently, to keep things simple, the pipeline processes selected historical years (2024–2025), but it can be extended to support dynamic year selection so
  the batch processing makes more sense.
- That will allow automated ingestion of data from NOAA GSOD API
- Future enhancements can include incremental ingestion and backfill strategies.
 
- I have configured my prefect deployment to  run on a **daily schedule** as an example
<img width="1596" height="891" alt="image" src="https://github.com/user-attachments/assets/7bff9dac-9329-44d5-9d68-a83d2c4a897b" />

---

### 🟡 Storage Layer
-Gcs bucket
<img width="1270" height="485" alt="image" src="https://github.com/user-attachments/assets/bb279895-939a-4383-9475-34debfef29d7" />


---

### 🔵 Transformation Layer (dbt)
- **Staging** → Data cleaning  
- **Intermediate** → Standardization  
- **Marts** → Business-ready models

Medallion Architecture
<img width="1538" height="430" alt="image" src="https://github.com/user-attachments/assets/6763e10a-c5f6-4666-9beb-7f5629a7533c" />



Outputs:
- Fact table  
- Dimension table  
- Enriched data table 

---

### 📊 Reporting Layer
- Looker Studio connected to BigQuery  
- Dashboards built to answer problem statement  

---

## 🧱 Data Model

### ⭐ Fact Table
- Temperature metrics  
- Precipitation  
- Flags:
  - Heatwave  
  - Freeze  
  - Heavy rain  

---

### 📘 Dimension Table
- Station ID  
- Climate region  
- State  

---

## 🔁 Reproducibility Guide

###⚠️ Notes for later
Prefect blocks require manual setup
Python must be installed locally
Deployment YAML uses relative paths for portability

Follow these steps to run the project:
---

### 1️⃣ Clone Repository


git clone <your-repo-url>
cd US_Weather_Analysis

###2️⃣ Setup Infrastructure (Terraform)
cd terraform
terraform init
terraform apply

###3️⃣ Start Prefect Server
docker-compose up
👉 Open UI: http://localhost:4200

###4️⃣ Configure Prefect Blocks (Manual Step)
<img width="975" height="478" alt="image" src="https://github.com/user-attachments/assets/7eee8155-ebb4-465b-b1c1-67a8d9b8691d" />

🔐 GCP Credentials Block
Add service account JSON
🪣 GCS Bucket Block
Bucket name must match your GCS bucket
<img width="975" height="687" alt="image" src="https://github.com/user-attachments/assets/81b5e25b-c16b-47dc-91bf-dcec9374c0bd" />

Link both GCP Credentials Block and GCS Bucket Block by clicking the Add button in the above image when creating the Gcs Bucket block.

###5️⃣ Run Ingestion Pipeline
python3 ingest_weather.py
to register the first flow in the prefect server, and load data to GCS.

###6️⃣ Create a Deployment (Batch Scheduling)
prefect deployment apply deployment.yaml
Will create a daily batch scheduling pipeline.

###7️⃣ Run dbt Transformations
cd dbt_project
dbt run
dbt test

###8️⃣ View Dashboards
Open Looker Studio
Connect to BigQuery
Use:
Fact table
Dimension table
Enriched data table









