resource "aws_db_instance" "sql" {
    identifier                = "sql"
    allocated_storage         = 5
    backup_retention_period   = 2
    backup_window             = "01:00-01:30"
    maintenance_window        = "sun:03:00-sun:03:30"
        engine                    = "mysql"
    engine_version            = "5.7"
    instance_class            = "db.t2.micro"
    name                      = "worker_db1"
    username                  = "person"
    password                  = "tracy321"
    port                      = "3306"
    db_subnet_group_name      = aws_db_subnet_group.database_subnet_group.id
    vpc_security_group_ids    = [aws_security_group.ecs_seurity.id, aws_security_group.rds_securitygroup.id]
    skip_final_snapshot       = true
    final_snapshot_identifier = "worker-end"
    publicly_accessible       = false
}




# DB Subnet

resource "aws_db_subnet_group" "database_subnet_group" {
    name = "database_subnet_group"

    subnet_ids  = [aws_subnet.Private3_Subnet.id, aws_subnet.Private4_Subnet.id]

    tags = {
        Name = "database-subnet"
}
}




