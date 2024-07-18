variable "key_name" {
  description = "Name of the existing key pair"
  type        =  string
}

variable "ami_id_east" {
  description = "AMI ID for East region"
  default     = "ami-0bcdb47863b39579f"  # Replace with your desired AMI ID for the East region
}

variable "ami_id_west" {
  description = "AMI ID for West region"
  default     = "ami-0323ead22d6752894"  # Replace with your desired AMI ID for the West region
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

