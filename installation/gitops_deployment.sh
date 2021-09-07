#!/bin/bash

######################
# GitOps deployments #
######################

# cd argo-combined-demo

ls -1 ../production/

cat ../production/argo-cd.yaml

kustomize build \
    ../argo-cd/overlays/production \
    | kubectl apply --filename -

kubectl --namespace argocd \
    rollout status \
    deployment argocd-server

export PASS=$(kubectl \
    --namespace argocd \
    get secret argocd-initial-admin-secret \
    --output jsonpath="{.data.password}" \
    | base64 --decode)

argocd login \
    --insecure \
    --username admin \
    --password $PASS \
    --grpc-web \
    argo-cd.$BASE_HOST

argocd account update-password \
    --current-password $PASS \
    --new-password adminuser

xdg-open http://argo-cd.$BASE_HOST

# Both user and password are `admin`

cat ../project.yaml

kubectl apply --filename ../project.yaml

cat ../apps.yaml

kubectl apply --filename ../apps.yaml
