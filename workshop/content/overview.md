Knative [https://knative.dev] is a serverless solution to running applications on top of Kubernetes.
Simply put, Knative is a technology that abstracts and enhances the way that applications run on Kubernetes. Knative itself extends Kubernetes and has two main facets: Knative Serving and Knative Eventing. This workshop uses Knative Serving.

Knative (Serving) simplifies deploying microservices on Kubernetes. With a single command, you can build services based on your containerized applications without having to learn or build various Kubernetes objects. Knative automates the backend objects needed to run microservices on top of Kubernetes.

To learn more about Knative Serving check out [Whitney Lee](https://tanzu.vmware.com/developer/team/whitney-lee/)'s [video](https://tanzu.vmware.com/developer/tv/enlightning/6/) and [guide](https://tanzu.vmware.com/developer/guides/knative-serving-wi/). 
To learn about Knative Eventing, check out [this video](https://tanzu.vmware.com/developer/tv/enlightning/7/).

#### What you will do in the lab:

* Deploy an app to Kubernetes with Knative and understand what you did
* Install version 2 (v2) of your application and see how to manage each version
* Update the service such that incoming traffic is split between both apps by 50%-50%
* Observe the traffic being split between your applications
* Next, move all the traffic coming to the new app v2