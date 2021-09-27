ACCOUNT_NUMBER=<your_aws_accountId>

#ECR_REPO_NAME="oauth-sso-app-ecs-repo"
APP_ECR_REPO_AUTH_SERVER="sso-authorization-server-ecs-repo"
APP_ECR_REPO_RESOURCE_SERVER="sso-resource-server-ecs-repo"
APP_ECR_REPO_CLIENT_APP_1="sso-client-app-1-ecs-repo"
APP_ECR_REPO_CLIENT_APP_2="sso-client-app-2-ecs-repo"

aws ecr batch-delete-image --repository-name $APP_ECR_REPO_AUTH_SERVER --image-ids imageTag=latest
aws ecr batch-delete-image --repository-name $APP_ECR_REPO_AUTH_SERVER --image-ids imageTag=untagged

aws ecr batch-delete-image --repository-name $APP_ECR_REPO_RESOURCE_SERVER --image-ids imageTag=latest
aws ecr batch-delete-image --repository-name $APP_ECR_REPO_RESOURCE_SERVER --image-ids imageTag=untagged

aws ecr batch-delete-image --repository-name $APP_ECR_REPO_CLIENT_APP_1 --image-ids imageTag=latest
aws ecr batch-delete-image --repository-name $APP_ECR_REPO_CLIENT_APP_1 --image-ids imageTag=untagged

aws ecr batch-delete-image --repository-name $APP_ECR_REPO_CLIENT_APP_2 --image-ids imageTag=latest
aws ecr batch-delete-image --repository-name $APP_ECR_REPO_CLIENT_APP_2 --image-ids imageTag=untagged


cd templates
terraform destroy --auto-approve
cd ..


$SHELL