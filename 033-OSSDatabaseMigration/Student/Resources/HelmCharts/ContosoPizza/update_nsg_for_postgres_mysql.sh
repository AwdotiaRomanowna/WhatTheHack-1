

# Change NSG firewall rule to restrict Postgres and MySQL database from client machine only. The first step - to find out your local client ip address. 

echo -e "\n This script restricts the access to your Postgres and MySQL database from your computer only.

 If you are running this script from Azure Cloud Shell, then you have to edit this file before executing it. 
 The variable myip will get the ip address of the cloud shell, not your computer. In that case, in order to get your computer ip address,  point a browser to 
 https://ifconfig.me and put that below. So if the browser says it is 102.194.87.201, your myip=102.194.87.201/32. 
 On the other hand if you are running from your own computer, then the curl command gets your ip address automatically for you. No need to edit anything \n"

myip=`curl -s ifconfig.me`/32


# In this resource group, there is only one NSG. Change the value of the resource group, if required

export rg_nsg="MC_OSSDBMigration_ossdbmigration_westus"
export nsg_name=`az network nsg list  -g $rg_nsg -o table | tail -1 | awk '{print $2}'`

# For this NSG, there are two rules for connecting to Postgres and MySQL.

export pg_nsg_rule_name=`az network nsg rule list -g $rg_nsg --nsg-name $nsg_name --query '[].[name]' | grep "TCP-5432" | sed 's/"//g'`
export my_nsg_rule_name=`az network nsg rule list -g $rg_nsg --nsg-name $nsg_name --query '[].[name]' | grep "TCP-3306" | sed 's/"//g'`

# Update the rule to allow access to Postgres and MySQL only from your client ip address - "myip"
   
az network nsg rule update -g $rg_nsg --nsg-name $nsg_name --name $my_nsg_rule_name --source-address-prefixes $myip
az network nsg rule update -g $rg_nsg --nsg-name $nsg_name --name $pg_nsg_rule_name --source-address-prefixes $myip
