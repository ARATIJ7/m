variable "public_key_path" {
  description = "Path to the public key file"
  default     = "~/.ssh/mongodb-key.pub"
}

variable "ami_id_east" {
  description = "AMI ID for East region"
  default     = "ami-02f7f38e06e586791"  # Replace with your desired AMI ID for the East region
}

variable "ami_id_west" {
  description = "AMI ID for West region"
  default     = "ami-0d3b80bc1bf64610c"  # Replace with your desired AMI ID for the West region
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
