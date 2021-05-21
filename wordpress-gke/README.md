# Terraform Wordpress

This Terraform template sets up an infrastrcture for deploying a wordpress instance.
It creates a GKE cluster inside a given network, a cloud SQL instance and deploy wordpress on the Kube cluster.

## Requirements

This template will not create the needed network resources when deploying the GKE cluster.
Make sure you define the needed secondary IP ranges in the subnetwork you want to deploy your app to.
Their name must follow the following naming convention:

- `${subnet-name}-gke-pods`
- `${subnet-name}-gke-services`

Also, make sure you define a private connection in the network you intend to deploy Cloud SQL to.

## Deploy

- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply -target=module.cloudsql_service_account` to create the needed service accounts
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

## Inputs

| Name           | Description                                                                          | Type   | Default | Required |
| -------------- | ------------------------------------------------------------------------------------ | ------ | ------- | :------: |
| project_id     | The project ID to host the cluster in (required)                                     | string |         |   yes    |
| cluster_name   | The name of the cluster (required)                                                   | string |         |   yes    |
| network        | The VPC network to host the cluster in (required)                                    | string |         |   yes    |
| subnetwork     | The subnetwork to host the cluster in (required)                                     | string |         |   yes    |
| region         | The region to host the cluster in (optional if zonal cluster / required if regional) | string |         |   yes    |
| zone           | The zone to host the cloud sql instance in (required)                                | string |         |   yes    |
| project_number | The project number to host the cluster in (required)                                 | string |         |   yes    |
| prefix         | Prefix that will be used for each created resource                                   | string | wp      |    no    |
