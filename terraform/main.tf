terraform {
  backend "s3" {
    bucket         = "project-terraform-s3-remote-backend"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
  }
}

module "namespaces" {
  source     = "./namespaces"
  namespaces = ["tools", "dev"]
}

module "nexus" {
  source = "./nexus"

  docker_username = var.docker_username
  docker_password = var.docker_password
}

module "jenkins" {
  source = "./jenkins"
}

module "MySQL" {
  source = "./Mysql"

  mysql_root_password = var.mysql_root_password
  mysql_user_password = var.mysql_user_password
  mysql_username      = var.mysql_username
  mysql_database_name = var.mysql_database_name
}

module "nodejs" {
  source = "./nodeapp"
}
