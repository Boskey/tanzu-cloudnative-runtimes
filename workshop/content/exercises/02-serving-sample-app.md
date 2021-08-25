So far we have created a service for a containerized app based on Spring and have external traffic flowing to it. 

Imagine, you made some improvements to the app, you want to roll the new version out but are not sure about how users might react to the changes. You want to maybe conduct an A/B test to see user behavior/reaction.

Cloud Native runtimes can help you roll newer versions of your app and manage traffic flow to the services

### Routes
Everytime we deploy a service using Cloud Native Runtimes, the service gets a revision automatically assigned to it. 

For e.g, for the service we deployed earlier, the revision can be found using:
```execute
kubectl get revision  -A| grep $SESSION_NAMESPACE
```

Observe the second field, the revision is usually the $SERVICE_NAME-00001 for the initial deployment.

Let's say we changed the Pet's picture from the original app and containerized the new app as `v2`.

We now want to deploy the `v2` version of the app, maybe direct 50% of the incoming traffic to app v2, and if all looks well direct all traffic to app `v2`.

First, let's install app `v2`.  Notice the container image is different now and has the new app `v2`. Also, notice we are deploying `v2` with the same service name as before.

Execute the below command to install app `v2`.
```execute
cat <<EOF | kubectl apply  -f -
apiVersion: serving.knative.dev/v1 # Current version of Knative
kind: Service
metadata:
  name: $SESSION_NAMESPACE-1 # The name of the app
  namespace: $WORKSHOP_NAMESPACE # The namespace the app will use
spec:
  template:
    spec:
      containers:
        - image: ghcr.io/boskey/petclinic2
EOF
```
Wait for a minute for the deployment to proceed. Once app v2 is deployed, you will notice the service now has two revisions

```execute
kubectl get revision  -A| grep $SESSION_NAMESPACE
```

If you click on the application URL from before, 100 % of the traffic is still going to app v1 with the old image.

### Refresh the application tab we opened before

Now, let's update the service such that incoming traffic is split between v1 and v2 50-50

Notice the `spec.traffic` element in the file below
Execute below to update the service. 
```execute
cat <<EOF | kubectl apply  -f -
apiVersion: serving.knative.dev/v1 # Current version of Knative
kind: Service
metadata:
  name: $SESSION_NAMESPACE-1 # The name of the app
  namespace: $WORKSHOP_NAMESPACE # The namespace the app will use
spec:
  template:
    spec:
      containers:
        - image: ghcr.io/boskey/petclinicv2
          imagePullPolicy: Always
  traffic:
  - tag: current
    revisionName: $SESSION_NAMESPACE-1-00001 
    percent: 50
  - tag: candidate
    revisionName: $SESSION_NAMESPACE-1-00002
    percent: 50
  - tag: latest
    latestRevision: true
    percent: 0   
EOF
```

Give the service a few seconds to be re-configured and updated. 

## Move incoming traffic to the new app

Execute the below to fetch the URL for app again
```execute
kubectl get ksvc $SESSION_NAMESPACE-1 -n $WORKSHOP_NAMESPACE
```
You will notice that the traffic is now splitting between the old and new versions after each refresh

Okay, now that we see the new app v2 and everythings seems to be fine, lets move all the traffic coming to the new app v2.

Execute the below, notice the traffic is now defined to go to revision for app v2 only.

```execute
cat <<EOF | kubectl apply  -f -
apiVersion: serving.knative.dev/v1 # Current version of Knative
kind: Service
metadata:
  name: $SESSION_NAMESPACE-1 # The name of the app
  namespace: $WORKSHOP_NAMESPACE # The namespace the app will use
spec:
  template:
    spec:
      containers:
        - image: ghcr.io/boskey/petclinicv2
          imagePullPolicy: Always
  traffic:
  - tag: current
    revisionName: $SESSION_NAMESPACE-1-00001 
    percent: 0
  - tag: candidate
    revisionName: $SESSION_NAMESPACE-1-00002
    percent: 100
  - tag: latest
    latestRevision: true
    percent: 0   
EOF
```
### Refresh the application 

Execute the below to fetch the URL for app again.
```execute
kubectl get ksvc $SESSION_NAMESPACE-1 -n $WORKSHOP_NAMESPACE
```

Notice you only see the new version of the app.