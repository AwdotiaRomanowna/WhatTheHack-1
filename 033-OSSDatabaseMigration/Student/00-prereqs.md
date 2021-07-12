# Challenge 0: Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./01-assessment.md)

## Introduction

It's time to set up your "on-premise" environment first. Instructions are given here on how to set it up.


### Important Decision

In this hackathon, you will need a Unix/Linux shell to type many commands. Azure Cloud bash shell provides a convenient shell environment. It comes with several CLI that are used during the challenges - AZ, Kubernetes, Helm, MySQL and Postgres. While it is possible to run the entire hack using these CLI tools only, it may be convenient for the participants to install some GUI tools for accessing the MySQL/Postgres databases for running database queries. Some common database GUI tools are listed below:

[DBeaver](https://dbeaver.io/download/) - can connect to MySQL and Postgres ( and many other databaes )

[pgAdmin](https://www.pgadmin.org/download/) - Postgres only

[MySQL Workbench](https://www.mysql.com/products/workbench/) - MySQL only

[Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio) - Postgres only ( with Postgres extension and SQL server/Azure SQL )


Besides cloud shell, this hackathon can also be run from your computer's shell. If you have Windows, you have use WSL2, or your shell from Mac.
In that case, you need to unstall the following CLIs

    - AZ CLI
    - Kubernetes CLI
    - Helm CLI
    - MySQL client ( or GUI tool )
    - Postgres client ( or GUI tool )


You also need a text editor of your choice. Azure Cloud Shell has both VS Code, vim, nano - or you can use your own editor if running from your computer.


## Description

In this challenge you'll be setting up your environment so that you can complete your challenges.
 


    -   Download the required resources,zip file for this hack. The location will be given to you by your coach. You should do this in Azure Cloud Shell or in an Mac/Linux/WSL environment which has the Azure CLI installed. 
    
    

 
    - Unzip the resources.zip file.

  
-:

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


    - Run the [shell script](./Resources/HelmCharts/ContosoPizza/update_nsg_for_postgres_mysql.sh) in the files given to you for this hack at this path: `HelmCharts/ContosoPizza/update_nsg_for_postgres_mysql.sh` 
  This will block public access to your on-premise databases and allow access only from your computer.

#### NOTE:  This script will restrict access to your "on prem" MySQL or Postgres database that are used for the pizza app here -  only from the shell where you are running this script from. 
#### If you are running in Azure cloud shell and your shell times out because of inactivity, once you launch your session again it will create a new session and a new ip address. You will need to run the script again then. 
#### In addition, if you are running this hack from azure cloud shell, and you want to connect to the Azure databases from your computer using gui tools like MySQL Workbench or Pgadmin, you need to  open up the script file and edit the line with "myip" with your computer's ip address. 
#### You can get your computer's ip address by launching a browser to [here](https://ifconfig.me).
#### If you are running this hackathon from your computer and do not intend to use cloud shell,  there is no need to change anuything in the script. 
 

## References

- Please refer to the [AKS cheatsheet](./K8s_cheetsheet.md) for a reference of running handy AKS commands to validate your environment. You will need this throughout the hack.


## Success Criteria

* You have a Unix/Linux Shell at your disposal for setting up the Pizzeria application (e.g. Azure Cloud Shell, WSL2 bash, Mac zsh etc.)
* You have validated that the Pizzeria applications (one for PostgreSQL and one for MySQL) are working
* [Optional] You have database management tools GUI for PostgreSQL and MySQL installed on your computter and are able to connect to the Postgres and MySQL databases.
* Using GUI tool or commandlike SQL, once connected to the database, explore the "wth" database used for the application. 
* Explore the user "contosoapp" that owns the application objects and its security privileges. In later challenges, this user needs to be created on the target database.

## References

* [pgAdmin](https://www.pgadmin.org)
* [MySQL Workbench](https://www.mysql.com/products/workbench/)
* [Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver15)
* [Visual Studio Code](https://code.visualstudio.com/) (optional)

