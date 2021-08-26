So far we have created a service for a containerized app based on Spring and have external traffic flowing to it. 

Imagine, you made some improvements to the app, you want to roll the new version out but are not sure about how users might react to the changes. You want to maybe conduct an A/B test to see user behavior/reaction.

Cloud Native runtimes can help you roll newer versions of your app and manage traffic flow to the services

### Routes
Everytime we deploy a service using Cloud Native Runtimes, the service gets a revision automatically assigned to it. 

For e.g, for the service we deployed earlier, the revision can be found using:
```execute
kubectl get revision  -A| grep {{ session_namespace }}
```

Observe the second field, the revision is usually the `$SERVICE_NAME-00001` for the initial deployment.

Let's say we changed the Pet's picture from the original app and containerized the new app as `v2`.

We now want to deploy the `v2` version of the app, maybe direct 50% of the incoming traffic to app v2, and if all looks well direct all traffic to app `v2`.

### First, let's install app `v2`.  

Click here to select the image reference you are going to change.
```editor:select-matching-text
file: ~/petclinic.yaml
text: "ghcr.io/boskey/petclinic"
```

Notice the container image is different now and has the suffix `2`.
```editor:replace-text-selection
file: ~/petclinic.yaml
text: ghcr.io/boskey/petclinic2
```

Also, notice we are deploying `v2` with the same service name as before and even using the same file as before `petclinic.yaml`. You are only changing the container that has the new app.

Now, apply your `petclinic.yaml` to deploy your Pet Clinic App `v2`.
```execute-1
kubectl apply -f petclinic.yaml
```

Wait for a minute for the deployment to proceed.

Once app `v2` is deployed, you will notice the service now has two revisions.
```execute
kubectl get revision  -A| grep {{ session_namespace }}
```

If you click on the application URL from before, 100 % of the traffic is still going to app `v1` with the old image.

### Refresh the application tab we opened before

Now, let's update the service such that incoming traffic is split between `v1` and v2 50-50

Notice the `spec.traffic` element in the file below

Execute below to update the service. 
```editor:insert-value-into-yaml
file: ~/petclinic.yaml
path: spec.template
value:

traffic:
- tag: current
  revisionName: {{ session_namespace }}-1-00001 
  percent: 50
- tag: candidate
  revisionName: {{ session_namespace }}-1-00002
  percent: 50
- tag: latest
  latestRevision: true
  percent: 0   
```

Re-apply your `petclinic.yaml` to split the traffic.
```execute-1
kubectl apply -f petclinic.yaml
```

Give the service a few seconds to be re-configured and updated. 

## Move incoming traffic to the new app

Execute the below to fetch the URL for app again
```execute
kubectl get ksvc {{ session_namespace }}-1 -n {{ workshop_namespace }}
```
You will notice that the traffic is now splitting between the old and new versions after each refresh.

Okay, now that we see the new app `v2` and since everything seems to be fine, lets move all the traffic coming to the new app `v2`.

Execute the below, notice the traffic is now defined to go to revision for app `v2` only.

Select the traffic values for the petclinic app, we will next change the value for `v1` to 0.
```editor:select-matching-text
file: ~/petclinic.yaml
text: "percent: 50"
isRegex: true
start: 14
stop: 16
```

Now, change the percent of traffic received by `v1` to 0.
```execute-1
sed -i '0,/50/{s/50/0/}' petclinic.yaml
```

Change the traffic value for the `v2` app, we will next change the value to 0.
```editor:select-matching-text
file: ~/petclinic.yaml
text: "percent: 50"
isRegex: true
start: 17
stop: 19
```

Now, change the percent of traffic received by `v2` to 100.
```execute-1
sed -i 's/50/100/g' petclinic.yaml
```

Once again re-apply your `petclinic.yaml` to send all  the traffic to `v2`.
```execute-1
kubectl apply -f petclinic.yaml
```

### Refresh the application 

Execute the below to fetch the URL for app again.
```execute
kubectl get ksvc {{ session_namespace }}-1 -n {{ workshop_namespace }}
```

Notice you only see the new version of the app as was inteded originally.