#!/bin/bash

# 実行時に指定された引数の数、つまり変数 $# の値が 2 以上でなければエラー終了。
if [ $# -lt 2 ]; then
  echo "指定された引数は$#個です。" 1>&2
  echo "実行するには2個以上の引数が必要です。" 1>&2
  echo "Usage: deploy.sh {dev|pro} {start|stop}" 1>&2
  echo "   or  deploy.sh pro config" 1>&2
  exit 1
fi

ENV=$1
COMMAND=$2
ACCESS_KEY=$3
SECRET_KEY=$4

echo_and_do () {
    echo "$1"
    eval "$1"
}

deploy_start_pro () {
#    echo_and_do "ecs-cli compose -f ./docker-compose.yml up"
    echo_and_do "ecs-cli compose -f ./docker-compose.yml service up"
#    echo_and_do "ecs-cli compose -f ./docker-compose.yml scale 2"
    echo_and_do "ecs-cli ps"

}

deploy_config_pro () {
    echo_and_do "ecs-cli configure --region ap-northeast-1 --access-key $ACCESS_KEY --secret-key $SECRET_KEY --cluster mob-map"
}

deploy_stop_pro () {
    echo_and_do "ecs-cli compose -f ./docker-compose.yml down"
    echo_and_do "ecs-cli compose -f ./docker-compose.yml service rm"
}

deploy_start_dev () {
    echo_and_do "docker-compose -f ./docker-compose-dev.yml up"
}

deploy_stop_dev () {
    echo_and_do "docker-compose -f ./docker-compose-dev.yml down"
}

if [ "$ENV" = "pro" ]; then
    if [ "$COMMAND" = "start" ]; then
        deploy_start_pro
    elif [ "$COMMAND" = "stop" ]; then
        deploy_stop_pro
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