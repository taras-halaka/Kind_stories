# how to use
[based on  /hashicorp/kubernetes/latest/docs/guides/getting-started](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/guides/getting-started) 

### 1. [Kind cluster shoud be craeted first](/2.0/make_kube/README.md)

apply terrafrom configuration

<pre>
terraform init
terraform plan
terraform apply -auto-approve


kubectl get all -n nginx 
NAME                        READY   STATUS    RESTARTS   AGE
pod/nginx-9dcf76bb5-8l2dv   1/1     Running   0          89s
pod/nginx-9dcf76bb5-pnk85   1/1     Running   0          89s

NAME            TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
service/nginx   NodePort   10.96.138.29   <none>        80:30201/TCP   34s

NAME                    READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx   2/2     2            2           89s

NAME                              DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-9dcf76bb5   2         2         2       89s

</pre>

## get POD ip address assinged during deployment

## UNFORTUNALY does not works with KIND in simple way :(
<pre>
 kubectl get -n nginx pod nginx-9dcf76bb5-8l2dv -o json | jq .status.hostIP
 "10.89.0.28"
</pre>


## USE PORT-FORWARD instead

<pre>
kubectl port-forward -n nginx pods/nginx-9dcf76bb5-8l2dv 8080:80
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
Handling connection for 8080
</pre>
http://127.0.0.1:8080/


# add customization to pod itself
- login to pod shell
```
kubectl exec -n nginx pods/nginx-9dcf76bb5-8l2dv -i -t -- bash
```
- add some info to end of index.html file
```
cat /etc/os-release >> /usr/share/nginx/html/index.html 
```

the results should be, something like this


<img src="ASSETS/pod_nginx_samples_2023-09-30 19-19-19.png" alt="NGINX POD" style="width:600px;"/>