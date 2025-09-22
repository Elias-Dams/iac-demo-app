variable "location" {
  description = "Location of the resource"
  type        = string
  default     = "westeurope"
}

variable "environment" {
  description = "Name of the environment of the resources"
  type        = string
  default     = "dev"
}

variable "default_tags" {
  type        = map(string)
  description = "set of default tags to apply everywhere"
}

variable "subscription_id" {
  type        = string
  description = "the subscription id to deploy resources into"
}

variable "mailfunction_blob_name" {
  type        = string
  description = "Name of the function package blob"
  default     = "mailfunction.zip"
}


variable "tags" {
  type        = map(string)
  description = "additional tags to apply to resources"
  default = {
    env   = "dev"
    owner = "elias"
  }
}