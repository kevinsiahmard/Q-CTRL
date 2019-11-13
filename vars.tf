variable access_key {}
variable s3_bucket_name {}
variable secret_key {}
variable region {}
variable key_name {}
variable iam_instance_profile {}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = 80
}

variable "ssh_port" {
  default = 22
}

variable "ecount" {
  description = "Number of EC2 instances"
  default = 1
}
