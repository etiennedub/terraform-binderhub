# Terraform BinderHub Cluster

## Requirements

- Install [Terraform](https://www.terraform.io/downloads.html)
- [Cloudflare API token](https://api.cloudflare.com/) to interact with the DNS resources
- Openstack OpenRC file

## Usage

### OpenStack Cloud

1. Go into `openstack` folder : `cd openstack`.
3. Download your project openrc file from the OpenStack _Access and security_ section.
4. Source your project openrc file : `source _project_-openrsh.sh`.
2. Export the following environment variables `CLOUDFLARE_EMAIL` and `CLOUDFLARE_TOKEN` to setup the DNS.
5. Initiate the Terraform state : `terraform init`.
7. Adapt the cluster variables in the `main.tf` file (i.e.: # nodes, domain name, ssh key, etc).
8. Verify the Terraform plan : `terraform plan`.
9. Apply the Terraform plan : `terraform apply`.

To tear down the cluster, from the `openstack` folder, call: `terraform destroy`.

## TODO

- Support others cloud providers (AWS, GCP, Azure, ...)
- Support others DNS providers
- User authentification
- Storage management
