variable "project_id" {
  description = "Google Cloud Platform (GCP) Project ID."
  type        = string

}

variable "region" {
  description = "GCP region name."
  type        = string
  default     = "asia-southeast2"
}

variable "zone" {
  description = "GCP zone name."
  type        = string
  default     = "asia-southeast2-a"
}

variable "name" {
  description = "Web server name."
  type        = string
  default     = "my-webserver"
}

variable "machine_type" {
  description = "GCP VM instance machine type."
  type        = string
  default     = "e2-standard-2"
}

variable "labels" {
  description = "List of labels to attach to the VM instance."
  type        = map
}