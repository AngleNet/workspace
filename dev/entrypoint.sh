#!/usr/bin/env bash

# noisepage related
function noisepage::dev() {
  common::say "Installing dependencies for [noisepage]"
  __noisepage::install
}

function noisepage::serve() {
  common::say "Serve workspace for [noisepage]"
  common::serve
}

function __noisepage::install() {
  sudo apt-get update -y
  LINUX_PACKAGES=(
    "build-essential"
    "clang-8"
    "clang-format-8"
    "clang-tidy-8"
    "cmake"
    "doxygen"
    "libevent-dev"
    "libjemalloc-dev"
    "libpq-dev"
    "libpqxx-dev"
    "libtbb-dev"
    "libzmq3-dev"
    "lld"
    "llvm-8"
    "pkg-config"
    "postgresql-client"
    "python3-pip"
    "ninja-build"
    "wget"
    "zlib1g-dev"
    "time"
    "ant"
    "ccache"
    "curl"
    "lcov"
    "lsof"
  )
  # Packages to be installed through pip3.
  PYTHON_PACKAGES=(
    "distro"
    "lightgbm"
    "numpy"
    "pandas"
    "prettytable"
    "psutil"
    "psycopg2"
    "pyarrow"
    "pyzmq"
    "requests"
    "sklearn"
    "torch"
    "tqdm"
    "coverage"
  )
  common::say "Installing System packages"
  # shellcheck disable=SC2046
  sudo apt-get -y --no-install-recommends install $(
    IFS=$' '
    echo "${LINUX_PACKAGES[*]}"
  )
  common::say "Installing Python packages"
  for pkg in "${PYTHON_PACKAGES[@]}"; do
    python3 -m pip show "$pkg" || python3 -m pip install "$pkg"
  done
}

function common::serve() {
  common::serve_ssh
  tail -f /dev/null
}

function common::say() {
  printf '\n\033[0;44m---> %s \033[0m\n' "$1"
}

function common::serve_ssh() {
  common::say "Starting the SSH server."
  service ssh start
  service ssh status
}

function common::usage() {
  cat <<EOF
USAGE:
    entrypoint.sh [PROJECTS] [COMMAND]
PROJECTS:
    noisepage           Start workspace for noisepage project
COMMAND:
    dev                 Initiate a development workspace for the project
    serve               Run the workspace for the project
EOF
}

function main() {
  local project=""
  local command=""
  if [[ $# -eq 0 ]]; then
    common::usage
    exit 1
  fi
  while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
    noisepage)
      project="$1"
      command="$2"
      break
      ;;
    *)
      common::usage
      exit 0
      ;;
    esac
  done
  func="${project}::${command}"
  eval "$func"
}

main "$@" || exit 1
