# Deploy WordPress on AKS

## first of all need to create AKS before apply WordPress Desployment

[deploy ASK](../AKS/README.md)

check that you have stable connection to kubernetes cluster.

in case if issues occurs, delete cached/exiting ~/.kube/config file and import configuration


## Second stage deploy WordPress

[depoy Wordpress](../wordpress/Readme.md)

















# curent version called "dirty" because it is not cleaned up

I had some issues with access to site, after terraform destroy,apply commands
and may be internet connection issues, that I cannot fix now. :( 
    this is the only reason to save dirty state config

<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
----------------------------

Current config has issues with DNS names resolutions,
KIND cluster did not resolve dns names of services,
thoose is why, wordpress cannot get mysql service IP and start configuration

# fail for now.

## issue is - that wordpress container, gets environment variables but do not apply them to wp_config.php file those is why it does not see and cannot connect to DB

```
kubectl run -i -t alpine --image=alpine --restart=Never --rm -n wordpress-namespace
```
[DNS Utils to troubleshot](https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/) 
```
kubectl apply -f https://k8s.io/examples/admin/dns/dnsutils.yaml
```


parse secret value
```
kubectl get secret wordpress-secrets -n <namespace> -o jsonpath='{.data.MYSQL_PASSWORD}' | base64 --decode

```
```
kubectl -n wordpress-namespace get secret wordpress-secrets -o jsonpath='{.data.MYSQL_ROOT_PASSWORD}' | base64 --decode
```

STUCK on service expose :(

    service created via terraform , cannot be reached

    ```
     kubectl -n wordpress-namespace port-forward services/mysql 9999:3306
     ```

MYSQL is OK, I'm able to connect using another mysql instance
```
kubectl run -i -t mysql-latest --image=mysql:latest --restart=Never --rm -n wordpress-namespace --env="MYSQL_ALLOW_EMPTY_PASSWORD=1"

```
provide desired pod IP.

```
mysql -uroot -pcm9vdHBhc3N3b3JkMjIy -h 10.244.0.35
```

but service has no endpoint to target pods.

### for wordpress 

Endpoints:         10.244.0.39:80
### for mysql
<b>Endpoints:         <none></b>


<pre>

[terra@MiWiFi-R4CM-srv Wordpress]$ kubectl -n wordpress-namespace get pods -o wide
NAME                                   READY   STATUS    RESTARTS   AGE     IP            NODE                   NOMINATED NODE   READINESS GATES
mysql-deployment-758996b997-d6k84      1/1     Running   0          4m51s   10.244.0.38   simple-control-plane   <none>           <none>
wordpress-deployment-75787c8f4-pp92v   1/1     Running   0          4m47s   10.244.0.39   simple-control-plane   <none>           <none>



[terra@MiWiFi-R4CM-srv Wordpress]$ kubectl -n wordpress-namespace describe services/mysql 
Name:              mysql
Namespace:         wordpress-namespace
Labels:            <none>
Annotations:       <none>
Selector:          app=mysql-deployment
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.96.229.109
IPs:               10.96.229.109
Port:              <unset>  3306/TCP
TargetPort:        3306/TCP
Endpoints:         <none>
Session Affinity:  None
Events:            <none>
[terra@MiWiFi-R4CM-srv Wordpress]$ kubectl -n wordpress-namespace describe services/wordpress-service 
Name:              wordpress-service
Namespace:         wordpress-namespace
Labels:            <none>
Annotations:       <none>
Selector:          app=wordpress
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.96.58.118
IPs:               10.96.58.118
Port:              http  80/TCP
TargetPort:        80/TCP
Endpoints:         10.244.0.39:80
Session Affinity:  None
Events:            <none>


</pre>

but in case of YAML file deployments
SErvice created with endpoint
```
[terra@MiWiFi-R4CM-srv Wordpress]$ kubectl describe service wordpress-mysql 
Name:              wordpress-mysql
Namespace:         default
Labels:            app=wordpress
Annotations:       <none>
Selector:          app=wordpress,tier=mysql
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                None
IPs:               None
Port:              <unset>  3306/TCP
TargetPort:        3306/TCP
Endpoints:         10.244.0.28:3306
Session Affinity:  None


```