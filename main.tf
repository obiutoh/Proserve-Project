# Main Project_VPC


resource "aws_vpc" "Project_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Project_vpc"
  }
}


# Public Subnet_1

resource "aws_subnet" "Public1_Subnet" {

  vpc_id     = aws_vpc.Project_vpc.id
  cidr_block = "10.0.9.0/24"
  
  
     
    availability_zone = "eu-west-1a"
    tags = {
       Name = "Public1_Subnet"
  }
}


# Public Subnet_2

resource "aws_subnet" "Public2_Subnet" {
  vpc_id     = aws_vpc.Project_vpc.id
    cidr_block = "10.0.2.0/24"
  
 availability_zone = "eu-west-1b"
 
    
       tags = {
         Name = "Public2_Subnet"
  }
}



# Private Subnet_1

resource "aws_subnet" "Private3_Subnet" {
  vpc_id     = aws_vpc.Project_vpc.id
  cidr_block = "10.0.3.0/24"

     
    availability_zone = "eu-west-1b"
    tags = {
       Name = "Private3_Subnet"
  }
}

# Private Subnet_2

resource "aws_subnet" "Private4_Subnet" {
  vpc_id     = aws_vpc.Project_vpc.id
  cidr_block = "10.0.4.0/24"

  
     
    availability_zone = "eu-west-1c"
    tags = {
       Name = "Private4_Subnet"
  }
}




# The Private Route Table


resource "aws_route_table" "PrivateRoute_Table" {
  vpc_id = aws_vpc.Project_vpc.id

  
  tags = {
    Name = "PrivateRoute_Table"
  }
}


# The Public Route Table

resource "aws_route_table" "PublicRoute_Table" {
  vpc_id = aws_vpc.Project_vpc.id

  
  tags = {
    Name = "PublicRoute_Table"
  }
}

# The association of Public Subnets With Public Route Table_Public Subnet_1

resource "aws_route_table_association" "Project4_Routetable1" {
  subnet_id      = aws_subnet.Public1_Subnet.id
  route_table_id = aws_route_table.PublicRoute_Table.id
}


# The Second association of Public Subnets With Public Route Table_Public Subnet_2

resource "aws_route_table_association" "Projectx_Routetable2" {
  subnet_id      = aws_subnet.Public2_Subnet.id
  route_table_id = aws_route_table.PublicRoute_Table.id
  }


# The first association of Private Subnets With Public Route Table_Public Subnet_2

resource "aws_route_table_association" "PrivateRoute_Table1" {
  subnet_id      = aws_subnet.Private3_Subnet.id
  route_table_id = aws_route_table.PrivateRoute_Table.id
}

resource "aws_route_table_association" "PrivateRoute_Table2" {
  subnet_id      = aws_subnet.Private4_Subnet.id
  route_table_id = aws_route_table.PrivateRoute_Table.id
}


# The_Internet Gateway 


resource "aws_internet_gateway" "internet-Project10" {
  vpc_id       = aws_vpc.Project_vpc.id

  tags = {
    Name       = "internet-Project10"
  }
}


# Connect of Routable and Internet Gate Way

# Conection of Route to Internet GW And Pub-Route


resource "aws_route" "Public-route-igw" {
  route_table_id            = aws_route_table.PublicRoute_Table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.internet-Project10.id   
              
} 




