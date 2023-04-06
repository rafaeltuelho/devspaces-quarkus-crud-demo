#!/bin/bash

oc project ${DEVWORKSPACE_NAMESPACE}

echo
echo "Check if a instance of Postgres already exist in this project."
oc get pod -l name=postgres | grep postgres
if [[ $? -eq 0 ]]
then
   echo
   echo "It looks like a Postgres instance is already deployed to this project!!!"
   exit 1
fi

echo
echo "Creating a PostgreSQL instance using the 'postgresql-ephemeral' Openshift Template..."
oc get template postgresql-ephemeral -n openshift | grep postgresql-ephemeral
if [[ $? -eq 0 ]] 
then
   #  read -p "ENTER the service name (hostname) used by this PG instance (default: pgdb): " DATABASE_SERVICE_NAME
   #  read -p "ENTER the dabase name (hostname) used by this PG instance  (default: quarkus): " POSTGRESQL_DATABASE
   #  read -p "ENTER the db username (hostname) used by this PG instance  (default: quarkus): " POSTGRESQL_USER
   #  read -p "ENTER the db password (hostname) used by this PG instance  (default: quarkus): " -s POSTGRESQL_PASSWORD

    oc new-app postgresql-ephemeral \
    -p DATABASE_SERVICE_NAME=${DATABASE_SERVICE_NAME:-postgres} \
    -p POSTGRESQL_DATABASE=${POSTGRESQL_DATABASE:-postgres} \
    -p POSTGRESQL_USER=${POSTGRESQL_USER:-postgres} \
    -p POSTGRESQL_PASSWORD=${POSTGRESQL_PASSWORD:-password} \
    >/dev/null

  echo "now you can connect to it using 'postgres:5432'"

else
   echo
   echo "unable to find 'postgresql-ephemeral' in the cluster!!!"
fi