#############
## Outputs ##
#############

# Output the ID of the RDS instance
output "rds_instance_id" {
  value = "${aws_rds_cluster.ice_cluster.id}"
}

# Output the address (aka hostname) of the RDS instance
output "rds_instance_address" {
  value = "${aws_rds_cluster.ice_cluster.address}"
}

# Output endpoint (hostname:port) of the RDS instance
output "rds_instance_endpoint" {
  value = "${aws_rds_cluster.ice_cluster.endpoint}"
}

# Output if storage is encrypted
output "storage_encrypted" {
 value = "${aws_rds_cluster.ice_cluster.storage_encrypted}"
}
