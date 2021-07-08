# Challenge 3: Offline migration

[< Previous Challenge](./02-size-analysis.md) - **[Home](./README.md)** - [Next Challenge >](./04-offline-cutover-validation.md)

## Coach Tips

1. When creating Azure DB for PostgreSQL/MySQL, create it in the GP or MO tier - as Basic tier does not support Private Link, required in a future challenge.

2. If the attendees want to connect to Azure DB for PostgreSQL/MySQL from within the AKS PostgreSQL/MySQL, they have two optoins.

a)  Either under connection security, check the box for "Allow access to Azure services" 

or

b) Add the public IP address of the container to the DB firewall.  This is the IP address the container is using for egress to connect to Azure DB. In order to find that IP address, you can try to connect to the Azure DB from your container and the error message will tell you the IP.  

```bash

kubectl -n mysql exec deploy/mysql -it -- bash

root@mysql-78cf679f8f-5f6xz:/# mysql -h <your-server>.mysql.database.azure.com -P 3306 -u <username>@<your-server> -p
....
Client with IP address '104.42.36.255' is not allowed to connect to this MySQL server.

```

Similarly for Postgres

```bash
 kubectl -n postgresql exec deploy/postgres -it -- bash
root@postgres-64786b846-shnm9:/# psql -h <your-server>.postgres.database.azure.com -p 5432 -U <username>@<your-server> -d postgres
psql: FATAL:  no pg_hba.conf entry for host "104.42.36.255", user "serveradmin", database "postgres", SSL on

```

Another way to find the container egress IP address is to run this from the container.



```bash
apt update
apt install curl
curl ifconfig.me
```

3. There are other 3rd party tools similar to MySQL Workbench, PgAdmin and dbeaver which the attendees may choose to migrate the data if they are familiar with them. There is also [mydumper/myloader](https://centminmod.com/mydumper.html) to use for MySQL


4. Before migrating the data, they need to create an empty database and create the application user.The SQL command to create the database is given below if you are using cli



```sql
create database wth ;
```

5. After creating the database you need to create the database user "contosoapp" that will own the database objects. Connect using the dba account and then create the user and grant it privileges:

Postgres Command -->

```sql
CREATE ROLE CONTOSOAPP WITH LOGIN NOSUPERUSER INHERIT CREATEDB CREATEROLE NOREPLICATION PASSWORD 'OCPHack8';
```

MySQL command --->

```sql

create user if not exists 'contosoapp'   identified by 'OCPHack8' ;

grant ALL PRIVILEGES ON wth.* TO contosoapp ;
grant process, select on *.*  to contosoapp ;

-- check privileges already granted

show grants for contosoapp ;

```


Grants for contosoapp should report


```sql
GRANT SELECT, PROCESS ON *.* TO 'contosoapp'@'%'
GRANT ALL PRIVILEGES ON `wth`.* TO 'contosoapp'@'%'
```


6. Next step is to run a database export from the source database. 

* PostgreSQL command to do offline export to exportdir directory and import offline to Azure DB for PostgreSQL. First bash into the PostgreSQL container and then use these two commands:

```bash
 pg_dump -C -Fd  wth -j 4 -f exportdir -U contosoapp
 pg_restore -h pgtarget.postgres.database.azure.com -p 5432 -U contosoapp@pgtarget -d wth -Fd exportdir
```

* For MySQL the database script file may contain references to @@SESSION and @@GLOBAL that will need to be removed prior to importing.

Privileges required to run MySQL export on the source database - connect as root:

```sql
grant ALL PRIVILEGES ON wth.* TO contosoapp ;
grant process, select on *.*  to contosoapp ;



It is possible to use the MySQL Workbench tool to run the export with proper settings. The MySQL Workbench version (8.0.23 as of Jan 2021) being different from MySQL version 5.7 is not a factor for this challenge. The MySQL export runs a series of exports for each table. If you do not want to see the warnings about `--set-gtid-purged`, use the flag  `--set-gtid-purged`. Now run this:

```bash

mysqldump.exe --defaults-file="tmp_akgbble.cnf"  --host=<container ip> --port=3306 --default-character-set=utf8 --user=contosoapp --protocol=tcp --no-data --skip-triggers --skip-column-statistics "wth" "bakestyle" --set-gtid-purged=off

```

 Alternatively, do this from command prompt:

 ```bash

mysqldump -h <container ip> -u contosoapp -p --set-gtid-purged=off --skip-column-statistics --databases wth >dump_data.sql

 ```

 * MySQL command to do offline import from import directory. When run from MySQL workbench:

```bash

 mysql  --protocol=tcp --host=mytarget2.mysql.database.azure.com --user=contosoapp@mytarget2 --port=3306 --default-character-set=utf8 --comments --database=wth < wth_users.sql

```
 Or from shell prompt:

 ```bash

  mysql  -h mytarget2.mysql.database.azure.com -P 3306 -u contosoapp@mytarget2 -pOCPHack8  <dump_data.sql

 ```

 From command line shell script, do this to load all files one at a time:

 ```bash

 for file in `ls wth_*sql`; do mysql -h mytarget2.mysql.database.azure.com -P 3306 -u contosoapp@mytarget2 -pOCPHack8 wth <$file; done

 ```


