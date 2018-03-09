# terraform - quickvnet

A terraform config which will build a quick vNet and Subnet in Azure.

```
terraform init
terraform plan
terraform apply
```

```
terraform destroy
```

Note that because this is a shared resource that other Terraform configs will rely on we need to store and share the state.
See https://stackoverflow.com/questions/48650260/layered-deployments-with-terraform

Will output the <TBA>
