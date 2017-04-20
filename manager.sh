#!/bin/bash
set -e

prj_path=$(cd $(dirname $0); pwd -P)

devops_path="$prj_path/devops"

nginx_image=nginx:1.11-alpine
jupyter_image=jupyter-notebook

app_basic_name="jy"

function _ensure_dir_and_files() {
    ensure_dir "$app_storage_path"
    ensure_dir "$app_log_path"
}

function _init_field() {
    . $devops_path/base/config.sh

    app="$developer_name-$app_basic_name"

    nginx_container="$app-nginx"
    jupyter_container="$app-jupyter"

    app_storage_path="/opt/data/$app"
    app_log_path="$app_storage_path/logs"
    notebook_conf=$devops_path/jupyter/jupyter_notebook_config.py
}

function _load_config() {
    local unready=true
    local dev_path=$devops_path/.developer
    
    if [ -f "$dev_path" ]; then
        . $dev_path 

        if [ -n $developer_name ]; then
            _init_field

            if [ -d "$app_storage_path" ]; then
                unready=false
            fi
        fi
    fi

    if $unready; then
        echo 'Please sh manager.sh init developer_name first'
        exit 1
    fi
}

function init() {
    if [ $# -lt 2 ]; then
        echo 'Please invoke sh manager.sh init developer_name'
        exit 1
    fi
    developer_name=$2

    run_cmd "echo developer_name=$developer_name > $devops_path/.developer"

    _init_field
    _ensure_dir_and_files
}

# init  
. $devops_path/base/base.sh
# action

function build_jupyter_image() {
    build_image "$jupyter_image" "$devops_path/docker/jupyter"
}

function build() {
    build_jupyter_image
}

function restart_jupyter() {
    restart_container "$jupyter_container"
}

function stop_jupyter() {
    stop_container "$jupyter_container"
}
function _read_passwd() {
    while [ -z "$password" ]
    do
        read -p "Please enter your notebook password : " password
    done
}

function run_jupyter() {
    _read_passwd

    local container_root="/notebooks"

    local args="-d --restart always"
    args="$args -e NOTEBOOK_PASSWORD=$password"
    args="$args -v ~/notebooks:$container_root"
    args="$args -v $notebook_conf:/root/.jupyter/jupyter_notebook_config.py"
    args="$args -w $container_root"
    args="$args --name $jupyter_container"

    run_cmd "docker run $docker_run_fg_mode $args $jupyter_image"
}

function to_jupyter() {
    to_container "$jupyter_container"
}

function log_jupyter() {
    log_container "$jupyter_container"
}

function run_nginx() {
    local args="-d --restart=always"
    args="$args -p $http_port:80"
    args="$args -v $devops_path/nginx-data:/etc/nginx"
    args="$args -v $app_log_path:/var/log/nginx"
    args="$args --link $jupyter_container:jupyter"
    args="$args --name $nginx_container"

    run_cmd "docker run $docker_run_fg_mode $args $nginx_image"
}

function stop_nginx() {
    stop_container "$nginx_container"
}

function restart_nginx() {
    restart_container "$nginx_container"
}

function to_nginx() {
    to_container "$nginx_container"
}

function run() {
    run_jupyter
    run_nginx
}

function stop() {
    stop_jupyter
    stop_nginx
}

function restart() {
    restart_jupyter
    restart_nginx
}

function log_nginx() {
     log_container "$nginx_container"
}

function clean() {
    stop
    run_cmd "docker run --rm $docker_run_fg_mode -v /opt/data:/opt/data $nginx_image rm -rf $app_storage_path"
}

function help() {
    cat <<-EOF

    Usage: sh manager.sh [options]
    
        Valid options are:
            help        show this message 

            build       build jupyter image 
            init        init enviroment
            run         run docker 
            stop        stop docker
            restart     restrt docker
            clean       clean enviroment

            to_jupyter
            to_nginx

            log_jupyter
            log_nginx
            
EOF
}

ALL_COMMANDS="help"
ALL_COMMANDS="$ALL_COMMANDS build init run stop restart clean"
ALL_COMMANDS="$ALL_COMMANDS to_jupyter to_nginx log_jupyter log_nginx"

action=${1:-help}
list_contains ALL_COMMANDS "$action" || action=help

if [ $action != 'init' ]; then
    _load_config
fi

$action "$@"
