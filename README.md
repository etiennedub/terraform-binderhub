# Terraform BinderHub Cluster

## Requirements

- Install [Terraform](https://www.terraform.io/downloads.html)

## Cloud Providers

### OpenStack

1. Download your project openrc file from the OpenStack _Access and security_ section.
2. Source your project openrc file : `source _project_-openrsh.sh`.

### Google Cloud

1. Install the [gcloud](https://cloud.google.com/sdk/install) command-line tool
2. Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
3. Install [helm](https://docs.helm.sh/using_helm/#installing-helm)
4. Login to Google Cloud : `gcloud auth application-default login`

**Note:** `GCloud` require to install `kubectl` and `helm` on your local setup. Those tools are used to configure remotely `kubernetes` containers.

## DNS Providers

### CloudFare

1. Export your CloudFare email associated with the account : `export CLOUDFLARE_EMAIL="my_email@example.com"`
2. Export your Cloudflare API token : `export CLOUDFLARE_TOKEN="<YOUR API TOKEN>"`

## Terraform deployment

1. In this repository, create a new folder and go into : `mkdir my_cluster; cd my_cluster`.
2. Copy the corresponding cloud provider `.tf` file from the `examples/providers` directory : `cp ../examples/providers/my_provider.tf .`
3. Copy the corresponding DNS provider `.tf` file from the `examples/dns` directory : `cp ../examples/dns/my_dns.tf .`
4. Adapt the cluster variables in both `.tf` files (i.e.: # nodes, domain name, ssh key, etc).
5. Apply your credentials for the cloud and the DNS provider.
6. Initiate the Terraform state : `terraform init`.
7. Verify the Terraform plan : `terraform plan`.
8. Apply the Terraform plan : `terraform apply`.

To tear down the cluster, from the `my_cluster` folder, call: `terraform destroy`.

## TODO

- Support others cloud providers (AWS, GCP, Azure, ...)
- Support others DNS providers
- User authentification
- Storage management
