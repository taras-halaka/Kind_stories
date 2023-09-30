# simply creates 3 nodes cluster on kind

terraform apply -auto-approve


`
name = "kindcluster"
`

<pre>
$ kubectl get nodes
NAME                        STATUS   ROLES           AGE   VERSION
kindcluster-control-plane   Ready    control-plane   62s   v1.28.0
kindcluster-worker          Ready    <none>          44s   v1.28.0
kindcluster-worker2         Ready    <none>          43s   v1.28.0
kindcluster-worker3         Ready    <none>          45s   v1.28.0



kubectl config get-contexts 
CURRENT   NAME               CLUSTER            AUTHINFO           NAMESPACE
*         kind-kindcluster   kind-kindcluster   kind-kindcluster   


</pre>


## to delete this procedure should be perfromed manually
```
kind get clusters
```
```
kind delete clusters kindcluster
```
