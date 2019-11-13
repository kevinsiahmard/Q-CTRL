These are Terraform files for deploying:
2*EC2
2*Security Groups
1*S3 Bucket
1*ELB
on two different AZs on your defined region.

Notice that you will need to create a terraform.tfvars containing:
access_key (AWS access key)
secret_key (AWS secret key)
region (AWS region)
key_name (AWS SSH key)
iam_instance_profile (AWS IAM profile for access to S3)

and create and download pem key and upload it to your project folder.

This solution, create a Auto Scaling Group of WEB servers and it will monitor health and load of WEB servers. 
If load of CPU goes above %75 or one of WEB server instanes be unreachable, then new EC2 instances will be created and serves the requests.

