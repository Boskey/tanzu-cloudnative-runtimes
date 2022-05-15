#!/bin/bash

set -eo pipefail

if [[ $(which tanzu) == "" ]]; then
  curl -L https://github.com/vmware-tanzu/community-edition/releases/download/v${TCE_VERSION}/tce-linux-amd64-v${TCE_VERSION}.tar.gz -o tce-linux-amd64-v${TCE_VERSION}.tar.gz
  tar -xf tce-linux-amd64-v${TCE_VERSION}.tar.gz
  mkdir -p /home/eduk8s/bin
  cd tce-linux-amd64-v${TCE_VERSION}
  cp tanzu /home/eduk8s/bin/tanzu
  ./install.sh
fi

# Install TCE package repository
tanzu package repository add tce-repo --url projects.registry.vmware.com/tce/main:$TCE_VERSION --namespace tanzu-package-repo-global

# Install Knative Serving
envsubst < /opt/workshop/setup.d/values.template > /opt/workshop/setup.d/values.yaml
KNATIVE_SERVING_VERSION=$(tanzu package available list knative-serving.community.tanzu.vmware.com -o json | jq -r ".[].version" | sort -t "." -k1,1n -k2,2n -k3,3n | tail -n 1)
tanzu package install app-toolkit --package-name knative-serving.community.tanzu.vmware.com --version $KNATIVE_SERVING_VERSION -f /opt/workshop/setup.d/values.yaml --namespace tanzu-package-repo-global