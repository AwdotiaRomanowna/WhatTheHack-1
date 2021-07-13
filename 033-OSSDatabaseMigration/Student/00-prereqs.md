# Challenge 0: Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./01-assessment.md)

## Introduction

It's time to set up your "on-premise" environment first. Instructions are given here on how to set it up.


### Important Decision To Make First

Before starting the challenges, you have to make a decision on where you want to run the challenges from.

You will need a Unix/Linux shell to type many commands. Azure Cloud bash shell provides a convenient shell environment. It comes with several CLI that are used during the challenges - AZ, Kubernetes, Helm, MySQL and Postgres. While it is possible to run the entire hack using these CLI tools only, it may be convenient for the participants to install some GUI tools for accessing the MySQL/Postgres databases for running database queries. Some common database GUI tools are listed below. You can use your own tool or choose to stay from all GUI tools and use only CLI.

[DBeaver](https://dbeaver.io/download/) - can connect to MySQL and Postgres ( and many other databaes )

[pgAdmin](https://www.pgadmin.org/download/) - Postgres only

[MySQL Workbench](https://www.mysql.com/products/workbench/) - MySQL only

[Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio) - Postgres only ( with Postgres extension and SQL server/Azure SQL )


As an alternative to cloud shell, this hackathon can also be run from your computer's shell. Particularly Windows ( WSL2 )  or your shell from Mac.
If you choose to run it from your computer, you need to unstall the following CLIs

    - AZ CLI
    - Kubernetes CLI
    - Helm CLI
    - MySQL client ( or GUI tool )
    - Postgres client ( or GUI tool )


You also need a text editor of your choice. Azure Cloud Shell has several editors - VS Code, vim, nano. If running from your own computer,  you can use your own favorite editor.


## Description

In this challenge you'll be setting up your environment so that you can complete your challenges.
 


     -  Download the required resources,zip file for this hack. The location will be given to you by your coach. You should do this in Azure Cloud Shell or in an Mac/Linux/WSL environment which has the Azure CLI installed. 
    
    

 
    - Unzip the resources.zip file.

  
  

    -  Run the following command to setup the on-prem AKS environment:
    

```bash
cd ~/Resources/ARM-Templates/KubernetesCluster
chmod +x ./create-cluster.sh
./create-cluster.sh

```

#### NOTE: creating the cluster will take several ( ~ 10 ) minutes
#### NOTE: The Kubernetes cluster will consist of two containers "mysql" and "postgresql". For each container it is possible to connect to either the database tools or to the bash shell. 

Please refer to the [AKS cheatsheet](./K8s_cheetsheet.md) for a reference of running handy AKS commands to access your kubernetes based on-premises environment. You will need this throughout the hack. 
           



    - Deploy the Pizzeria applications - it will create two web applications - one using PostgreSQL and another using MySQL database.

```bash
cd ~/Resources/HelmCharts/ContosoPizza
chmod +x ./*.sh
./deploy-pizza.sh

```

#### NOTE: deploying the Pizzeria application will take several ( ~ 5 ) minutes



    - Once the applications are deployed, you will get messages like this. Click on both the links to ensure you are able to see the pizza websites. Notice that they run on            different ip address and different ports.

      Pizzeria app on MySQL is ready at http://some_ip_address:8081/pizzeria
      
      Pizzeria app on PostgreSQL is ready at http://some_other_ip_address:8082/pizzeria


    - Run the [shell script](./Resources/HelmCharts/ContosoPizza/modify_nsg_for_postgres_mysql.sh) in the files given to you for this hack at this path: `HelmCharts/ContosoPizza/update_nsg_for_postgres_mysql.sh` 
    
    
  This will block public access to your on-premise databases and allow access only from your computer.

#### NOTE:  This script will restrict access to your "on prem" MySQL or Postgres database that are used for the pizza app here -  only from the shell where you are running this script from. 

#### If you are running in Azure cloud shell and your shell times out because of inactivity, once you launch your session again it will create a new session and a new ip address. You will need to run the script again to add the new IP. 

#### In addition, if you are running this hack from azure cloud shell, and you want to connect to the Azure databases from your computer using gui tools like MySQL Workbench or Pgadmin, you need to  open up the script file and edit the line with "my_ip" with your computer's ip address. This will add your computer's IP in addition to the cloud shell as allowed source.



## References

- Please refer to the [AKS cheatsheet](./K8s_cheetsheet.md) for a reference of running handy AKS commands to validate your environment. You will need this throughout the hack.


## Success Criteria

* You have a Unix/Linux Shell at your disposal for setting up the Pizzeria application (e.g. Azure Cloud Shell, WSL2 bash, Mac zsh etc.)
* You have validated that the Pizzeria applications (one for PostgreSQL and one for MySQL) are working
* [Optional] You have database management tools GUI for PostgreSQL and MySQL installed on your computter and are able to connect to the Postgres and MySQL databases.
* Once connected to the database, explore the "wth" database used for the application. 
* Explore the user "contosoapp" that owns the application objects and its security privileges it has. 


## Hint

* The on-prem MySQL and Postgres databases have an public IP address that you can connect to. 
* In order to get those public IP addresses, run these commands and look for the "external-IP"s.

```bash

 kubectl -n mysql get svc
 kubectl -n postgresql get svc

```

There are more useful kubernetes commands in the reference section below.


## References

*  [AKS cheatsheet](./K8s_cheetsheet.md)
* [pgAdmin](https://www.pgadmin.org) (optional)
* [MySQL Workbench](https://www.mysql.com/products/workbench/) (optional)
* [Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver15) (optional)
* [Visual Studio Code](https://code.visualstudio.com/) (optional)

