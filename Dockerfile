FROM debian:8.7

MAINTAINER takara

WORKDIR /root

RUN apt-get -y update
RUN apt-get install -y wget apt-transport-https lsb-release ca-certificates
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update
RUN apt-get -y install net-tools git make apache2
RUN apt-get -y install vim curl chkconfig gcc libpcre3-dev unzip locales
RUN apt-get -y install mysql-server php5.6 php-pear php5.6-mysql php5.6-curl php5.6-mbstring php5.6-zip \
    php5.6-cli php5.6-common php5.6-json php5.6-opcache php5.6-readline php5.6-xml
RUN apt-get -y install imagemagick
ENV DEBIAN_FRONTEND dialog

VOLUME /var/lib/mysql
COPY asset/my.cnf /etc/mysql/

# tty停止
COPY asset/ttystop /etc/init.d/
RUN chkconfig --add ttystop
RUN chkconfig ttystop on

RUN ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# composer
RUN curl -s http://getcomposer.org/installer | php
RUN chmod +x composer.phar
RUN mv composer.phar /usr/local/bin/composer

RUN composer global require hirak/prestissimo

RUN locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LC_CTYPE ja_JP.UTF-8
RUN localedef -f UTF-8 -i ja_JP ja_JP.utf8

EXPOSE 80

CMD ["/sbin/init", "3"]

RUN apt-get -y install php5.6-xdebug
COPY asset/xdebug.ini /etc/php/5.6/mods-available/
EXPOSE 9000
EXPOSE 15000
