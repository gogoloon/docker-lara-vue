FROM centos:centos7
ARG CONTAINER

# アップデート＆必要パッケージのインストール
RUN rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7
RUN rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
RUN yum -y update && yum clean all
RUN yum -y install epel-release
RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN yum -y install httpd
RUN yum -y install --enablerepo=remi,remi-php74 php php-cli php-common php-devel php-fpm php-gd php-mbstring php-mysqlnd php-pdo php-pear php-pecl-apcu php-soap php-xml php-xmlrpc 
RUN yum -y install zip unzip
RUN yum -y install nodejs

# Composerのインストール
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# laravelディレクトリ作成
WORKDIR /var/www/html
RUN mkdir -p $CONTAINER/public

CMD ["/usr/sbin/httpd","-D","FOREGROUND"]




