# Challenge 5: Online migration

[< Previous Challenge](./04-offline-cutover-validation.md) - **[Home](./README.md)** - [Next Challenge >](./06-online-cutover-validation.md)

## Coach Tips

The intent of this WTH is not to focus on networking so if the attendee has trouble configuring VPN/VNet peering, feel free to help them through it. 

## Introduction

Perform an online migration using the Azure Database Migration Service

## Steps -- PostgreSQL

Connect to the *source* database container and run the export on the source database :

```bash
kubectl -n postgresql exec deploy/postgres -it -- bash

pg_dump --section=pre-data -h localhost -U contosoapp wth >dump_wth.sql
```

This creates a psql dump text file. The option --section=pre-data causes pg_dump to dump definitions of all objects excluding indexes, triggers, rules, and constraints other than validated check constraints.

Now, we need to import it to the *target*. We import the schema only. It is suggested to create a separate database for online migration - wth2. 

Alternatively, you can drop all the tables and indices and re-create just the tables.

To drop all the tables with indexes, the following SQL script creates a file called drop_tables.sql which you can run in the next step to execute in SQL to drop the tables and indices. Then execute the drop_tables.sql script.

```bash

psql -h pgtarget.postgres.database.azure.com -U contosoapp@pgtarget -d wth 

\t
\out drop_tables.sql

select 'drop table ' || tablename || ' cascade;'  from pg_tables where tableowner = 'contosoapp' and schemaname = 'public' ;

\i drop_tables.sql

```

Another option to dropping and recreating all the tables is simply drop the database and re-create the database

```sql

drop database wth ;

create database wth ;

```

Next, import the schema to target

```bash
psql -h pgtarget.postgres.database.azure.com -U contosoapp@pgtarget -d wth < dump_wth.sql
```

Verify count of tables created on the target database from psql. You should see 26 tables.

```bash
\dt+
```

* For Azure DMS, the attendee needs to create a migration project in the DMS wizard. When they connect to the source, they will need the external IP which the attendee can get using the `kubectl -n postgresql get svc` command. 
* Make sure the radio buttons are checked for "Trust Server Certificate" and "Encrypt Connection"
* The user contosoapp does not have replication role enabled. They should get an error (Insufficient permission on server. 'userepl' permission is required to perform migration). To resolve this, connect to psql as superuser

```bash 
postgres=# alter role contosoapp with replication ;
```

* In DMS, if the attendee gets a connection error when trying to connect to the target service, check "Allow access to Azure Services" in the Azure Portal for the database. After migration, do a cutover and add all the constraints:

```bash
kubectl -n postgresql exec deploy/postgres -it -- bash

pg_dump --section=post-data -h localhost -U contosoapp wth | psql -h pgtarget.postgres.database.azure.com -U contosoapp@pgtarget wth
```


## Steps -- MySQL

The MySQL data-in replication is initiated from Azure DB for MySQL and pulls data from on-premises. As such the source database's public IP address needs to be whitelisted. 

The database tier has to be standard or memory optimized for the replication to work.

The attendees have to login to MySQL with the user they created when they set up Azure DB for MySQL to setup the replication using the mysql.az_replication_change_master stored procedure. 

The values for master_log_file and master_log_pos need to be retrieved using `show master status` on the source server not on Azure DB for MySQL. 

The default gtid_mode in the source database is ON and in Azure DB for MySQL it is Off. Both sides have to match before starting replication.
Since the wth database used for the challenges is not seeing a lot of transactions, the attendees can follow the MySQL [documentation](https://dev.mysql.com/doc/refman/5.7/en/replication-mode-change-online-disable-gtids.html) to change the parameter without stopping replication.





