#!/usr/bin/env bash

function common::say() {
  printf '\n\033[0;44m---> %s \033[0m\n' "$1"
}

function setup() {
  local force_build="$1"
  local compose_opts="--detach"
  common::say "Setup dev containers"
  if [ "$force_build" == "true" ]; then
    compose_opts="$compose_opts --build"
  fi
  docker-compose up $compose_opts
  docker-compose logs -f
  common::say "Setup SSH client"
  sshpass -p "passward" ssh-copy-id -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null master@localhost -p 2222
}

function stop() {
  common::say "Stop dev containers"
  docker-compose stop
}

function start() {
  common::say "Start dev containers"
  docker-compose start
}

function status() {
    docker-compose ps
}

function teardown() {
  common::say "Shutdown dev containers"
  docker-compose down
}

function usage() {
  cat <<EOF
USAGE:
    setup.sh [options] [command]
OPTIONS:
    -b, --build   Force rebuild of the docker image
COMMANDS:
    setup         Setup development workspace
    start         Resume a suspended workspace
    stop          Suspend a workspace
    teardown      Teardown everything
EOF
}

function main() {
  local force_build=false
  if [[ $# -eq 0 ]]; then
    usage
    exit 1
  fi
  while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
    -h | --help)
      usage
      exit 0
      ;;
    -b | --build)
      force_build=true
      shift
      ;;
    setup)
      setup "$force_build"
      exit 0
      ;;
    start)
      start
      exit 0
      ;;
    status)
      status
      exit 0
      ;;
    stop)
      stop
      exit 0
      ;;
    teardown)
      teardown
      exit 0
      ;;
    *)
      usage
      exit 1
      ;;
    esac
  done
}

main "$@"
