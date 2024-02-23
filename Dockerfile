FROM alpine:latest

RUN apk add --no-cache curl

#Update and upgrade
RUN apk update && apk upgrade && apk add --no-cache bash

# Setup apache and php
RUN apk --no-cache --update \
	add nginx \
	apache2-ssl \
	curl \
	php81-apache2 \
	php81-bcmath \
	php81-bz2 \
	php81-calendar \
	php81-common \
	php81-ctype \
	php81-curl \
	php81-dom \
	php81-gd \
	php81-iconv \
	php81-mbstring \
	php81-mysqli \
	php81-mysqlnd \
	php81-openssl \
	php81-pdo_mysql \
	php81-pdo_pgsql \
	php81-pdo_sqlite \
	php81-phar \
	php81-zip \
	php81-zlib \
	php81-fileinfo \
	php81-session \
	php81-xml

RUN apk add php81-tokenizer
#Add servername
RUN echo "ServerName localhost" >> /etc/apache2/httpd.conf

WORKDIR /app

#Remove all from htdocs
RUN rm -rf /var/www/localhost/htdocs/*

#Copy files
COPY . /var/www/localhost/htdocs/

#Set permissions
RUN chown -R apache:apache /var/www/localhost/htdocs/

RUN chmod -R 775 /var/www/localhost/htdocs/core/bootstrap/cache
RUN chmod -R 775 /var/www/localhost/htdocs/core/storage
RUN chmod -R 775 /var/www/localhost/htdocs/core/storage/app
RUN chmod -R 775 /var/www/localhost/htdocs/core/storage/framework
RUN chmod -R 775 /var/www/localhost/htdocs/core/storage/logs

#Expose port 80
EXPOSE 80

#Start apache
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]