################################################################################
# Base image
################################################################################

FROM nginx

################################################################################
# Build instructions
################################################################################

# Remove default nginx configs.
RUN rm -f /etc/nginx/conf.d/*

# Install packages
RUN apt-get update && apt-get install -my \
  supervisor \
  curl \
  wget \
  php5-dev \
  php5-curl \
  php5-fpm \
  php5-gd \
  php5-memcached \
  php5-mysql \
  php5-mcrypt \
  php5-sqlite \
  php5-xdebug \
  php-apc


# Install software
RUN apt-get install -y git
RUN apt-get install unzip

# Ensure that PHP5 FPM is run as root.
RUN sed -i "s/user = www-data/user = root/" /etc/php5/fpm/pool.d/www.conf
RUN sed -i "s/group = www-data/group = root/" /etc/php5/fpm/pool.d/www.conf

# Pass all docker environment
RUN sed -i '/^;clear_env = no/s/^;//' /etc/php5/fpm/pool.d/www.conf

# Get access to FPM-ping page /ping
RUN sed -i '/^;ping\.path/s/^;//' /etc/php5/fpm/pool.d/www.conf
# Get access to FPM_Status page /status
RUN sed -i '/^;pm\.status_path/s/^;//' /etc/php5/fpm/pool.d/www.conf

# Prevent PHP Warning: 'xdebug' already loaded.
# XDebug loaded with the core
RUN sed -i '/.*xdebug.so$/s/^/;/' /etc/php5/mods-available/xdebug.ini

# Install cphalcon
RUN cd ~; git clone https://github.com/phalcon/cphalcon -b 2.1.x --single-branch; cd ~/cphalcon/build; ./install; rm -rf ~/cphalcon
RUN echo "extension=phalcon.so" >> /etc/php5/mods-available/phalcon.ini; php5enmod phalcon

# Install app dependencies
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install redis extension
RUN cd ~; wget https://github.com/phpredis/phpredis/archive/master.zip -O phpredis.zip; unzip -o phpredis.zip; mv phpredis-* phpredis; cd phpredis; /usr/bin/phpize; ./configure; make; make install
RUN touch /etc/php5/fpm/conf.d/redis.ini; echo extension=redis.so > /etc/php5/fpm/conf.d/redis.ini
RUN touch /etc/php5/cli/conf.d/redis.ini; echo extension=redis.so > /etc/php5/cli/conf.d/redis.ini

# Add configuration files
COPY conf/nginx.conf /etc/nginx/
COPY conf/supervisord.conf /etc/supervisor/conf.d/
COPY conf/php.ini /etc/php5/fpm/conf.d/40-custom.ini

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
