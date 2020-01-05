FROM quay.io/eduk8s/workshop-dashboard:develop

COPY --chown=1001:0 . /home/eduk8s/
