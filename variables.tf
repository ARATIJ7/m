variable "public_key_path" {
  description = "Path to the public key file"
  default     = "~/.ssh/mongodb-key.pub"
}

variable "ami_id" {
  description = "AMI ID"
  default     = "ami-0abcdef1234567890"  # Replace with your desired AMI ID
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "user_data_east" {
  description = "User data script for East region"
  default     = "userdata-east.sh"
}

variable "user_data_west" {
  description = "User data script for West region"
  default     = "userdata-west.sh"
}
