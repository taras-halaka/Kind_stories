# Kind_stories
my tests around the KIND and terraform



# to use

1. ### initialize KIND cluser

<pre>
terraform init
terraform apply -auto-approve
</pre>

2. ### get initial error
<pre>
╷
│ Error: Failed to create deployment: Post "http://localhost/apis/apps/v1/namespaces/default/deployments": dial tcp [::1]:80: connect: connection refused
</pre>
3. ### apply one more time
<pre>
terraform init
terraform apply -auto-approve
</pre>
4. ### the result is
<pre>

$ kubectl get all
NAME                                      READY   STATUS    RESTARTS   AGE
pod/example-deployment-75977b6cb8-5675l   1/1     Running   0          40s
pod/example-deployment-75977b6cb8-5wbqw   1/1     Running   0          40s
pod/example-deployment-75977b6cb8-7xvxg   1/1     Running   0          40s
pod/example-deployment-75977b6cb8-qdkff   1/1     Running   0          40s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   95s

NAME                                 READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/example-deployment   4/4     4            4           40s

NAME                                            DESIRED   CURRENT   READY   AGE
replicaset.apps/example-deployment-75977b6cb8   4         4         4       40s
[terra@MiWiFi-R4CM-srv Kind_stories]$ code .
</pre>


that is it for now. 2023/09/30

## to clean up
<pre>
terraform destroy -auto-approve
kind delete clusters my-cluster
</pre>
