provider "aws" {
  region = "us-east-1"
  access_key = ""
  secret_key = ""
}
resource "aws_vpc" "terraform-vpc" {
    cidr_block = "10.0.0.0/16"
} 

resource "aws_subnet" "terraform-subnet-1" {
   vpc_id = aws_vpc.terraform-vpc.id
   cidr_block = "10.0.11.0/24"
   availability_zone = "us-east-1a"
}
output "terraform-vpc-id" {
    value = aws_vpc.terraform-vpc.id
}
output "terraform-subnet-id" {
    value = aws_subnet.terraform-subnet-1.id
}
    

  
