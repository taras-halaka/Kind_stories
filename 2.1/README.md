# wordpress
[based on published example ](https://kubernetes.io/docs/tutorials/stateful-application/mysql-wordpress-persistent-volume/#objectives)

! Issues:
 - KIND in multi-node configuration did not works :(  
    - issue arrias with PVC  Storage-Class standard,  PVC stuck in pending state :( 

 - do not copy code, use CURL
 ```
 curl -LO https://k8s.io/examples/application/wordpress/mysql-deployment.yaml
 ```
```
curl -LO https://k8s.io/examples/application/wordpress/wordpress-deployment.yaml
```
 - apply configuration by using kubectl commands
 ```
 kubectl apply -k .
 ```
 - services on KIND didn't works, use fort-forward
 ```
 kubectl port-forward services/wordpress 8080:80
 ```
  - open URL to configure [http://127.0.0.1:8080/](http://127.0.0.1:8080/)

  - STATE of application didn't saved 

  - Clean up deployments
  ```
  kubectl delete -k .
  ```