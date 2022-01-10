## openresty119php74 docker image docker file

## Docker env to build nginx/openresty1.19.x and PHP 7.x and push docker image to a given registry

### To Build image

#### Run `docker build -t ${YOUR AWS ACCOUNT ID HERE}.dkr.ecr.${AWS REGION}.amazonaws.com/openresty119-php74 -f devops/docker/Dockerfile .`

### To Push image to Docker hub or other registry

#### Run `docker push ${YOUR AWS ACCOUNT ID HERE}.dkr.ecr.${AWS REGION}.amazonaws.com/openresty119-php74:latest`

### To push image to docker hub

#### `docker build -t your_docker_hub_account_user_name:openresty119-php74 -f devops/docker/Dockerfile .`

#### `docker push your_docker_hub_account_user_name:openresty119-php74`


