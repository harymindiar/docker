################################################################################
# Base image
################################################################################

FROM ubuntu:trusty

ARG DEBIAN_FRONTEND=noninteractive

RUN locale-gen en_US en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

################################################################################
# Build instructions
################################################################################

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

# Enable PHP 5.6 repo and update apt-get
RUN apt-get install -y build-essential
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt-get update

# Install packages
RUN apt-get install --no-install-recommends -y \
  nginx \
  supervisor \
  curl \
  wget \
  php5.6-dev \
  php5.6-curl \
  php5.6-fpm \
  php5.6-gd \
  php5.6-memcached \
  php5.6-mysql \
  php5.6-mcrypt \
  php5.6-sqlite \
  php5.6-mbstring \
  php5.6-dom \
  php5.6-cli \
  php5.6-json \
  php5.6-common \
  php5.6-opcache \
  php5.6-readline

# Install software
RUN apt-get install -y git
RUN apt-get install unzip
RUN apt-get install -y vim

RUN apt-get -y autoremove && apt-get clean && apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /var/run/php && touch /var/run/php/php5.6-fpm.sock

# Install app dependencies
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install redis extension
RUN cd ~; wget https://github.com/phpredis/phpredis/archive/master.zip -O phpredis.zip; unzip -o phpredis.zip; mv phpredis-* phpredis; cd phpredis; /usr/bin/phpize; ./configure; make; make install
RUN touch /etc/php/5.6/mods-available/redis.ini; echo extension=redis.so > /etc/php/5.6/mods-available/redis.ini; phpenmod redis

# Install cphalcon
RUN cd ~; git clone https://github.com/phalcon/cphalcon -b 2.1.x --single-branch; cd ~/cphalcon/build; ./install; rm -rf ~/cphalcon
RUN echo "extension=phalcon.so" >> /etc/php/5.6/mods-available/phalcon.ini; phpenmod phalcon

# Install app dependencies
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add configuration files
COPY conf/nginx.conf /etc/nginx/
COPY conf/supervisord.conf /etc/supervisor/conf.d/
COPY conf/php.ini /etc/php5/fpm/conf.d/40-custom.ini
COPY conf/www.conf /etc/php/5.6/fpm/pool.d/

# Install golang
RUN cd ~; wget https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz; tar -xvf go1.8.linux-amd64.tar.gz; mv go /usr/local
ENV PATH /usr/local/go/bin:$GOPATH/bin:$PATH
ENV GOPATH /html/go/work
ENV GOBIN $GOPATH/bin

################################################################################
# Volumes
################################################################################

VOLUME ["/var/www", "/etc/nginx/conf.d"]

################################################################################
# Ports
################################################################################

EXPOSE 80 443 9000

################################################################################
# Entrypoint
################################################################################

ENTRYPOINT ["/usr/bin/supervisord"]
