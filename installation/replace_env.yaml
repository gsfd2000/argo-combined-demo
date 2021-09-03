#!/bin/bash

set PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin

cat ../orig/sealed-secrets.yaml \
    | sed -e "s@vfarcic@$GH_ORG@g" \
    | tee ../production/sealed-secrets.yaml

cat ../argo-cd/base/ingress.yaml \
    | sed -e "s@acme.com@argo-cd.$BASE_HOST@g" \
    | tee ../argo-cd/overlays/production/ingress.yaml

cat ../argo-workflows/base/ingress.yaml \
    | sed -e "s@acme.com@argo-workflows.$BASE_HOST@g" \
    | tee ../argo-workflows/overlays/production/ingress.yaml

cat ../argo-events/base/event-sources.yaml \
    | sed -e "s@vfarcic@$GH_ORG@g" \
    | sed -e "s@acme.com@webhook.$BASE_HOST@g" \
    | tee ../argo-events/overlays/production/event-sources.yaml

cat ../argo-events/base/sensors.yaml \
    | sed -e "s@value: vfarcic@value: $GH_ORG@g" \
    | sed -e "s@value: CHANGE_ME_IMAGE_OWNER@value: $REGISTRY_USER@g" \
    | tee ../argo-events/overlays/production/sensors.yaml

cat ../production/argo-cd.yaml \
    | sed -e "s@vfarcic@$GH_ORG@g" \
    | tee ../production/argo-cd.yaml

cat ../production/argo-workflows.yaml \
    | sed -e "s@vfarcic@$GH_ORG@g" \
    | tee ../production/argo-workflows.yaml

cat ../production/argo-events.yaml \
    | sed -e "s@vfarcic@$GH_ORG@g" \
    | tee ../production/argo-events.yaml

cat ../production/argo-rollouts.yaml \
    | sed -e "s@vfarcic@$GH_ORG@g" \
    | tee ../production/argo-rollouts.yaml

cat ../production/argo-combined-app.yaml \
    | sed -e "s@github.com/vfarcic@github.com/$GH_ORG@g" \
    | sed -e "s@- vfarcic@- $REGISTRY_USER@g" \
    | tee ../production/argo-combined-app.yaml

cat ../staging/argo-combined-app.yaml \
    | sed -e "s@github.com/vfarcic@github.com/$GH_ORG@g" \
    | sed -e "s@- vfarcic@- $REGISTRY_USER@g" \
    | tee ../staging/argo-combined-app.yaml

cat ../apps.yaml \
    | sed -e "s@vfarcic@$GH_ORG@g" \
    | tee ../apps.yaml

kubectl apply --filename ../sealed-secrets

# needs to be executed manually under root
# kubeseal does not listen automatically under vagrant for pipe input

kubectl --namespace workflows \
    create secret \
    docker-registry regcred \
    --docker-server=$REGISTRY_SERVER \
    --docker-username=$REGISTRY_USER \
    --docker-password=$REGISTRY_PASS \
    --docker-email=$REGISTRY_EMAIL \
    --output json \
    --dry-run=client \
    | kubeseal --format yaml \
    | tee ../argo-workflows/overlays/production/regcred.yaml

# Wait for a while and repeat the previous command if the output contains `cannot fetch certificate` error message
