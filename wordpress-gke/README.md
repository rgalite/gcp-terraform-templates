# Terraform Wordpress

## Requirements

This template will not create the needed network resources when deploying the GKE cluster.
Make sure you define the needed secondary IP ranges in the subnetwork you want to deploy your app to.
Their name must follow the following naming convention:

- `${subnet-name}-gke-pods`
- `${subnet-name}-gke-services`

## Deploy

- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply -target=module.cloudsql_service_account`
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

## Inputs

| Name           | Description                                                                          | Type | Default | Required |
| -------------- | ------------------------------------------------------------------------------------ | ---- | ------- | :------: |
| project_id     | The project ID to host the cluster in (required)                                     |      |         |   yes    |
| cluster_name   | The name of the cluster (required)                                                   |      |         |   yes    |
| network        | The VPC network to host the cluster in (required)                                    |      |         |   yes    |
| subnetwork     | The subnetwork to host the cluster in (required)                                     |      |         |   yes    |
| region         | The region to host the cluster in (optional if zonal cluster / required if regional) |      | null    |   yes    |
| project_number | The project number to host the cluster in (required)                                 |      |         |   yes    |
