## Requirements

This template will not create the needed network resources when deploying the GKE cluster.
Make sure you define the needed secondary IP ranges in the subnetwork you want to deploy your app to.
Their name must follow the following naming convention:

```
${subnet-name}-gke-pods
${subnet-name}-gke-services
```

## Deploy

```
terraform init
```

```
terraform apply -target=module.cloudsql_service_account
```

```
terraform apply
```
