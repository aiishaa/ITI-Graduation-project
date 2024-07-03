variable "docker_username" {
  type        = string
  description = "Docker registry username"
}

variable "docker_password" {
  type        = string
  description = "Docker registry password"
  sensitive   = true
}

variable "mysql_root_password" {
  type        = string
  description = "The root password for MySQL"
  sensitive   = true
}

variable "mysql_user_password" {
  type        = string
  description = "The user password for MySQL"
  sensitive   = true
}

variable "mysql_username" {
  type        = string
  description = "The username for MySQL"
}

variable "mysql_database_name" {
  type        = string
  description = "The database name for MySQL"
}
