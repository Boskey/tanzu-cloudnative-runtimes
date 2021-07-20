We will be using a [Spring](https://spring.io/) based application called [Petclinic](https://github.com/spring-projects/spring-petclinic) to run in a serverless mode.

The application has been containerized and the container image is store in the Docker Hub Repo.

```execute
cat <<EOF | kubectl apply  -f -
apiVersion: serving.knative.dev/v1 # Current version of Knative
kind: Service
metadata:
  name: petclinic # The name of the app
  namespace: $WORKSHOP_NAMESPACE # The namespace the app will use
spec:
  template:
    spec:
      containers:
        - image: ghcr.io/boskey/petclinic
EOF
```
