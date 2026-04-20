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

<img width="975" height="532" alt="image" src="https://github.com/user-attachments/assets/4cc362dd-8a6c-4d47-864a-6412c6efe460" />





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
- Stores data in GCS as **Parquet files**

 <img width="975" height="391" alt="image" src="https://github.com/user-attachments/assets/8b2bdc4f-507e-4dad-ad4c-630bcabe380e" />



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

# 🔁 Reproducibility & Deployment Guide

 Follow the steps below to replicate the infrastructure, orchestration, and transformation layers.

### ⚠️ Prerequisites
* **Python 3.9+** installed locally.
* **Docker & Docker Compose** (for Prefect Server).
* **GCP Service Account** with `Storage Admin` and `BigQuery Admin` roles.

1️⃣ **Clone Repository**

```
git clone <this repo url>
cd US_Weather_Analysis
```

2️⃣ **Infrastructure as Code (Terraform)**
Provision GCP resources including the GCS bucket and BigQuery warehouse.

```
cd terraform
terraform init
terraform apply
```
*Resources created:*
GCS Bucket: Raw data landing zone.
BigQuery Dataset: Warehouse for staging and production models.

3️⃣ **Start Prefect Server**
Spin up the orchestration engine using Docker.

```
docker-compose up -d
```
👉 Prefect UI: http://localhost:4200

4️⃣ **Configure Prefect Blocks**
To keep the pipeline secure and dynamic, you must configure two blocks in the Prefect UI:

*🔐 GCP Credentials Block*

Block Name: gcp-creds

Add your Service Account JSON. This allows Prefect to authenticate with your GCP project.
<img width="975" height="478" alt="image" src="https://github.com/user-attachments/assets/8c965227-314b-4964-b386-3198c2ef568d" />

*🪣 GCS Bucket Block*

Block Name: weather-bucket
Create gcs bucket block
Link the gcp-creds block and specify your bucket name.
<img width="975" height="687" alt="image" src="https://github.com/user-attachments/assets/11823536-4e34-4e0c-a6bc-579f10dfe57c" />

5️⃣ **Run Ingestion Pipeline**
This script extracts data from the weather API, cleans it using Pandas, and persists it to GCS as Parquet files.
```
python3 ingest_weather.py
```

6️⃣ **Pipeline Deployment (Batch Scheduling)**
Register the flow and apply the batch schedule via the deployment manifest.

```
prefect deployment apply deployment.yaml
```
7️⃣ **Analytics Engineering (dbt)**
Transforming raw data into a production-ready Star Schema.

```
cd dbt_project
dbt run
dbt test
```
Staging: Schema enforcement and renaming.

Intermediate: Flagging "Extreme" events (Heatwaves/Heavy Rain).

Marts: Fact and Dimension tables optimized for BI.

8️⃣ **Visualization (Looker Studio)**
Connect: Link Looker Studio to your BigQuery Marts.

Join: Link fct_weather_readings and dim_stations on station_id.

Visualize: Create Frequency and Severity tiles to analyze the regional "Climate Gap."















