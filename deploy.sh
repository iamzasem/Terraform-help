#!/bin/bash
chmod 400 terraform-publickey
terraform init &&
terraform plan &&
terraform apply --auto-approve

echo "ec2 instance and s3 bucket has been successfully created"
