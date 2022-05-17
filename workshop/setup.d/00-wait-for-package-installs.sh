#!/bin/bash

# Wait for CRDs for kapp-controller to have been created.

STATUS=1
ATTEMPTS=0
ROLLOUT_STATUS_CMD="kubectl get crd/packagerepositories.packaging.carvel.dev"

until [ $STATUS -eq 0 ] || $ROLLOUT_STATUS_CMD || [ $ATTEMPTS -eq 12 ]; do
    sleep 5
    $ROLLOUT_STATUS_CMD
    STATUS=$?
    ATTEMPTS=$((ATTEMPTS + 1))
done

# Now wait for deployment of kapp-controller.

STATUS=1
ATTEMPTS=0
ROLLOUT_STATUS_CMD="kubectl rollout status deployment/kapp-controller -n kapp-controller"

until [ $STATUS -eq 0 ] || $ROLLOUT_STATUS_CMD || [ $ATTEMPTS -eq 12 ]; do
    sleep 5
    $ROLLOUT_STATUS_CMD
    STATUS=$?
    ATTEMPTS=$((ATTEMPTS + 1))
done

# Wait for CRDs for Contour to be installed. Can handle not waiting for
# Contour itself to be deployed.

STATUS=1
ATTEMPTS=0
ROLLOUT_STATUS_CMD="kubectl get crd/httpproxies.projectcontour.io"

until [ $STATUS -eq 0 ] || $ROLLOUT_STATUS_CMD || [ $ATTEMPTS -eq 12 ]; do
    sleep 5
    $ROLLOUT_STATUS_CMD
    STATUS=$?
    ATTEMPTS=$((ATTEMPTS + 1))
done
