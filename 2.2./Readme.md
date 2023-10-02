# Deploy k8s resources using YAML files via terraform 

- get YAML file like [deployment.yaml](/2.2./deployment.yaml)
- <b>IMPORTANT</b> - check namespace was provided in metadata (or get error an fix it)
- APPLY:
  - terrarom init
  - terraform validate
  - terraform apply auto-approve
- Change:
  - change yaml file and update config 
  - update using 
    - terrafrom apply
- CleanUP:  terraform destroy



## the source
[how-do-i-deploy-a-kubernetes-service-through-yaml-using-terraform](https://stackoverflow.com/questions/65212368/how-do-i-deploy-a-kubernetes-service-through-yaml-using-terraform)
<!-- 
https://stackoverflow.com/questions/65212368/how-do-i-deploy-a-kubernetes-service-through-yaml-using-terraform
 -->

```You can use kubernetes_manifest for that. Quoting from its docs:

Represents one Kubernetes resource by supplying a manifest attribute. The manifest value is the HCL representation of a Kubernetes YAML manifest. To convert an existing manifest from YAML to HCL, you can use the Terraform built-in function yamldecode() or tfk8s.

So, you could do:

resource "kubernetes_manifest" "test" {
  manifest = yamldecode(file("${path.module}/config.yml"))
}
```
