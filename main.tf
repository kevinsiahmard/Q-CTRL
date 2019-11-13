
################   Q-CONTROL DevOps Challenge #####################

# Configure AWS connection, secrets are in terraform.tfvars
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

# Get availability zones for the region specified in var.region
data "aws_availability_zones" "all" {}

# Create autoscaling policy -> target at a 75% average CPU load
resource "aws_autoscaling_policy" "qc-asg-policy-1" {
  name                   = "qc-asg-policy"
  policy_type            = "TargetTrackingScaling"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = "${aws_autoscaling_group.qc-asg.name}"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 75.0
  }
}



# Create launch configuration
resource "aws_launch_configuration" "qc-lc" {
  name = "qc-lc"
  image_id = "ami-00bf61217e296b409"
  instance_type = "t2.nano"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.qc-lc-sg.id}"]

  iam_instance_profile = "${var.iam_instance_profile}"

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install httpd -y
              sudo service httpd start
              sudo chkconfig httpd on
              sudo aws s3 cp s3://"${var.s3_bucket_name}" /var/www/html/ --recursive
              echo "My name's Kevin Siahmard and Q-CTRL should hire me" >> /var/www/html/index.html
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

# Create the ELB
resource "aws_elb" "qc-elb" {
  name = "qc-elb"
  security_groups = ["${aws_security_group.qc-elb-sg.id}"]
  availability_zones = data.aws_availability_zones.all.names

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    #target = "TCP:${var.server_port}"
    target = "HTTP:${var.server_port}/index.html"
  }

  # This adds a listener for incoming HTTP requests.
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "${var.server_port}"
    instance_protocol = "http"
  }
}

# Create security group that's applied the launch configuration
resource "aws_security_group" "qc-lc-sg" {
  name = "qc-lc-sg"

  # Inbound HTTP from anywhere
  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "${var.ssh_port}"
    to_port = "${var.ssh_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create security group that's applied to the ELB
resource "aws_security_group" "qc-elb-sg" {
  name = "qc-elb-sg"

  # Allow all outbound
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound HTTP from anywhere
  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an autoscaling group
resource "aws_autoscaling_group" "qc-asg" {
  name = "qc-asg"
  launch_configuration = "${aws_launch_configuration.qc-lc.id}"
  availability_zones = data.aws_availability_zones.all.names

  min_size = 2
  max_size = 10

  load_balancers = ["${aws_elb.qc-elb.name}"]
  health_check_type = "ELB"

  tag {
    key = "Name"
    value = "QC-ASG"
    propagate_at_launch = true
  }
}

