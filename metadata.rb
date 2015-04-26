name             'wrapper_dynatrace'
maintainer       'Rafael Moreira'
maintainer_email 'raffvongibbs@gmail.com'
license          'All rights reserved'
description      'Installs/Uninstalls Dynatrace on a JBoss or Tomcat server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.1'

depends "s3_file"
depends "tomcat"
depends "jboss"