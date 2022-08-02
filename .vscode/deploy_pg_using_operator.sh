#!/bin/bash

OPERATOR_API_GROUP="postgres-operator.crunchydata.com"
oc project ${DEVWORKSPACE_NAMESPACE}

echo
echo "Check if the Crunchdata Postgres Operator is present."
oc api-resources --api-group=$OPERATOR_API_GROUP
if [[ $? -gt 0 ]] 
then
   echo
   echo "No Postgres Operator present in this cluster!!!"
   exit 1
fi

echo
echo "Check if there is PG Cluster already deployed."
oc get PostgresCluster pg-cluster
if [[ $? -eq 0 ]] 
then
   echo
   echo "Resource pg-cluster already present in this project!!!"
   exit 1
fi

echo
echo "Create a PostgreSQL instance using ${OPERATOR_API_GROUP}..."
oc create -f ${PROJECT_SOURCE}/postgresql-crd.yaml
if [[ $? -eq 0 ]] 
then
  echo
  echo "Wait until PG instance gets ready..."
else
   echo
   echo "unable to create the cluster!!!"
fi