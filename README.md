

Knative Workshop for Tanzu Developer Portal

For more detailed information on how to create and deploy workshops, consult
the documentation for Educates at:

[TODO: replace link]
* https://docs.edukates.io

If you already have the Educates operator installed and configured, to
deploy and view this sample workshop, run:

```
kubectl apply -f https://github.com/vmware-tanzu-labs/lab-tanzu-cloudnative-runtimes/blob/educates-update/workshop/workshop.yaml
kubectl apply -f https://github.com/vmware-tanzu-labs/lab-tanzu-cloudnative-runtimes/blob/educates-update/resources/trainingportal.yaml
```

This will deploy a training portal hosting just this workshop. To get the
URL for accessing the training portal run:

```
kubectl get trainingportal/tanzu-cloudnative-runtimes
```


