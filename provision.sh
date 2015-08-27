#!/bin/sh

#######################################
# Set up the development environement
#######################################

# Setup python

apt-get update
apg-get install -y python
apt-get install -y python-pip

pip install virtualenv

virtualenv learn-django-env

pip install Django==1.7.10

# Setup postgres
apt-get install -y postgresql postgresql-contrib pgadmin3
