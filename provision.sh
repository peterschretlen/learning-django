#!/bin/bash

#######################################
# Set up the development environement
# Postgres setup taken from : https://raw.githubusercontent.com/jackdb/pg-app-dev-vm
#######################################

# Edit the following to change the name of the database user that will be created:
APP_DB_USER=admin
APP_DB_PASS=admin

# Edit the following to change the name of the database that is created (defaults to the user name)
APP_DB_NAME=django_bookmarks

# Edit the following to change the version of PostgreSQL that is installed
PG_VERSION=9.3

DJANGO_VERSION=1.7.10

###########################################################
# Changes below this line are probably not necessary
###########################################################
print_db_usage () {
  echo ""
  echo ""
  echo ""
  echo "Your PostgreSQL database has been setup and can be accessed on your local machine on the forwarded port (default: 15432)"
  echo "  Host: localhost"
  echo "  Port: 15432"
  echo "  Database: $APP_DB_NAME"
  echo "  Username: $APP_DB_USER"
  echo "  Password: $APP_DB_PASS"
  echo ""
  echo "Admin access to postgres user via VM:"
  echo "  vagrant ssh"
  echo "  sudo su - postgres"
  echo ""
  echo "psql access to app database user via VM:"
  echo "  vagrant ssh"
  echo "  sudo su - postgres"
  echo "  PGUSER=$APP_DB_USER PGPASSWORD=$APP_DB_PASS psql -h localhost $APP_DB_NAME"
  echo ""
  echo "Env variable for application development:"
  echo "  DATABASE_URL=postgresql://$APP_DB_USER:$APP_DB_PASS@localhost:15432/$APP_DB_NAME"
  echo ""
  echo "Local command to access the database via psql:"
  echo "  PGUSER=$APP_DB_USER PGPASSWORD=$APP_DB_PASS psql -h localhost -p 15432 $APP_DB_NAME"
}

PROVISIONED_ON=/etc/vm_provision_on_timestamp
if [ -f "$PROVISIONED_ON" ]
then
  echo "VM was already provisioned at: $(cat $PROVISIONED_ON)"
  echo "To run system updates manually login via 'vagrant ssh' and run 'apt-get update && apt-get upgrade'"
  echo ""
  print_db_usage
  exit
fi

add-apt-repository ppa:webupd8team/sublime-text-2
apt-get update

# Setup tools
apt-get install git
apt-get install sublime-text
apt-get install default-jdk  #needed for pycharm

# Setup python and django
apg-get install -y python
apt-get install -y python-pip

pip install virtualenv

virtualenv learn-django-env

source learn-django-env/bin/activate
pip install "Django==$DJANGO_VERSION"
pip install django-bootstrap3
deactivate

# Setup postgres
apt-get -y install "postgresql-$PG_VERSION" "postgresql-contrib-$PG_VERSION" "postgresql-server-dev-$PG_VERSION"
#apt-get -y install pgadmin3

PG_CONF="/etc/postgresql/$PG_VERSION/main/postgresql.conf"
PG_HBA="/etc/postgresql/$PG_VERSION/main/pg_hba.conf"
PG_DIR="/var/lib/postgresql/$PG_VERSION/main"

# Edit postgresql.conf to change listen address to '*':
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF"

# Append to pg_hba.conf to add password auth:
echo "host    all             all             all                     md5" >> "$PG_HBA"

# Explicitly set default client_encoding
echo "client_encoding = utf8" >> "$PG_CONF"

# Restart so that all new config is loaded:
service postgresql restart

cat << EOF | su - postgres -c psql
-- Create the database user:
CREATE USER $APP_DB_USER WITH PASSWORD '$APP_DB_PASS';

-- Create the database:
CREATE DATABASE $APP_DB_NAME WITH OWNER=$APP_DB_USER
                                  LC_COLLATE='en_US.utf8'
                                  LC_CTYPE='en_US.utf8'
                                  ENCODING='UTF8'
                                  TEMPLATE=template0;
EOF


apt-get install -y python-dev #this is needed to compile psycopg2

source learn-django-env/bin/activate
pip install psycopg2 #allows use of postgres db
deactivate

# Tag the provision time:
date > "$PROVISIONED_ON"

echo "Successfully created Django $DJANGO_VERSION + PostgreSQL $PG_VERSION dev virtual machine."
echo ""
print_db_usage