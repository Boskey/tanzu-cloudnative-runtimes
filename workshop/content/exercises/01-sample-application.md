
We will be using a [Spring](https://spring.io/) based application called [Petclinic](https://github.com/spring-projects/spring-petclinic) to run in a serverless model.

The application has been containerized and the container image is store in the Github Container Repository.

The below `petclinic.yaml` file defines what application we want Cloud Native Runtimes to deploy.
Two Key fields to notice in the below file are:
* `metadata.name` 
  * This is the name the corresponding Service that will be created
* `spec.container.image`
  * This is the Container image that will be deployed 

Create your `petclinic.yaml` file.
```editor:append-lines-to-file
file: ~/petclinic.yaml
text: |
      apiVersion: serving.knative.dev/v1 # Current version of Knative
      kind: Service
      metadata:
        name: {{ session_namespace }}-1 # The name of the app
        namespace: {{ workshop_namespace }} # The namespace the app will use
      spec:
        template:
          spec:
            containers:
              - image: ghcr.io/boskey/petclinic
```

Apply your `petclinic.yaml` to deploy your Pet Clinic App.
```execute-1
kubectl apply -f petclinic.yaml
```

To list the service Cloud Native Runtimes created, execute the following command:
```execute-1
kubectl get ksvc {{ session_namespace }}-1 -n {{ workshop_namespace }}
```

You will see that the Cloud Native Runtime Service created an Ingress with a URL to the application.
```
Click on the URL from the above command to see the application
```
> Note: if the status of the service shows `Not Ready`, wait a minute, try running the command to list the service again and then click the URL*

You just deployed and accessed your first application to Cloud Native Runtimes!

### What's happening here?

In the backend, Cloud Native Runtimes pulled the container image that packaged the Petclinic App, deployed it on Kubernetes with a Revision, created a Service and Ingress for the app and returned the Ingress URL. 

Cloud Native Runtimes figures out and creates all the Kubernetes objects needed to make all of the above work.