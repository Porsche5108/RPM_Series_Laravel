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
		    php71w-mysqlnd \
		    redis \
                    nginx1w 


### 004. Configure Vim ###
echo -e "set nu \nset autoindent\nsyntax on" > ~/.vimrc && \
sudo cp ~/.vimrc /root

### 005. Local Environment Config ###

read -p "Local Environment?(Y/N) " ans;
if [ "$ans" == "Y" -o "$ans" == "y" ]; then
# ------ (1) file share server config ------ #
    sudo yum -y install samba samba-client samba-common cifs-utils

# ------ (2) online test env config ------ #
wget https://cli-assets.heroku.com/heroku-cli/channels/stable/heroku-cli-linux-x64.tar.gz -O heroku.tar.gz && \
tar -xvzf heroku.tar.gz && \
sudo mv heroku-cli-v*-linux-x64 /usr/local/lib/heroku && \
sudo ln -s /usr/local/lib/heroku/bin/heroku /usr/local/bin/heroku

# ------- (3) front end workflow config ------ #
su - root -c 'echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' && \
su - root -c 'echo 1 > /proc/sys/net/ipv6/conf/default/disable_ipv6' && \
sudo wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo && \
curl --silent --location https://rpm.nodesource.com/setup_6.x | sudo bash - && \
sudo yum install yarn && \
su - root -c 'echo 0 > /proc/sys/net/ipv6/conf/default/disable_ipv6' && \
su - root -c 'echo 0 > /proc/sys/net/ipv6/conf/all/disable_ipv6' && \
sudo systemctl restart network && \
echo -e '\n\n\n--------Finish Yarn Install---------\n\n\n'

# ------ (4) composer repository config ------ #
composer config -g repo.packagist composer https://packagist.laravel-china.org

fi

