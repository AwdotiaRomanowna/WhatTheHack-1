# Challenge 5: Online migration

[< Previous Challenge](./04-offline-cutover-validation.md) - **[Home](../README.md)** - [Next Challenge >](./06-online-cutover-validation.md)

## Introduction

Perform an online migration using the Azure Database Migration Service

## Description
In this challenge you will do a migration of the database by setting up a replication from On-Premise to Azure Database. 

For Postgres, you will use Azure Data Migration Serice Tool to do this. 
For MySQL, You will not use DMS - instead use MySQL replication.

In an actual production environment on-premises, you would need to have connectivity to your source databases to Azure using either a Site To Site VPN or Azure ExpressRoute. To simplify the DMS experience, here you would connect from DMS to the On-Prem Postgres database using private IP address without VNet Peering. Optionally, you can create a separate Vnet for DMS and then establish a Vnet peering to the source database.

To simplify MySQL data-in replication, you can use the public IP.



## Success Criteria

* Demonstrate that all tables have been migrated successfully to Azure DB for PostgreSQL/MySQL "

## Hints -- Postgres

* Use the Premium version of the Azure Database Migration Service for migrating Postgres.
* Put the Database Migration Service in its own subnet inside the same Vnet that on-prem AKS uses - "OSSDBMigrationNet". This way it can connect to source database using private IP address.
* To find out the private IP address for the Postgres On-Prem 

```bash

kubectl describe service -n postgresql postgres-external | grep Endpoints

```

* You may have to drop open database connections if you are coming from a prior challenge where you ran the application. Alternatively, you could uninstall the web application(s) using helm, drop the database(s) and redeploy the application using helm. 

## Hints -- MySQL


* For MySQL, use data-in [replication](https://docs.microsoft.com/en-us/azure/mysql/concepts-data-in-replication)
* Use Public IP address for the replication
* "GTID Mode" parameters have 4 possible values and it can only be changed from one to its adjacent value on either sides ( OFF <---> OFF_PERMISSIVE <---> ON_PERMISSIVE
<---> ON )


## References

* [Minimal-downtime migration to Azure Database for PostgreSQL - Single Server](https://docs.microsoft.com/en-us/azure/postgresql/howto-migrate-online)
* [Migrate PostgreSQL to Azure DB for PostgreSQL online using DMS via the Azure Portal](https://docs.microsoft.com/en-us/azure/dms/tutorial-postgresql-azure-postgresql-online-portal)
* [Migrate PostgreSQL to Azure DB for PostgreSQL online using DMS via the Azure CLI](https://docs.microsoft.com/en-us/azure/dms/tutorial-postgresql-azure-postgresql-online)
* [Create, change, or delete a virtual network peering](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-peering)   [Optional, only if you use seperate Vnet for DMS ]
* [Add a subnet to a Virtual Network](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-subnet#add-a-subnet)
* [Configure Azure MySQL data-in replication](https://docs.microsoft.com/en-us/azure/mysql/howto-data-in-replication)



