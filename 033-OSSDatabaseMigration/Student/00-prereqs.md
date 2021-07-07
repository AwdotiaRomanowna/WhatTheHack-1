# Challenge 0: Pre-requisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./01-assessment.md)

## Introduction

It's time to set up what you will need in order to do these challenges for OSS DB migration

## Description

In this challenge you'll be setting up your environment so that you can complete your challenges.

- Install the recommended toolset:
    - To connect to PostgreSQL database, use [Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio) or [pgAdmin](https://www.pgadmin.org/)
    - [MySQL Workbench](https://www.mysql.com/products/workbench/) (note: if you get an error about not having the Visual Studio C++ 2019 Redistributable on your machine when installing, refer to this [note](https://support.microsoft.com/en-us/topic/the-latest-supported-visual-c-downloads-2647da03-1eea-4433-9aff-95f26a218cc0) 
    - Visual Studio Code (optional)
    - [Az Cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) - only if you plan to run this hackathon from your computer instead of azure cloud shell. 

- Step 1:
    -   Download the required [resources](https://microsoft.sharepoint.com/:u:/t/SparkOSSDBMigrationCoach/ESYsppGKy2BJr28_bs537h8BEJApa15b8IQ9ARQ-SUir0g?e=bAWo4e) folder for this hack into your computer. 
    
-  Step 2: 
    -  Decide if you want to run this hackathon on your in Azure cloud shell. The cloud shell has the pre-requisites toolset installed - AZ cli and Postgres and MySQL cli client. 
    
    -  Alternately, if you have WSL on Windows or any unix shell, or a Mac you can run it from your computer too. In that case please make sure you have az cli installed. 
      
-   Step 3:
 
    - Unzip the resources.zip file.

  
-   Step 4:

    -  Run the following command to setup the environment:

```bash
cd ~/Resources/ARM-Templates/KubernetesCluster
chmod +x ./create-cluster.sh
./create-cluster.sh

```

#### NOTE: creating the cluster will take several ( ~ 10 ) minutes

-   Step 5:

    - Deploy the Pizzeria applications twice - one using PostgreSQL and another using MySQL database.

```bash
cd ~/Resources/HelmCharts/ContosoPizza
chmod +x ./*.sh
./deploy-pizza.sh

```

#### NOTE: deploying the Pizzeria application will take several ( ~ 5 ) minutes

-   Step 6:

    - Once the applications are deployed, you will get messages like this. Click on both the links to ensure you are able to see the pizza websites. Notice that they run on            different ip address and different ports.

      Pizzeria app on MySQL is ready at http://some_ip_address:8081/pizzeria
      
      Pizzeria app on PostgreSQL is ready at http://some_other_ip_address:8082/pizzeria

- Step 7:
    - Run the [shell script](./Resources/HelmCharts/ContosoPizza/update_nsg_for_postgres_mysql.sh) in the files given to you for this hack at this path: `HelmCharts/ContosoPizza/update_nsg_for_postgres_mysql.sh` 
  This will block public access to your on-premise databases and allow access only from your computer.

#### NOTE:  This script will restrict access to your Azure MySQL or Postgres database only from the shell where you are running this script from. Please note that if you are running in Azure cloud shell and your shell times out because of inactivity, once you launch your session again it will create a new session and a new ip address. You will need to run the script again then. In addition, if you are running this hack from azure cloud shell, and you want to connect to the Azure databases from your computer using gui tools like MySQL Workbench or Pgadmin, you need to  open up the script file and edit the line with "myip" with your ip address. You can get your computer's ip address by launching a browser to https://ifconfig.me 
 

## References

- Please refer to the [AKS cheatsheet](./K8s_cheetsheet.md) for a reference of running handy AKS commands to validate your environment. You will need this throughout the hack.


## Success Criteria

* You have a Unix shell at your disposal for setting up the Pizzeria application (e.g. Azure Cloud Shell, WSL2 bash, Mac zsh etc.)
* You have validated that the Pizzeria applications (one for PostgreSQL and one for MySQL) are working
* You have database management tools installed and are able to connect to the Postgres and MySQL databases for the Pizzeria app
* Once connected to the database, you expand "wth" database used for the application. 
* Explore the user contosoapp that owns the application objects and its security privileges. In later challenges, this user needs to be created on the target database.

## References

* [pgAdmin](https://www.pgadmin.org)
* [MySQL Workbench](https://www.mysql.com/products/workbench/)
* [Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver15)
* [Visual Studio Code](https://code.visualstudio.com/) (optional)

