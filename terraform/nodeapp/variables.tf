variable "docker_server" {
  type        = string
  description = "Docker registry server URL"
}

variable "docker_username" {
  type        = string
  description = "Docker registry username"
}

variable "docker_password" {
  type        = string
  description = "Docker registry password"
  sensitive   = true
}
