#!/bin/bash

set -eo pipefail

# This shouldn't be needed as being installed as package from workshop definition.
# The TCE_VERSION variable is set by the separate tce package so only need to
# set it here if that wasn't installed.

if [[ $(which tanzu) == "" ]]; then
 TCE_VERSION=0.12.0
 curl -L https://github.com/vmware-tanzu/community-edition/releases/download/v${TCE_VERSION}/tce-linux-amd64-v${TCE_VERSION}.tar.gz -o tce-linux-amd64-v${TCE_VERSION}.tar.gz
 tar -xf tce-linux-amd64-v${TCE_VERSION}.tar.gz
 mkdir -p /home/eduk8s/bin
 cd tce-linux-amd64-v${TCE_VERSION}
 cp tanzu /home/eduk8s/bin/tanzu
 rm -rf $HOME/.config/tanzu-plugins
 ./install.sh
fi

# Install TCE package repository
# RETRY=0
# MAX=10
# INTERVAL=5
# until [ $RETRY -ge $MAX ]
# do
#     tanzu package repository add tce-repo --url projects.registry.vmware.com/tce/main:$TCE_VERSION --namespace tanzu-package-repo-global && break
#     RETRY=$((RETRY+1))
#     echo "$RETRY/$MAX failed, waiting to try again . . ."
#     sleep $INTERVAL
# done
tanzu package repository add tce-repo --url projects.registry.vmware.com/tce/main:$TCE_VERSION --namespace tanzu-package-repo-global 

# Install Knative Serving
envsubst < /opt/workshop/setup.d/values.template > /opt/workshop/setup.d/values.yaml
KNATIVE_SERVING_VERSION=$(tanzu package available list knative-serving.community.tanzu.vmware.com -o json | jq -r ".[].version" | sort -t "." -k1,1n -k2,2n -k3,3n | tail -n 1)
tanzu package install app-toolkit --package-name knative-serving.community.tanzu.vmware.com --version $KNATIVE_SERVING_VERSION -f /opt/workshop/setup.d/values.yaml --namespace tanzu-package-repo-global
