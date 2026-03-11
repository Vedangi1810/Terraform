Core Concepts:

Provisioning of infrastructure
IAC : allows to automate cloud infrastructure
Business Source License-(can use freely)  (not open source)
Hashicorp terraform - acquired by IBM

why terraform ?
slow deployment
expensive
limited automation
Human error
wasted resources
inconsistency

Terraform Vs CloudFormation
- CloudFormation is aws specific to provision infra using templates

Setup on GCP VM and local
local (run in ps as administratorssss) : choco install terraform -y
==============================================================================================================

Terrafor HCL (HashiCorp Configuration Language):

Basic Syntax: Blocks, Arguments, Attributes
<block> <parameters>{
    <arguments>
}

block ==> resource, variable, output
parameters ==> type of resource, type of variable

Types of blocks:
provider, resource, variable, output, module

arguments : things we write before execution
attributes : things we are known after execution
================================================================================================================
mkdir terraform-for-devops
main.tf

Workflow:
Initialise:
main.tf --> terraform init (only once to create environment)
ls -a (environment is hidden)

.terraform/providers/registry.terraform.io/hashicorp/local/2.5.2/linux_amd64/terraform-provider-local_v2.5.2_x5
[
    student-03-68542267d678@ubuntu-vm:~/terrafor-for-devops$ ls -a
    .  ..  .terraform  .terraform.lock.hcl  main.tf
]

Validate (optional):
terraform validate

Planning: (dry run of output)
terraform plan

Apply: (executes and get actual output)
terraform apply
terraform apply -auto-approve

Destroy:
terraform destroy
terraform destroy -auto-approve
================================================================================================================
Terraform Providers
By default I'll have local provider only
to get aws, gcp provider write terraform.tf

terraform.tf [https://registry.terraform.io/providers/hashicorp/google/latest]
terraform init (this will add google provider in terraform env)

install gcp cli
gcloud version
gcloud init

gcloud configure
aws s3 ls

IAM - users - create user

provider.tf

[
    Terraform with GCP:
    gcloud auth application-default login --no-launch-browser
]
================================================================================================================