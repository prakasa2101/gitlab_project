### Aurora Postgress Serverless V2

locals {
  aurora_cluster_name = "${var.project_name}-${var.environment}"

  engine_mode    = var.aurora_is_serverless != null ? "provisioned" : var.aurora_engine_mode
  instance_class = var.aurora_is_serverless != null ? "db.serverless" : var.aurora_instance_class

  # Basic Settings 
  parameters = merge(
    {
      "log_min_messages"         = "log"
      "log_min_error_statement"  = "log"
      "log_connections"          = 1
      "log_disconnections"       = 1
      "rds.log_retention_period" = 10080
      "rds.force_ssl"            = 1
      "log_rotation_age"         = 1440
      "log_filename"             = "postgresql.log.%Y-%m-%d"
      "client_min_messages"      = "warning"
      "lc_messages"              = "en_US.UTF-8"
      "lc_monetary"              = "en_US.UTF-8"
      "lc_numeric"               = "en_US.UTF-8"
      "lc_time"                  = "en_US.UTF-8"
    },
    var.aurora_cluster_db_parameters
  )

  # remap 
  db_cluster_parameters = [for k, v in local.parameters :
    {
      name         = k
      value        = v
      apply_method = "immediate"
    }
  ]

}

data "aws_rds_engine_version" "aurora" {
  engine  = var.aurora_engine
  version = var.aurora_engine_version
}

module "aurora" {
  source = "terraform-aws-modules/rds-aurora/aws"

  name = local.aurora_cluster_name

  # Engine 
  engine         = var.aurora_engine
  engine_mode    = local.engine_mode
  engine_version = var.aurora_engine_version

  # Encryption
  storage_encrypted = true
  kms_key_id        = module.kms_keys["rds-aurora"].arn

  #Instances  
  instance_class = local.instance_class
  instances = {
    one = {}
  }

  # Manage credentials in SecretManager
  master_username                                        = "postgres"
  manage_master_user_password                            = true
  manage_master_user_password_rotation                   = true
  master_user_password_rotation_automatically_after_days = 30


  # Monitoring
  create_cloudwatch_log_group            = true
  cloudwatch_log_group_retention_in_days = 7
  cloudwatch_log_group_kms_key_id        = module.kms_keys["cloudwatch-logs"].arn
  cloudwatch_log_group_class             = "STANDARD"
  enabled_cloudwatch_logs_exports        = ["postgresql"]

  monitoring_interval                   = 60
  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = true


  # Networking
  publicly_accessible    = false
  vpc_id                 = module.vpc.vpc_id
  create_db_subnet_group = false # Subnet group already created in VPC module
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  subnets                = module.vpc.database_subnets

  security_group_rules = {
    vpc_ingress = {
      cidr_blocks = module.vpc.private_subnets_cidr_blocks
    }
  }

  #Maintenance and Backup    
  apply_immediately            = true
  skip_final_snapshot          = true
  deletion_protection          = true
  preferred_backup_window      = var.aurora_preferred_backup_window
  preferred_maintenance_window = var.aurora_preferred_maintenance_window
  auto_minor_version_upgrade   = var.aurora_auto_minor_version_upgrade
  allow_major_version_upgrade  = var.aurora_allow_major_version_upgrade

  # Cluster and DB parameters
  create_db_cluster_parameter_group      = true
  db_cluster_parameter_group_name        = local.aurora_cluster_name
  db_cluster_parameter_group_family      = data.aws_rds_engine_version.aurora.parameter_group_family
  db_cluster_parameter_group_description = "${local.aurora_cluster_name} cluster parameter group"
  db_cluster_parameter_group_parameters  = local.db_cluster_parameters


  tags = local.tags



}

output "writer_endpoint" {
  value = module.aurora.cluster_endpoint
}
