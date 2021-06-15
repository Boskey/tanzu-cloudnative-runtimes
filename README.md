

Cloud Native Runtimes Workshop for Tanzu Developer Portal

For more detailed information on how to create and deploy workshops, consult
the documentation for Educates at:

* https://docs.edukates.io

If you already have the Educates operator installed and configured, to
deploy and view this sample workshop, run:

```
kubectl apply -f https://raw.githubusercontent.com/Boskey/tanzu-cloudnative-runtimes/main/resources/workshop.yaml?token=AAL7IVT35UV5M75XZQDZFI3AZE4IW
kubectl apply -f https://raw.githubusercontent.com/Boskey/tanzu-cloudnative-runtimes/main/resources/training-portal.yaml?token=AAL7IVSGVRS2A727J2ZAY4DAZE4K2
```

This will deploy a training portal hosting just this workshop. To get the
URL for accessing the training portal run:

```
kubectl get trainingportal/tanzu-cloudnative-runtimes
```


