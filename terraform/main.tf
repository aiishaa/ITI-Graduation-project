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
}

module "jenkins" {
  source = "./jenkins"
}

module "MySQL" {
  source = "./Mysql"
}

module "nodejs" {
  source = "./nodeapp"
}

