This is an example page for exercises to be done for the workshop. You would remove this page, replace it with your own and then adjust the `workshop.yaml` and `modules.yaml` file to list your pages instead.

In this example the pages which make up the core of the workshop content are placed in a sub directory. This is only done as a suggestion. You can place all pages at the same directory level if you wish.

Included below are some tests and examples of page formatting using Markdown.

#### Standard code block

```
echo "standard code block"
```

#### Click text to execute

```execute
echo "execute in terminal 1"
```

#### Click text to execute (with target)

```execute-1
echo "execute in terminal 1"
```

```execute-2
echo "execute in terminal 2"
```

```execute-all
echo "execute in all terminals"
```

#### Click text to copy

```copy
echo "copy text to buffer"
```

#### Click text to copy (and edit)

```copy-and-edit
echo "copy text to buffer"
```

#### Interrupt command

```execute
sleep 3600
```

```execute
<ctrl-c>
```

#### Variable interpolation

workshop_name: {{ workshop_name }}

session_namespace: {{ session_namespace }}

workshop_namespace: {{ workshop_namespace }}

training_portal: {{ training_portal }}

ingress_domain: {{ ingress_domain }}

ingress_protocol: {{ ingress_protocol }}

#### Web site links

[External](https://github.com/eduk8s)

```dashboard:create-dashboard
name: Wavefront
url: https://vmware.wavefront.com/dashboards/integration-kubernetes-summary#_v01(g:(d:7200,ls:!t,s:1623265449),p:(cluster_name:(d:Label,f:TAG_KEY,k:cluster,l:cluster,m:(Label:'*',Label_365:boksey-serverless),q:'collect(max(ts(%22kubernetes.cluster.cpu.limit%22),%20cluster),%20taggify(1,%20cluster,%20%22*%22))',s:Label_365)))
```
