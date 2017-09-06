#########################################
## Variables to feed into .tfvars file ##
#########################################

variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "region" {}

variable "aurora_username" {}

variable "aurora_password" {}

variable "instance_class" {}

variable "vpc_id" {}

variable "skip_final_snapshot" {}

variable "cidr_range_security_group" {}

variable "cidr_range_az_1" {}

variable "cidr_range_az_2" {}

variable "publicly_accessible" {}

variable "auto_minor_version_upgrade" {}

variable "preferred_maintenance_window" {}

variable "preferred_backup_window" {}

variable "apply_immediately" {}

variable "count" {}

variable "backup_retention_period" {}

variable "kms_arn" {}

