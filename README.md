# sonarqube-aws-terraform
Terraform project which deploys whole infrastructure for SonnarQube using Terraform to AWS cloud. 

## required variables
terraform.tfvars are not commited to the VCS. Here is a simple example of terraform.tfvars in root directory
<pre><code>
# --- root/terraform.tfvars ---

access_ip       = "0.0.0.0/0"
public_key_path = "/Users/michalstefanec/.ssh/sonarqube.pub"

### DATABASE VARIABLES ###
db_name     = "sonarqube"
db_user     = "master"
db_password = "PASSWORD"

### SONARQUBE VARIABLES ###
server_user_password = "PASSWORD"
</code></pre>