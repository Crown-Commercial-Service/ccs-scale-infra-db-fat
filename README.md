# ccs-scale-infra-db-fat

## SCALE Find a Thing (FaT) databases

### Overview
This repository contains a complete set of configuration files and code to deploy SCALE BaT databases the AWS cloud.  The infrastructure code is written in [Terraform](https://www.terraform.io/) and contains the following primary components:

- TODO

### Prerequisites - Setup master user credentials
Create 2 new secure string SSM parameters:

`{environment}-guided-match-db-master-username`
`{environment}-guided-match-db-master-password`

These will be referenced in the Terraform script. You will get a 'ParameterNotFound` error if these are not created before running the script.

### Connection to Database via Bastion Host
The Bastion Host EC2 instance provisioned in this project can be used tunnel SSH connections to access the Postgres Databases. 

1. You will need the pem file for the EC2 key pair - the key must match the name `{environment}-bastion-key`, e.g. `sbx1-bastion-key`.

2. You can then open a terminal and make the tunnel connection:
```
ssh -i {ENVIRONMENT}-bastion-key.pem -L 5432:{POSTGRES_DB_ENDPOINT}:5432 ubuntu@{EC2_PUBLIC_IP}
```

3. You can then access the database as if it were on localhost on your own machine

### Creating Tables & Indexes
After the database if provisioned, you need to connect to it and run the DDL scripts to provision the tables and indexes. All the scripts can be found here.

- [Database DDL Scripts](https://github.com/Crown-Commercial-Service/ccs-scale-db-scripts)

Select the script under `/agreements` to provision the agreements database contents.