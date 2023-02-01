FROM php:7.2-fpm-alpine

ARG BUILD_DATE
ARG VCS_REF
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_ALLOW_XDEBUG 1
ENV COMPOSER_DISABLE_XDEBUG_WARN 1
ENV TERM xterm
ENV LANG "en_US.UTF-8"
ENV LC_ALL "en_US.UTF-8"
ENV LANGUAGE "en_US.UTF-8"
ENV XDEBUG_VERSION=2.9.2

LABEL Maintainer="Varr Willis <semanticeffect@gmail.com>" \
      Description="PHP 7.2 container based on alpine with xDebug enabled & composer installed." \
      org.label-schema.name="php-7.2-alpine-xdebug" \
      org.label-schema.description="PHP 7.2 container based on alpine with xDebug enabled & composer installed." \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/varrwillis/php-alpine-xdebug.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0"

RUN apk update 
RUN apk add --no-cache $PHPIZE_DEPS 
RUN apk add --no-cache mysql-client
RUN apk add --no-cache curl
RUN apk add --no-cache openssh-client
RUN apk add --no-cache icu
RUN apk add --no-cache freetype-dev
RUN apk add --no-cache freetype
RUN apk add --no-cache libjpeg-turbo-dev
RUN apk add --no-cache libjpeg-turbo
RUN apk add --no-cache libpng-dev
RUN apk add --no-cache libpng
RUN apk add --no-cache 
RUN apk add --no-cache 
RUN apk add --no-cache 
RUN apk add --no-cache --virtual build-dependencies icu-dev libxml2-dev g++ make autoconf 
RUN apk add --no-cache nano 
RUN docker-php-source extract 
RUN pecl install xdebug-${XDEBUG_VERSION}
RUN pecl install redis 
RUN docker-php-ext-enable xdebug redis 
RUN docker-php-source delete 
RUN docker-php-ext-install pdo_mysql soap intl zip 
RUN echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini 
RUN echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini 
RUN echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini 
RUN echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini 
RUN echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini 
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer 
RUN php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --snapshot 
RUN rm -f /tmp/composer-setup.* 
RUN apk del build-dependencies 
RUN rm -rf /tmp/*

ENV PATH="~/.composer/vendor/bin:./vendor/bin:${PATH}"

COPY php.ini /usr/local/etc/php/

USER www-data

WORKDIR /var/www

