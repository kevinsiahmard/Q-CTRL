Q-CTRL 
These are Terraform files for deploying:<br/>
2*EC2<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
2*Security Groups<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
1*S3 Bucket<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
1*ELB<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
on two different AZs on your defined region.<br/><br/><br/><br/><br/><br/><br/><br/><br/>

Notice that you will need to create a terraform.tfvars containing:<br/><br/><br/><br/><br/><br/><br/><br/>
access_key (AWS access key)<br/><br/><br/><br/><br/><br/><br/>
secret_key (AWS secret key)<br/><br/><br/><br/><br/><br/>
region (AWS region)<br/><br/><br/><br/><br/><br/>
key_name (AWS SSH key)<br/><br/><br/><br/><br/>
iam_instance_profile (AWS IAM profile for access to S3)<br/><br/><br/><br/>
<br/><br/><br/><br/>
and create and download pem key and upload it to your project folder.<br/>

This solution, create a Auto Scaling Group of WEB servers and it will monitor health and load of WEB servers. <br/><br/>
If load of CPU goes above %75 or one of WEB server instanes be unreachable, then new EC2 instances will be created and serve requests.<br/>

