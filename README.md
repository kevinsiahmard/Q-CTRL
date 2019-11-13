Q-CTRL Assessment<br/><br/>
These are Terraform files for deploying:<br/>
2*EC2<br/>
2*Security Groups<br/>
1*ELB<br/>
on two different AZs on your defined region.<br/>

Notice that you will need to create a terraform.tfvars containing:<br/>
access_key (AWS access key)<br/>
secret_key (AWS secret key)<br/>
region (AWS region)<br/><br/>
key_name (AWS SSH key)<br/>
iam_instance_profile (AWS IAM profile for access to S3)<br/>
S3_Bucket_name (an existing S3 bucket)

and create and download pem key and upload it to your project folder.<br/>

This solution, create an Auto Scaling Group of WEB servers and it will monitor health and load of WEB servers. <br/>
If load of CPU goes above %75 or one of WEB server instanes be unreachable, then new EC2 instances will be created and serve requests.<br/>

