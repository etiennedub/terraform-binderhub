# Terraform BinderHub Cluster

## Requirements

- Install [Terraform](https://www.terraform.io/downloads.html)

## Cloud Providers

### OpenStack

1. Download your project openrc file from the OpenStack _Access and security_ section.
2. Source your project openrc file : `source _project_-openrsh.sh`.


## DNS Providers

### CloudFlare

1. Export your CloudFlare email associated with the account : `export CLOUDFLARE_EMAIL="my_email@example.com"`
2. Export your Cloudflare API token : `export CLOUDFLARE_TOKEN="<YOUR API TOKEN>"`

### JetStream

JetStream domain name is automatically associated with your cloud service.

**Note:** this is only available on JetStream cloud services and incompatible with ComputeCanada.

## Terraform deployment

1. In this repository, create a new folder and go into : `mkdir my_cluster; cd my_cluster`.
2. Copy the corresponding cloud provider `.tf` file from the `examples/providers` directory : `cp ../examples/providers/my_provider.tf .`
3. Copy the corresponding DNS provider `.tf` file from the `examples/dns` directory : `cp ../examples/dns/my_dns.tf .`
4. Adapt the cluster variables in both `.tf` files (i.e.: # nodes, domain name, ssh key, etc).
5. Apply your credentials for the cloud and the DNS provider.
6. Set your username to be accessible in Terraform: `export TF_VAR_username=$OS_USERNAME`
7. Initiate the Terraform state : `terraform init`.
8. Verify the Terraform plan : `terraform plan`.
9. Apply the Terraform plan : `terraform apply`.

To tear down the cluster, from the `my_cluster` folder, call: `terraform destroy`.

## TODO

- Support others cloud providers (AWS, GCP, Azure, ...)
- Support others DNS providers
- User authentification
- Storage management
