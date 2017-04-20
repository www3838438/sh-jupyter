#!/bin/bash

# define docker_run_fg_mode 
# defined devops_path developer_name

NC='\033[0m'      # Normal Color
RED='\033[0;31m'  # Error Color
CYAN='\033[0;36m' # Info Color

# CONFIG_SERVER
# DOCKER_DOMAIN
# devops_prj_path

. $devops_path/base/string.sh

if [ -t 1 ] ; then 
    docker_run_fg_mode='-it'
else 
    docker_run_fg_mode='-i'
fi

function run_cmd() {
    local t=`date`
    echo "$t: $1"
    eval $1
}

function ensure_dir() {
    if [ ! -d $1 ]; then
        run_cmd "mkdir -p $1"
    fi
}

function container_is_running() {
    local container_name=$1
    local num=$(docker ps -a -f name="^/$container_name$" -q | wc -l)
    if [ "$num" == "1" ]; then
        local ret=$(docker inspect -f {{.State.Running}} $1)
        echo $ret
    else
        echo 'false'
    fi
}

function stop_container() {
    local container_name=$1
    local cmd="docker ps -a -f name='^/$container_name$' | grep '$container_name' | awk '{print \$1}' | xargs -I {} docker rm -f --volumes {}"
    run_cmd "$cmd"
}

function restart_container() {
    local container="$1"

    run_cmd "docker restart $container"
}

function build_image() {
    local image="$1"
    local dockerfile="$2"

    run_cmd "docker build -t $image $dockerfile"
}

function to_container() {
    local container="$1"

    run_cmd "docker exec $docker_run_fg_mode $container sh"
}

function log_container() {
    local container="$1"

    run_cmd "docker logs -f $container"
}

function push_image() {
    local image_name=$1
    local url=$developer_name/$image_name
    run_cmd "docker push $url"
}

function pull_image() {
    local image_name=$1
    local url=$developer_name/$image_name
    run_cmd "docker pull $url"
}

function docker0_ip() {
    local host_ip=$(ip addr show docker0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | awk '{print $1}' | head  -1)
    echo $host_ip
}

function list_contains() {
    local var="$1"
    local str="$2"
    local val

    eval "val=\" \${$var} \""
    [ "${val%% $str *}" != "$val" ]
}
