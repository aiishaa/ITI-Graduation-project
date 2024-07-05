
variable "docker_username" {
  type        = string
  description = "Docker registry username"
}

variable "docker_password" {
  type        = string
  description = "Docker registry password"
  sensitive   = true
}
