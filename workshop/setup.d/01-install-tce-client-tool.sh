#!/bin/bash

set -eo pipefail

# This shouldn't be needed as being installed as package from workshop
# definition, but there is currently a bug in workshop base image that the
# package isn't being reinstalled correctly when doing update-workshop in a
# workshop session. The TCE_VERSION variable is set by the separate tce package
# so we inherit that value.

if [[ $(which tanzu) == "" ]]; then
    curl -L https://github.com/vmware-tanzu/community-edition/releases/download/${TCE_VERSION}/tce-linux-amd64-${TCE_VERSION}.tar.gz -o tce-linux-amd64-${TCE_VERSION}.tar.gz
    tar -xf tce-linux-amd64-${TCE_VERSION}.tar.gz
    mkdir -p /home/eduk8s/bin
    cd tce-linux-amd64-${TCE_VERSION}
    cp tanzu /home/eduk8s/bin/tanzu
    rm -rf $HOME/.config/tanzu-plugins
    ./install.sh
fi
