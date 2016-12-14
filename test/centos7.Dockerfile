FROM centos:7

RUN yum -y install epel-release && \
    yum -y install https://repo.saltstack.com/yum/redhat/salt-repo-2016.3-1.el7.noarch.rpm && \
    yum -y install https://download.postgresql.org/pub/repos/yum/9.4/redhat/rhel-7-x86_64/pgdg-redhat94-9.4-2.noarch.rpm && \
    yum clean expire-cache && \
    yum -y install salt-minion python-pygit2 git net-tools libgit2-devel


RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done) && \
    rm -f /lib/systemd/system/multi-user.target.wants/* && \
    rm -f /etc/systemd/system/*.wants/* && \
    rm -f /lib/systemd/system/local-fs.target.wants/* && \
    rm -f /lib/systemd/system/sockets.target.wants/*udev* && \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl* && \
    rm -f /lib/systemd/system/basic.target.wants/* && \
    rm -f /lib/systemd/system/anaconda.target.wants/*

ENV LANG en_US.UTF-8
ENV SHELL /bin/bash
CMD ["/usr/sbin/init"]
