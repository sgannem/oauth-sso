ACCOUNT_NUMBER=
REGION=eu-west-1

APP_ECR_REPO_AUTH_SERVER=sso-authorization-server-repo
APP_ECR_REPO_RESOURCE_SERVER=sso-resource-server-repo
APP_ECR_REPO_CLIENT_APP_1=sso-client-app-1-repo
APP_ECR_REPO_CLIENT_APP_2=sso-client-app-2-repo

APP_ECR_REPO_AUTH_SERVER_URL=$ACCOUNT_NUMBER.dkr.ecr.$REGION.amazonaws.com/$APP_ECR_REPO_AUTH_SERVER
APP_ECR_REPO_RESOURCE_SERVER_URL=$ACCOUNT_NUMBER.dkr.ecr.$REGION.amazonaws.com/$APP_ECR_REPO_RESOURCE_SERVER
APP_ECR_REPO_CLIENT_APP_1_URL=$ACCOUNT_NUMBER.dkr.ecr.$REGION.amazonaws.com/$APP_ECR_REPO_CLIENT_APP_1
APP_ECR_REPO_CLIENT_APP_2_URL=$ACCOUNT_NUMBER.dkr.ecr.$REGION.amazonaws.com/$APP_ECR_REPO_CLIENT_APP_2

# Build the sprintboot Jar
mvn clean package -DskipTests

# Terraform infrastructure apply
cd templates
terraform init
terraform apply --auto-approve

cd ..

# sso-auth-server
docker build -t example/sso-authorization-server sso-authorization-server
docker tag example/sso-authorization-server ${APP_ECR_REPO_AUTH_SERVER_URL}:latest

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_NUMBER.dkr.ecr.$REGION.amazonaws.com
docker push ${APP_ECR_REPO_AUTH_SERVER_URL}:latest
echo "sso-auth-server successfully uploaded"

#sso-resource-server
docker build -t example/sso-resource-server sso-resource-server
docker tag example/sso-resource-server ${APP_ECR_REPO_RESOURCE_SERVER_URL}:latest

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_NUMBER.dkr.ecr.$REGION.amazonaws.com
docker push ${APP_ECR_REPO_RESOURCE_SERVER_URL}:latest
echo "sso-resource-server successfully uploaded"

#sso-client-app-1
docker build -t example/sso-client-app-1 sso-client-app-1
docker tag example/sso-client-app-1 ${APP_ECR_REPO_CLIENT_APP_1_URL}:latest

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_NUMBER.dkr.ecr.$REGION.amazonaws.com
docker push ${APP_ECR_REPO_CLIENT_APP_1_URL}:latest
echo "sso-client-app-1 successfully uploaded"

#sso-client-app-2
docker build -t example/sso-client-app-2 sso-client-app-2
docker tag example/sso-client-app-2 ${APP_ECR_REPO_CLIENT_APP_2_URL}:latest

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_NUMBER.dkr.ecr.$REGION.amazonaws.com
docker push ${APP_ECR_REPO_CLIENT_APP_2_URL}:latest
echo "sso-client-app-2 successfully uploaded"

#aws ecr list-images --repository-name ${APP_ECR_REPO_URL}

$SHELL