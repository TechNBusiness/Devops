#!bin/bash
echo "setup and configure server"

file_name=config.yaml

if [-d "config"]
then 
  echo "reading the contents of config directory"
  config_files=$(ls config)
else
  echo "config directory does not exist. creating one"
  mkdir config
fi    

if [-f "config.yaml"]
then
  echo "executing the configuration"
else 
  echo "This is not configuration file: aborting mission"
fi 

user_group=devops

if [user_group == "Gazzy"]
then
  echo "configuring server"
elif [ user_group == "admin"]
  echo "administering server"  
else 
  echo "No permission to configure server. This wrong user group"  

echo "using $file_name to configure something"
echo "Here are all configuration file: $config_files"
