FROM ubuntu:18.04
#ubuntu 20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y gnupg tzdata \
    && echo "UTC" > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update \
    && apt-get install -y curl zip unzip git supervisor sqlite3 \
       nginx php7.2-fpm php7.2-cli \
       php7.2-pgsql php7.2-sqlite3 php7.2-gd \
       php7.2-curl php7.2-memcached \
       php7.2-imap php7.2-mysql php7.2-mbstring \
       php7.2-xml php7.2-zip php7.2-bcmath php7.2-soap \
       php7.2-intl php7.2-readline php7.2-xdebug \
       php-msgpack php-igbinary \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && mkdir /run/php \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && echo "daemon off;" >> /etc/nginx/nginx.conf

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
#######################################
#Wordpress stuff
RUN apt-get update
RUN apt-get install -y systemd
RUN apt-get install wget
RUN cd /tmp && wget http://wordpress.org/latest.tar.gz && tar -xvzf latest.tar.gz -C /var/www/
RUN chown www-data: /var/www/wordpress/ -R
ADD wordpress.conf /etc/nginx/conf.d/wordpress.conf
#######################################

CMD ["supervisord"]