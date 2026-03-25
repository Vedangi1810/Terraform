Core Concepts:

Provisioning of infrastructure
IAC : allows to automate cloud infrastructure
API as a code - uses aws/gcp api's using providers
Business Source License-(can use freely)  (not open source)
Hashicorp terraform - acquired by IBM

why terraform ?
slow deployment
expensive
limited automation
Human error
wasted resources
inconsistency

CloudFormation : AWS
Azure Resouce Manager (ARM)/ Bicep : Azure
Deployment Manager : GCP
Heat Templates : OpenStack

Terraform Vs CloudFormation
- CloudFormation is aws specific to provision infra using templates

Setup on GCP VM and local
local (run in ps as administratorssss) : choco install terraform -y
==============================================================================================================

Terraform HCL (HashiCorp Configuration Language):

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
    Terraform with GCP (local setup):

    Manual Authentication Required: 
         You must explicitly tell Terraform which account to use (via gcloud auth application-default login) and which project to target within the provider "google" {} block.

    choco install gcloudsdk

    gcloud init

    gcloud auth application-default login --no-launch-browser
    or
    gcloud auth application-default login
]
================================================================================================================

Terraform on Multi-region / Multi-cloud
variables, condiyional expressions
Built-in functions - terraform

Publicily available modules - Terraform registry
in organization people write their own modules

.\Module_Practice\module
	main.tf
	variable.tf (without default values)
	output.tf
.\Module_Practice
	main.tf (using module block with source : ".\Module_Practice\module")
	provider.tf
	Terraform.tfvars
	variable.tf
	output.tf
================================================================================================================

Terraform show - display state file
Terraform.tfstate - generated post apply command
lock.hcl - generated post init command

Why only default.tfstate is in GCS?
    The .tflock file (which handles state locking) only exists while a command is running (like apply or plan). 
    Terraform creates the lock file in GCS at the start of an operation.
    It automatically deletes the lock file once the operation is finished.
    If you see only the default.tfstate file, it means no one is currently running a Terraform command on that state. 

Summary Table
File/Folder 	          Keep Locally?	          Commit to Git?	      Reason
.terraform/	         No (Can be recreated)	          No	       Local cache for plugins and modules.
.terraform.lock.hcl	 Yes                              Yes	       Ensures provider version consistency.
terraform.tfstate	 No (Moved to GCS)	              No	       Stored securely in your remote backend.

================================================================================================================

Provisioners
local-exec - capture steps and show while apply or redirect to some file
Remote-exec - while instance is created connect with instance and execute some commands (like python installation)
file provisioners - copy file to instance

================================================================================================================
Workspaces
terraform workspace new dev
terraform.tfstate.d
    dev
        terraform.tfstate
    uat
        terraform.tfstate
    prod
terraform workspace select dev
terraform workspace show
terraform apply 
================================================================================================================

Terraform Vault/Hashicorp Vault
sudo apt install vault
vault server -dev -dev-listen-address="0.0.0.0:8200"

Hashicopr vault - access- role - using cli
                  policy- iam policy

vault policy wrie terraform - <<EOF
vault write auth/approle/role/terraform \
vault read auth/approle/role/terraform/role-id
vault read auth/approle/role/terraform/secret-id

main.tf : use provider vault

Fine-grained access control : using Policy
Audit and Compliance : detailed logs of access and changes to secrets
Generated secrets dynamically (short lived credentials)
every client gets its own unique credentials
Encryption as a Service - vault to encrypt n decrypt data (database)

HTTP/S API : Core ==> Vault is API driven system - communication between clients and vault - through Vault API
Secret Engines ==> component store/encrypt/generate data
    each S.E handles difference types of secrets
    key/Value | Databases | AWS | RabbitMQ | PKI | SSH | k8S
Storage Backend ==> durable data persistent layer
Authentication metods ==> AWS auth method/K8S auth method/LDAP
    vault trust client identity provider (aws,k8s)
Everything is path based
Path routing :
    auth method
    secret engine
        Client Token
        - vault authenticates client
        - token with set of policies is issues as response (token r short-lived)
        - vault validates token and associated policy
Audit Device
Pluggable Architecture
================================================================================================================
Scenario based questions

Terraform migration:

terraform init
terraform plan -generate-config-out=generated_resources.tf
    new file generated_resources.tf will be created with all configurations
    copy resource block from generated file to main.tf file, later can delete generated_resources.tf file and import block
terraform import aws_instance.example <<inst_id>> -- still we don't have state file
    after this command will have state file
terraform plan
terraform apply -- if any change you added, else not required

Drift detection:
Resource managed by Terraform and manually if someone update (lifecycle of bucket) - Terraform will not understand automatically that there is a change
terraform refresh (refresh state file)

audit logs -- check if any manual change - detect using lambda function whether this resource is managed by terraform
send notificate that there is chnage that is made and i have noticed that this resource is manged by terraform but iam role that made the change is not the terraform role - but this iam role belongs to xyz iam user (person) - so I'm sending out notification like alert

