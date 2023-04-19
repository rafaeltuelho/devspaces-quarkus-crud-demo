# CI/CD Workflows

## Setup

```
oc new-project quarkus-cicd-demo
oc adm policy add-role-to-user admin rafaeltuelho -n quarkus-cicd-demo
oc adm policy add-role-to-user edit rsoares-rh -n quarkus-cicd-demo

oc create -f ./infrastructure/cicd/tekton/setup/quay.io-github-basicauth-secret.yaml
oc create -f ./infrastructure/cicd/tekton/setup/workspace-builder-pvc.yaml
oc create -f ./infrastructure/cicd/tekton/tasks/*
oc create -f ./infrastructure/cicd/tekton/pipelines/*

oc secrets link pipeline quay-push-secret --for=pull,mount
oc secrets link pipeline git-user-pass
```