variable "public_ip" {
  description = "Public IP address for SSH access"
  type        = string
}

variable "public_key" {
  description = "Public key for the EC2 instance"
  type        = string
}
