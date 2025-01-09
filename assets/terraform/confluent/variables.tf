variable "enable-ingress-nginx" {
  description = "Should deploy nginx ingress controller"
  type        = bool
  default     = true
}

variable "enable-cert-manager" {
  description = "Should deploy cert manager"
  type        = bool
  default     = false
}

variable "enable-monitoring" {
  description = "Should enable monitoring"
  type        = bool
  default     = false
}

variable "enable-army-knife" {
  description = "Should enable army knife"
  type        = bool
  default     = true
}
