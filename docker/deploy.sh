#!/bin/bash

# 実行時に指定された引数の数、つまり変数 $# の値が 2 以上でなければエラー終了。
if [ $# -lt 2 ]; then
  echo "指定された引数は$#個です。" 1>&2
  echo "実行するには2個以上の引数が必要です。" 1>&2
  echo "Usage: deploy.sh {dev|pro} {start|stop}" 1>&2
  echo "   or  deploy.sh pro {config|imagepush}" 1>&2
  exit 1
fi

ENV=$1
COMMAND=$2
ACCESS_KEY=$3
SECRET_KEY=$4
IMAGE_NAME='datavol'
ECS_RESION='ap-northeast-1'
ECS_CLUSTER='mob-map2'
ECR_REPOS='nasu3108'
REPOS_NAME='mob-map-datavol'
REPOS_URL="807116252089.dkr.ecr.$ECS_RESION.amazonaws.com/$ECR_REPOS/$REPOS_NAME"

echo_and_do () {
    echo "$1"
    eval "$1"
}

deploy_config_pro () {
    echo_and_do "ecs-cli configure --region $ECS_RESION --access-key $ACCESS_KEY --secret-key $SECRET_KEY --cluster $ECS_CLUSTER"
}

deploy_imagepush_pro () {
    echo_and_do "$(aws ecr get-login --no-include-email --region $ECS_RESION)"
    echo_and_do "docker build -t $ECR_REPOS/$REPOS_NAME .."
    echo_and_do "docker tag $ECR_REPOS/$REPOS_NAME:latest $REPOS_URL:latest"
    echo_and_do "docker push $REPOS_URL"
}

deploy_start_pro () {
    echo_and_do "ecs-cli compose -f ./docker-compose.yml service up --target-group-arn arn:aws:elasticloadbalancing:ap-northeast-1:807116252089:targetgroup/mob-map-lb-target2/f7a531c52fe0e54e --container-name nginx --container-port 8080 --role ecsServiceRole"
    echo_and_do "ecs-cli ps"
}

deploy_start_pro_balance () {
    echo_and_do "ecs-cli compose -f ./docker-compose.yml service up --target-group-arn arn:aws:elasticloadbalancing:ap-northeast-1:807116252089:targetgroup/mob-map-lb-target2/f7a531c52fe0e54e --container-name nginx --container-port 8080 --role ecsServiceRole"
    echo_and_do "ecs-cli compose -f ./docker-compose.yml scale 2"
    echo_and_do "ecs-cli ps"
}

deploy_stop_pro () {
    echo_and_do "ecs-cli compose -f ./docker-compose.yml down"
    echo_and_do "ecs-cli compose -f ./docker-compose.yml service rm"
}

deploy_start_dev () {
    echo_and_do "docker-compose -f ./docker-compose-dev.yml build --no-cache"
    echo_and_do "docker-compose -f ./docker-compose-dev.yml up"
}

deploy_stop_dev () {
    echo_and_do "docker-compose -f ./docker-compose-dev.yml down"
}

if [ "$ENV" = "pro" ]; then
    if [ "$COMMAND" = "start" ]; then
        deploy_start_pro
    elif [ "$COMMAND" = "start-balance" ]; then
        deploy_start_pro_balance
    elif [ "$COMMAND" = "stop" ]; then
        deploy_stop_pro
    elif [ "$COMMAND" = "imagepush" ]; then
        deploy_imagepush_pro
    elif [ "$COMMAND" = "config" ]; then
        deploy_config_pro
    fi
elif [ "$ENV" = "dev" ]; then
    if [ "$COMMAND" = "start" ]; then
        deploy_start_dev
    elif [ "$COMMAND" = "stop" ]; then
        deploy_stop_dev
    fi   
fi