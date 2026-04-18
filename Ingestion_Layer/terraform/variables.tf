variable "bq_dataset_name" {
  description = "My bigquery dataset name"
  default     = "bq_dataset"
}

variable "gcs_bucket_name" {

  description = "my storage bucket name"
  default     = "climatedata_datalake_finalproj_2026"
}

variable "location_name" {

  description = "my location name"
  default     = "US"
}

variable "credentials" {
  description = "terraform accessing gcp credentials"
  default     = "./service_account.JSON"

}