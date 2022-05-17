#!/bin/bash

set -eo pipefail

# Install Knative Serving and wait for main controller to deploy.

envsubst < /opt/workshop/setup.d/values.template > /opt/workshop/setup.d/values.yaml

KNATIVE_SERVING_VERSION=$(tanzu package available list knative-serving.community.tanzu.vmware.com -o json | jq -r ".[].version" | sort -t "." -k1,1n -k2,2n -k3,3n | tail -n 1)

tanzu package install app-toolkit --package-name knative-serving.community.tanzu.vmware.com --version $KNATIVE_SERVING_VERSION -f /opt/workshop/setup.d/values.yaml --namespace tanzu-package-repo-global

STATUS=1
ATTEMPTS=0
ROLLOUT_STATUS_CMD="kubectl rollout status deployment/controller -n knative-serving"

until [ $STATUS -eq 0 ] || $ROLLOUT_STATUS_CMD || [ $ATTEMPTS -eq 12 ]; do
    sleep 5
    $ROLLOUT_STATUS_CMD
    STATUS=$?
    ATTEMPTS=$((ATTEMPTS + 1))
done
