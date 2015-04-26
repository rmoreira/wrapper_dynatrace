# wrapper_dynatrace cookbook

# Requirements

 - jboss
 - tomcat
 - s3_file
 
# Recipes

 - ::install
   Installs the dynatrace agent on the server, adds the agent into the config file (defined under attributes)
 - ::uninstall
   removes dynatrace agent from config file, and restart jboss/tomcat

# Testing
```rspec```