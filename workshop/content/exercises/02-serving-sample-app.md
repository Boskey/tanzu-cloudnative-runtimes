So far we have created a service for a containerized app based on Spring and have external traffic flowing to it. 

Imagine, you made some improvements to the app and you want to roll the new version out, but are not sure about how users might react to the changes. You may want to conduct an A/B test to see user behavior/reaction.

Knative can help you deploy newer versions of your app and manage traffic flow to the services.

### Routes
Every time we deploy a service using Knative, a _revision_ is automatically assigned to it. 

For example, for the service we deployed earlier, the revision can be found using:
```execute
kubectl get revision  -A| grep {{ session_namespace }}
```

Observe the second field; the revision is usually of the form `$SERVICE_NAME-00001` for the initial deployment.

Let's say we changed the pet's picture from the original app and containerized the new app as `v2`.

We now want to deploy the `v2` version of the app, optionally direct 50% of the incoming traffic to it, and if all looks well direct all traffic to app `v2`.

### First, let's install app `v2`.  

Click here to select the image reference you are going to change:
```editor:select-matching-text
file: ~/petclinic.yaml
text: "ghcr.io/boskey/petclinic"
```

Notice the container image name now and has the suffix `2`.
```editor:replace-text-selection
file: ~/petclinic.yaml
text: ghcr.io/boskey/petclinic2
```

Also, notice we are deploying `v2` with the same service name as before and even using the same file as before `petclinic.yaml`. You are only changing the container that has the new app.

Now, use `kubectl` to deploy your PetClinic App `v2`.
```execute-1
kubectl apply -f petclinic.yaml
```

Wait for a minute for the deployment to proceed...

Once app `v2` is deployed, you will notice the service now has two revisions.
```execute
kubectl get revision -A| grep {{ session_namespace }}
```

If you click on the application URL from before, 100% of the traffic is still going to app `v1` with the old image.

### Refresh the application tab we opened before

Now, let's update the service such that incoming traffic is split 50/50 between `v1` and `v2`.

Notice the `spec.traffic` element in the file below.

Execute the following to update the service spec: 
```editor:insert-value-into-yaml
file: ~/petclinic.yaml
path: spec
value:
    traffic:
    - tag: current
      revisionName: app-{{ session_namespace }}-00001 
      percent: 50
    - tag: candidate
      revisionName: app-{{ session_namespace }}-00002
      percent: 50
    - tag: latest
      latestRevision: true
      percent: 0   
```

Re-apply your `petclinic.yaml` to split the traffic.
```execute-1
kubectl apply -f petclinic.yaml
```

Give the service a few seconds to be updated.

### Move incoming traffic to the new app

### Refresh the application 

Execute the below to fetch the URL for app again.
```execute
kubectl get ksvc app-{{ session_namespace }} -n default
```
You will notice that the traffic is now splitting between the old and new versions after each refresh.

Okay, now that we see the new app `v2` and since everything seems to be fine, let's move all the traffic coming to the new app `v2`.

Execute the below: notice the traffic is now defined to go to revision for app `v2` only.

Select the traffic value for both PetClinic apps `v1` and `v2`.
```editor:select-matching-text
file: ~/petclinic.yaml
text: "percent: 50"
isRegex: true
```

Now, change the percent of traffic received by `v1` to 0.
```execute-1
sed -i '0,/50/{s/50/0/}' petclinic.yaml
```

Now, change the percent of traffic received by `v2` to 100 so all traffic goes to `v2`.
```execute-1
sed -i 's/50/100/g' petclinic.yaml
```

Once again re-`apply` your `petclinic.yaml` to send all the traffic to `v2`.
```execute-1
kubectl apply -f petclinic.yaml
```

### Refresh the application 

Execute the below to fetch the URL for app again.
```execute
kubectl get ksvc app-{{ session_namespace }} -n default
```

Notice you only see the new version of the app as was originally intended.