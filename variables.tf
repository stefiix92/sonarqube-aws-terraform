variable "aws_region" {
  default = "eu-central-1"
}

variable "access_ip" {}

# database variables #
variable "db_engine_type" {
  type    = string
  default = "postgres"
}
variable "db_engine_version" {
  type    = string
  default = "13.3"
}
variable "db_instance_type" {
  type    = string
  default = "db.t3.micro"
}
variable "db_name" {
  type = string
}
variable "db_user" {
  type = string
}
variable "db_password" {
  type      = string
  sensitive = true
}
variable "public_key_path" {
  type = string
}

# sonarqube variables #
#variable "sonarqube_edition" {
#  type    = string
#  default = "developer"
#}

variable "sonarqube_version" {
  type    = string
  default = "9.0.1.46107"
}

variable "server_user_password" {
  type      = string
}