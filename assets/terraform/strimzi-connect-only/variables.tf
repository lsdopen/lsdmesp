variable "strimzi_connect_only_bootstrap_server" {
  description = "The Strimzi Connect Only bootstrap server"
  type        = string
  default     = null
}

variable "strimzi_connect_only_aws_arn" {
  description = "The Strimzi Connect Only Scram AWS Role arn"
  type        = string
  default     = null
}
