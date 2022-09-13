#
# Dockerfile used to build CentOS 7 images for testing Ansible
#

# syntax = docker/dockerfile:1

ARG BASE_IMAGE_TAG=7.9.2009

FROM centos:${BASE_IMAGE_TAG}

ENV container=docker

RUN yum -y update; yum clean all; \
  (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
  rm -f /lib/systemd/system/multi-user.target.wants/*;\
  rm -f /etc/systemd/system/*.wants/*;\
  rm -f /lib/systemd/system/local-fs.target.wants/*; \
  rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
  rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
  rm -f /lib/systemd/system/basic.target.wants/*;\
  rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum makecache fast ; \
  yum -y install deltarpm epel-release initscripts ; \
  yum -y update ; \
  yum -y install \
      sudo \
      which \
      python-pip ; \
  yum clean all

VOLUME ["/sys/fs/cgroup"]

CMD ["/usr/lib/systemd/systemd"]
