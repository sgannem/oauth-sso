ACCOUNT_NUMBER=

#ECR_REPO_NAME="oauth-sso-app-ecs-repo"
APP_ECR_REPO_AUTH_SERVER="sso-oauth-app-repo"
APP_ECR_REPO_RESOURCE_SERVER="sso-oauth-app-repo"
APP_ECR_REPO_CLIENT_APP_1="sso-oauth-app-repo"
APP_ECR_REPO_CLIENT_APP_2="sso-oauth-app-repo"

aws ecr batch-delete-image --repository-name $APP_ECR_REPO_AUTH_SERVER --image-ids imageTag=latest
aws ecr batch-delete-image --repository-name $APP_ECR_REPO_AUTH_SERVER --image-ids imageTag=untagged
echo "all sso-oauth repos deleted successfully"

aws ecr batch-delete-image --repository-name $APP_ECR_REPO_RESOURCE_SERVER --image-ids imageTag=latest
aws ecr batch-delete-image --repository-name $APP_ECR_REPO_RESOURCE_SERVER --image-ids imageTag=untagged
echo "all sso-resource-server repos deleted successfully"

aws ecr batch-delete-image --repository-name $APP_ECR_REPO_CLIENT_APP_1 --image-ids imageTag=latest
aws ecr batch-delete-image --repository-name $APP_ECR_REPO_CLIENT_APP_1 --image-ids imageTag=untagged
echo "all sso-client-app-1 repos deleted successfully"

aws ecr batch-delete-image --repository-name $APP_ECR_REPO_CLIENT_APP_2 --image-ids imageTag=latest
aws ecr batch-delete-image --repository-name $APP_ECR_REPO_CLIENT_APP_2 --image-ids imageTag=untagged
echo "all sso-client-app-2 repos deleted successfully"

cd templates
terraform destroy --auto-approve
cd ..


$SHELL