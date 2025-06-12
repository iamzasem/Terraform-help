terraform init &&
terraform plan &&
terraform apply --auto-approve

echo "ec2 instance and s3 bucket has been successfully created"
echo "it will be auto destroyed in 2 minutes"

sleep 120

terraform destroy --auto-approve
echo " your services has been destroyed"

