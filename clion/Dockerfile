FROM ubuntu:20.04

# Use huawei mirror
RUN sed -i "s@http://.*archive.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list
RUN sed -i "s@http://.*security.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list

# Install Ubuntu packages.
# Please add packages in alphabetical order.
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install sudo build-essential gdb rsync vim \
    cmake lld ninja-build ccache lsof lcov ant openssh-server python3 python3-pip
RUN rm -rf /var/lib/apt/lists/*

# configure sshkey authentication and start ssh-server
COPY ssh_config /etc/ssh/ssh_config
COPY sshd_config /etc/ssh/sshd_config

# move to HOME later by user.sh
COPY pip.conf /pip.conf

COPY user.sh /usr/local/bin/user.sh
RUN chmod +x /usr/local/bin/user.sh
RUN /usr/local/bin/user.sh

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
