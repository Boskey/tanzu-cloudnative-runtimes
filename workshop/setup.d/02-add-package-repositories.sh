#!/bin/bash

set -eo pipefail

# Add package repository. This is safe to run here as prior setup script has
# waited for kapp-controller to be ready. Note that the TCE_VERSION environment
# variable has a "v" prefix so we need to strip that off.

tanzu package repository add tce-repo --url projects.registry.vmware.com/tce/main:${TCE_VERSION:1} --namespace tanzu-package-repo-global 
