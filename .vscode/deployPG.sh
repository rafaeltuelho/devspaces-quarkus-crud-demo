#!/bin/bash

oc project ${DEVWORKSPACE_NAMESPACE}

echo
echo "Check if a instance of Postgres already exist in this project."
oc get all -l app=postgresql-persistent
if [[ $? -eq 0 ]] 
then
   echo
   echo "It looks like Postgres was already deployed to this project!!!"
   exit 1
fi

echo
echo "Create a PostgreSQL instance using the 'postgresql-persistent' Openshift Template..."
oc get template postgresql-persistent -n openshift
if [[ $? -eq 0 ]] 
then
    read -p "ENTER the service name (hostname) used by this PG instance (default: pgdb): " DATABASE_SERVICE_NAME
    read -p "ENTER the dabase name (hostname) used by this PG instance  (default: quarkus): " POSTGRESQL_DATABASE
    read -p "ENTER the db username (hostname) used by this PG instance  (default: quarkus): " POSTGRESQL_USER
    read -p "ENTER the db password (hostname) used by this PG instance  (default: quarkus): " -s POSTGRESQL_PASSWORD

    oc new-app postgresql-persistent \
    -p DATABASE_SERVICE_NAME=${DATABASE_SERVICE_NAME:-pgdb} \
    -p POSTGRESQL_DATABASE=${POSTGRESQL_DATABASE:-quarkus} \
    -p POSTGRESQL_USER=${POSTGRESQL_USER:-quarkus} \
    -p POSTGRESQL_PASSWORD=${POSTGRESQL_PASSWORD:-quarkus}
else
   echo
   echo "unable to find 'postgresql-persistent' in the cluster!!!"
fi