###############################################################################################
## Script to create the Aurora Cluster and Instances                                         ##
## Notes: *Couldn't get the parameter group to force the SSL connection, left commented out  ##
##        for future testing/if a workaround is available?                                   ##
###############################################################################################

#Configure AWS Defaults
provider "aws" {
        access_key      = "${var.aws_access_key}"
        secret_key      = "${var.aws_secret_key}"
        region          = "${var.region}"

}


#creating a subnet for AZ eu-west-1a
resource "aws_subnet" "db_subnet_1" {
	vpc_id		= "${var.vpc_id}"
	cidr_block	= "${var.cidr_range_az_1}"
	availability_zone = "eu-west-1a"
	tags {
		Name	= "ice-db-subnet-1"
		project = "ICE"
       		Region = "${var.region}"
        	RegionGroup = "EU"
	        PlatformTier = "F"
        	Environment = "DEV"
	        Team = "ICE"
        	Application = "AuroraSubnet"
	        ApplicationClassInstance = "${var.instance_class}"
	        DataClass = "INT"

	}
}


#creating a subnet for AZ eu-west-1b
resource "aws_subnet" "db_subnet_2" {
        vpc_id          = "${var.vpc_id}"
        cidr_block      = "${var.cidr_range_az_2}"
	availability_zone = "eu-west-1b"
        tags {
                Name    = "ice-db-subnet-2"
                project = "ICE"
                Region = "${var.region}"
                RegionGroup = "EU"
                PlatformTier = "F"
                Environment = "DEV"
                Team = "ICE"
                Application = "AuroraSubnet"
                ApplicationClassInstance = "${var.instance_class}"
                DataClass = "INT"

        }
}


#creating a subnet group for the above subnets
resource "aws_db_subnet_group" "db_sg_ice" {
	name 		= "db_sg_ice"
	subnet_ids	= ["${aws_subnet.db_subnet_1.id}", "${aws_subnet.db_subnet_2.id}"]
	tags {
		Name	= "db_sg_ice"
		project = "ICE"
                Region = "${var.region}"
                RegionGroup = "EU"
                PlatformTier = "F"
                Environment = "DEV"
                Team = "ICE"
                Application = "AuroraSubnetGroup"
                ApplicationClassInstance = "${var.instance_class}"
                DataClass = "INT"

	}
}


#creating a security group to allow access to the DB
resource "aws_security_group" "aurora_security_group" {
  name = "aurora_security_group"
  description = "SG to allow connection to aurora db"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    cidr_blocks = ["${var.cidr_range_security_group}"]	
}
    tags {
	Name = "aurora_security_group" 
}
}


#######COULD NOT GET THESE PERAMETER GROUPS TO WORK- MUST BE DIFF TO RDS SQL DB#####
#######Seems to create the parameter groups but cannot "find" them...creating too fast?#######
#######Left in incase a solution is easily found######
#creating parameter group fo force SSL connection to the DB Cluster
#resource "aws_rds_cluster_parameter_group" "aurora_ssl" {
#  name        = "database"
#  family      = "aurora5.6"
#
#  parameter {
#    name         = "rds.force_ssl"
#    value        = "1"
#    apply_method = "immediate"
#  }
#}


#creating parameter group to force SSL connection to the DB instance
#resource "aws_db_parameter_group" "aurora_ssl" {
#  name   = "database"
#  family = "aurora5.6"
#
#  parameter {
#    name         = "rds.force_ssl"
#    value        = "1"
#    apply_method = "immediate"
#  }
#}



#Building the cluster for the Aurora Instances
resource "aws_rds_cluster" "ice_cluster" {
  cluster_identifier      = "ice-aurora-cluster"
  database_name           = "ICE_AURORA"
  master_username         = "${var.aurora_username}"
  master_password         = "${var.aurora_password}"
  backup_retention_period = "${var.backup_retention_period}"
  preferred_backup_window = "${var.preferred_backup_window}"
  preferred_maintenance_window = "${var.preferred_maintenance_window}"
  storage_encrypted 	  = true
  db_subnet_group_name    = "${aws_db_subnet_group.db_sg_ice.id}"
  skip_final_snapshot	  = "${var.skip_final_snapshot}"
  vpc_security_group_ids  = ["${aws_security_group.aurora_security_group.id}"]
  apply_immediately 	  = "${var.apply_immediately}"
#  db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.aurora_ssl.id}"
  kms_key_id 		  = "${var.kms_arn}"

  tags {
		Name	  = "aurora_db_ice"
		project   = "ICE"
                Region = "${var.region}"
                RegionGroup = "EU"
                PlatformTier = "D"
                Environment = "DEV"
                Team = "ICE"
                Application = "AuroraCluster"
                ApplicationClassInstance = "${var.instance_class}"
                DataClass = "INT"
  }
}


#building the instance to go into the cluster
#count uses meta-parameter to make multiple instances and join them all to the same RDS Cluster
#OR you may specify different Cluster Instance resources with various instance_class sizes.

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = "${var.count}"
  identifier         = "ice-aurora-cluster-${count.index}"
  cluster_identifier = "${aws_rds_cluster.ice_cluster.id}"
  instance_class     = "${var.instance_class}"
  publicly_accessible = "${var.publicly_accessible}"
  db_subnet_group_name = "${aws_db_subnet_group.db_sg_ice.id}"
  apply_immediately  = "${var.apply_immediately}"
  preferred_maintenance_window = "${var.preferred_maintenance_window}"
  auto_minor_version_upgrade = "${var.auto_minor_version_upgrade}"
#  db_parameter_group_name = "${aws_db_parameter_group.aurora_ssl.id}"
 
tags { 
	Name = "TerraformAurora"
 	Region = "${var.region}"
 	RegionGroup = "EU"
 	PlatformTier = "D"
 	Environment = "DEV"
 	Team = "ICE"
 	Application = "AURORA"
	ApplicationClassInstance = "${var.instance_class}"
	DataClass = "INT"
}
}

