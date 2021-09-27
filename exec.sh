ACCOUNT_NUMBER=<your_aws_accountId>
REGION=eu-west-1

APP_ECR_REPO_AUTH_SERVER=sso-authorization-server-ecs-repo
APP_ECR_REPO_RESOURCE_SERVER=sso-resource-server-ecs-repo
APP_ECR_REPO_CLIENT_APP_1=sso-client-app-1-ecs-repo
APP_ECR_REPO_CLIENT_APP_2=sso-client-app-2-ecs-repo
APP_ECR_REPO_AUTH_SERVER_URL=$ACCOUNT_NUMBER.dkr.ecr.$REGION.amazonaws.com/$APP_ECR_REPO_AUTH_SERVER
APP_ECR_REPO_RESOURCE_SERVER_URL=$ACCOUNT_NUMBER.dkr.ecr.$REGION.amazonaws.com/$APP_ECR_REPO_RESOURCE_SERVER
APP_ECR_REPO_CLIENT_APP_1_URL=$ACCOUNT_NUMBER.dkr.ecr.$REGION.amazonaws.com/$APP_ECR_REPO_CLIENT_APP_1
APP_ECR_REPO_CLIENT_APP_2_URL=$ACCOUNT_NUMBER.dkr.ecr.$REGION.amazonaws.com/$APP_ECR_REPO_CLIENT_APP_2

# Build the sprintboot Jar
mvn clean package

# Terraform infrastructure apply
cd templates
terraform init
terraform apply --auto-approve

cd ..

# sso-auth-server
docker build -t example/ecsfargateservice sso-authorization-server
docker tag example/ecsfargateservice ${APP_ECR_REPO_AUTH_SERVER_URL}:latest

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_NUMBER.dkr.ecr.$REGION.amazonaws.com
docker push ${APP_ECR_REPO_URL}:latest

#sso-resource-server
docker build -t example/ecsfargateservice sso-resource-server
docker tag example/ecsfargateservice ${APP_ECR_REPO_RESOURCE_SERVER_URL}:latest

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_NUMBER.dkr.ecr.$REGION.amazonaws.com
docker push ${APP_ECR_REPO_URL}:latest

#sso-client-app-1
docker build -t example/ecsfargateservice sso-client-app1
docker tag example/ecsfargateservice ${APP_ECR_REPO_CLIENT_APP_1_URL}:latest

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_NUMBER.dkr.ecr.$REGION.amazonaws.com
docker push ${APP_ECR_REPO_URL}:latest

#sso-client-app-2
docker build -t example/ecsfargateservice sso-client-app2
docker tag example/ecsfargateservice ${APP_ECR_REPO_CLIENT_APP_2_URL}:latest

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_NUMBER.dkr.ecr.$REGION.amazonaws.com
docker push ${APP_ECR_REPO_URL}:latest

#aws ecr list-images --repository-name ${APP_ECR_REPO_URL}

$SHELL