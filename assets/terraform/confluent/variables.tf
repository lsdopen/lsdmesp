variable "enable-ingress-nginx" {
  description = "Should deploy nginx ingress controller"
  type        = bool
  default     = true
}

variable "enable-monitoring" {
  description = "Should enable monitoring"
  type        = bool
  default     = false
}
