#!/bin/bash
# File Name: centos_laravel_env.sh
# Author: Kylin
# Last Changed: 2018.02.13 20:48 CTS


### 001. Change repo to ALiYun and Update Current Kernel ###
test ! "$LAST_UPDATE" == "" && \
sudo mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup && \
sudo yum -y install wget && \
su - root -c 'wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo' && \
sudo yum -y update && \
update_time=`date` && \
echo "LAST_UPDATE="$update_time"" >> ~/.bash_profile && \
source ~/.bash_profile && \
sudo shutdown -r +0

### 002. Download MySQL repo ###
test ! -e mysql57-community-release-el7-11.noarch.rpm && \
wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm

### 003. Install Nginx, PHP 7.1, MySQL 5.7, Redis, Composer... ###
sudo yum -y localinstall mysql57-community-release-el7-11.noarch.rpm && \
sudo rpm --import mysql_pubkey.asc && \
sudo yum -y install epel-release && \
sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm && \
sudo yum repolist && \
sudo yum -y install mysql-community-server \
                    mysql-community-devel \
                    php71w \
                    php71w-fpm \
                    php71w-common \
                    php71w-gd \
                    php71w-phar \
                    php71w-xml \
                    php71w-cli \
                    php71w-mbstring \
                    php71w-tokenizer \
                    php71w-openssl \
                    php71w-pdo \
                    redis \
                    nginx1w 

### 004. Local Environment Config ###
read -p "Local Environment?(Y/N) " ans;
if [ "$ans" == "Y" -o "$ans" == "y" ]; then
    sudo yum -y install samba samba-client samba-common cifs-utils
fi

### 005. Configure Vim ###
echo -e "set nu \nset autoindent\nsyntax on" > ~/.vimrc && \
sudo cp ~/.vimrc /root
