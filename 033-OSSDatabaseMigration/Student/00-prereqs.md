# Challenge 0: Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./01-assessment.md)

## Introduction

It's time to set up your "on-premises" environment first.


### Decide how you want to deploy and manage the resources in these challenges

Before starting the challenges, you should decide how you want to deploy and manage the resources in these challenges.

You will need a Unix/Linux shell to execute the commands for these challenges. Azure Cloud Shell (using Bash) provides a convenient shell environment with all of the tools you will need to run these challenges already included such as the Azure CLI, kubectl, helm, MySQL and PostgreSQL client tools, and editors such as vim, nano, code, etc. While it is possible to run the entire hacakathon using these CLI tools only, it may be convenient for you to install some GUI tools on your own computer for accessing the MySQL/PostgreSQL databases for running database queries or changing data. If you feel less comfortable working from the command line, you may wish to do this. Some common database GUI tools are listed below. You can choose which tools to use or use only Azure Cloud Shell. 

Some GUI tools which run on Windows/Mac include:

[DBeaver](https://dbeaver.io/download/) - can connect to MySQL and PostgreSQL (and other databases)

[pgAdmin](https://www.pgadmin.org/download/) - PostgreSQL only

[MySQL Workbench](https://www.mysql.com/products/workbench/) - MySQL only

[Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio) - PostgreSQL (with PostgreSQL extension) but MySQL is currently not supported

As an alternative to Azure Cloud Shell, this hackathon can also be run from your computer's shell. You can use the Windows Subsystem for Linux (WSL2), Linux Bash or Mac Terminal. While Linux and Mac include Bash and Terminal out of the box respectively, on Windows you will need to install the WSL: [Windows Subsystem for Linux Installation Guide for Windows 10](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

If you choose to run it from your computer, you need to install the following tools:

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/)
- Kubectl (using `az aks install-cli`)
- [Helm3](https://helm.sh/docs/intro/install/) 
- MySQL command line client tool (or GUI tool mentioned above)
- PostgreSQL command lin client tool (or GUI tool mentioned above)


You should carefully consider how much time you will need to install these tools on your own computer. Depending on your Internet and computer's speed, this additional local setup will probably take around 30-60 minutes. You will also need a text editor of your choice if it is not already installed. 


## Description

In this challenge you'll be setting up your environment so that you can complete your challenges.

   - Download the required resources,zip file for this hack. The location will be given to you by your coach. You should do this in Azure Cloud Shell or in an Mac/Linux/WSL environment which has the Azure CLI installed. 
   - Unzip the resources.zip file
   - Run the following command to setup the on-prem AKS environment:
    

```bash
cd ~/Resources/ARM-Templates/KubernetesCluster
chmod +x ./create-cluster.sh
./create-cluster.sh

```

#### NOTE: Creating the cluster will take around 10 minutes
#### NOTE: The Kubernetes cluster will consist of two containers "mysql" and "postgresql". For each container it is possible to use either the database tools within the container itself or to connect remotely using a database client tool such as psql/mysql. 

   - Deploy the Pizzeria applications - it will create two web applications - one using PostgreSQL and another using MySQL database.

```bash
cd ~/Resources/HelmCharts/ContosoPizza
chmod +x ./*.sh
./deploy-pizza.sh

```

#### NOTE: deploying the Pizzeria application will take around 5 minutes

   - Once the applications are deployed, you will see links to two web sites with different IP address running on ports 8081 and 8082, respectively. In Azure Cloud Shell, these are clickable links. Otherwise, you can cut and paste each URL in your web browser to ensure that it is running. 
```bash
      Pizzeria app on MySQL is ready at http://some_ip_address:8081/pizzeria      
      Pizzeria app on PostgreSQL is ready at http://some_other_ip_address:8082/pizzeria
```

   - Run the [shell script](./Resources/HelmCharts/ContosoPizza/modify_nsg_for_postgres_mysql.sh) in the files given to you for this hack at this path: `HelmCharts/ContosoPizza/modify_nsg_for_postgres_mysql.sh` 
    
    
  This will block public access to your on-premises databases and allow access only from your computer or Azure Cloud Shell.

#### NOTE:  This script will restrict public access to your "on prem" MySQL or PostgreSQL database that are used for the pizza app. The script is written to obtain your public IP address automatically depending on where you run it (either locally on your own computer or within Azure Cloud Shell).

#### If you are running in Azure Cloud Shell, keep in mind that Azure Cloud Shell times out after 20 minutes of inactivity. If you start a new Azure Cloud Shell session, it will have a different public IP address and you will need to run the NSG script again to allow the new public IP address to access your database containers. 

#### If you are running this hack from Azure Cloud Shell and you also want to connect to the Azure databases from your own computer using the GUI tools mentioned above like MySQL Workbench or Pgadmin, then you will need to edit the script file and change the line with "my_ip" to your computer's IP address. This will add your computer's IP address to the NSG rule as an allowed IP address (as well as allowing Azure Cloud Shell's public IP address)

## Success Criteria

* You have a Unix/Linux Shell for setting up the Pizzeria application (e.g. Azure Cloud Shell, WSL2 bash, Mac zsh etc.)
* You have validated that the Pizzeria applications (one for PostgreSQL and one for MySQL) are working
* [Optional] You have database management GUI tools for PostgreSQL and MySQL installed on your computer and are able to connect to the PostgreSQL and MySQL databases.
* Once connected to the database, explore the "wth" database used for the application by selecting on some tables to ensure data is present 


## Hints

* The on-prem MySQL and PostgreSQL databases have a public IP address that you can connect to. 
* In order to get those public IP addresses, run these commands and look for the "external-IP"s.

```bash

 kubectl -n mysql get svc
 kubectl -n postgresql get svc

```

There are more useful kubernetes commands in the reference section below.


## References

* [AKS cheatsheet](./K8s_cheetsheet.md)
* [pgAdmin](https://www.pgadmin.org) (optional)
* [MySQL Workbench](https://www.mysql.com/products/workbench/) (optional)
* [Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver15) (optional)
* [Visual Studio Code](https://code.visualstudio.com/) (optional)

