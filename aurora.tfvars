######################################################################################
##                                  Aurora  Variables                               ##
## Notes: *skip_final_snapshot = true so it can be easily deleted for test purposes ##
######################################################################################

aws_access_key = "###############"

aws_secret_key = "###################"

region = "eu-west-1"

aurora_username = "##########"

aurora_password = "##############"

instance_class = "###options-below###"
#following classes all available- CPU & memory to be taken into account 
#db.t2.small
#db.t2.medium
#db.r3.large
#db.r3.xlarge
#db.r3.2xlarge
#db.r3.4xlarge
#db.r3.8xlarge

vpc_id = "vpc-#######"

skip_final_snapshot = "true"

cidr_range_security_group  = "########"

cidr_range_az_1 = "########"

cidr_range_az_2 = "########"

publicly_accessible = "false"

auto_minor_version_upgrade = ""

preferred_maintenance_window = "sun:##:##-sun:##:##"

preferred_backup_window = "##:##-##:##"

apply_immediately = "true"

count = "#"

backup_retention_period = "#"

kms_arn = "#################"
