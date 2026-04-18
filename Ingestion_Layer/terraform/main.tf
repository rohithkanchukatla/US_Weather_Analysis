terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.17.0"
    }
  }
}
provider "google" {
  project     = "de-zoomcampfinalproject"
  region      = "us-central1"
  credentials = file(var.credentials)
}


resource "google_storage_bucket" "climatedata_datalake_finalproj_2026" {
  name          = var.gcs_bucket_name
  location      = var.location_name
  force_destroy = true


  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_bigquery_dataset" "weather_dataset" {
  dataset_id  = "weather_dataset"
  description = "dataset for Weather DWH"
}