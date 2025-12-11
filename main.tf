provider "aws"{
    region = var.region
}

module "network"{
    source = "./modules/network"
}

module "app-services"{
    source = "./modules/app-services"
    rdsPassword = var.rdsPassword 
    namePrefix = var.namePrefix
    region = var.region
    security_group_id_aws_server = module.network.aws_sg_id_output
    security_group_id_db = module.network.db_sg_id_output
}