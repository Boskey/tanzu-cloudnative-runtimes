This environment has multiple tabs within the window on the right hand side.

- **The Terminal** : We will be executing CLI commands through this Tab
- **Console** : This is where you can take a look at the Kubernetes Dashboard to see what is happening as you run through the exercises.
- **Editor**: This tab lets you edit any files needed.

Any applications we will be deploying will be opened in a new tab.

## View Knative ##

Knative has already been deployed on the Kubernetes Cluster. Click on the console tab on the right -->click the menu bar (>>) on the left --> Click on `Namespaces` under Cluster to take a look at the various namespaces created. Observe the namespace `knative-serving`.

```dashboard:open-dashboard
name: Console
```

You can also look at the namespaces via `kubectl`
```execute
kubectl get namespaces
```


## Tip ##
Did you type the command in yourself? If you did, click on the command instead and you will find that it is executed for you. You can click on any command which has the <span class="fas fa-running"></span> icon shown to the right of it, and it will be copied to the interactive terminal and run. If you would rather make a copy of the command so you can paste it to another window, hold down the shift key when you click on the command.
