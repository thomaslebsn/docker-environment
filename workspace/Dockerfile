FROM thomaslebsn/ubuntu-1604lts-2020:base

# Remove Faillog and Lastlog to reduce the size of the final image.
USER root
RUN rm -rf /var/log/lastlog /var/log/faillog


# Install software utils
USER root
RUN apt-get update \
    && apt-get -y --allow-unauthenticated install wget curl nano vim git unzip net-tools

# Install Memcached
USER root
RUN apt-get update \
    && apt-get -y --allow-unauthenticated install memcached \
    && apt-get -y --allow-unauthenticated install php7.4-memcached

# Install Redis Cache
USER root
RUN apt-get update \
    && apt-get -y --allow-unauthenticated install redis-server \
    && apt-get -y --allow-unauthenticated install php7.4-redis

# Install Vanish Cache
USER root
RUN apt-get update \
    && apt-get -y --allow-unauthenticated install varnish

# Install additional PHP extensions
USER root
RUN apt-get update \
    && apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y --allow-unauthenticated install php7.4-intl \
    && apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y --allow-unauthenticated install php7.4-xml \
    && apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y --allow-unauthenticated install php7.4-curl \
    && apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y --allow-unauthenticated install php7.4-mbstring \
    && apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y --allow-unauthenticated install php7.4-pdo-mysql \
    && apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y --allow-unauthenticated install php7.4-gd \
    && apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y --allow-unauthenticated install php7.4-soap


# Install Composer
USER root
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/ \
    && ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

USER root
RUN rm -f /etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/race.dev.conf

# Install NodeJS & NPM
USER root
RUN apt-get update \
    && apt-get -y --allow-unauthenticated --fix-missing install libtool \
    && apt-get -y --allow-unauthenticated --fix-missing install pkg-config \
    && apt-get -y --allow-unauthenticated --fix-missing install nasm \
    && apt-get -y --allow-unauthenticated --fix-missing install autoconf \
    && apt-get -y --allow-unauthenticated --fix-missing install nodejs \
    && apt-get -y --allow-unauthenticated --fix-missing install npm

# Upgrade NodeJS & NPM to stable versions
USER root
RUN apt-get update \
    && npm cache clean -f \
    && npm install -g n \
    && n stable \
    && npm install -g svgo \
    && npm install -g pm2

# Install NVM to manage Node version
USER root
RUN apt-get update \
    && apt-get install build-essential libss1-dev \
    && curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.35.3/install.sh | bash

# Install Yarn
USER root
RUN apt-get update \
    && apt-get install apt-transport-https

USER root
RUN curl -sS http://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get -y --allow-unauthenticated --fix-missing install yarn

USER root
RUN apt-get update \
    && apt-get -y --allow-unauthenticated --fix-missing install supervisor

USER root
RUN apt-get update \
    && apt-get -y --allow-unauthenticated --fix-missing install openssh-server


USER root
RUN apt-get update \
    && apt-get -y --allow-unauthenticated --fix-missing install jpegoptim \
    && apt-get -y --allow-unauthenticated --fix-missing install optipng \
    && apt-get -y --allow-unauthenticated --fix-missing install pngquant \
    && apt-get -y --allow-unauthenticated --fix-missing install gifsicle

USER root
RUN apt-get update \
    && apt-get -y --allow-unauthenticated --fix-missing install openssl



# Install additional PHP extensions via PECL
USER root
RUN apt-get update \
    && pecl channel-update pecl.php.net \
    && yes '' | pecl install ev \
    && yes '' | pecl install event

# Install PHP-CLI and Docker Connect to X-Debug in PHPStorm
USER root
RUN apt-get update \
    && apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y --allow-unauthenticated install php7.4-cli \
    && apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y --allow-unauthenticated install iputils-ping netcat \
    && mkdir -p /var/run/sshd

USER root
RUN apt-get update \
    && pecl channel-update pecl.php.net \
    && yes '' | pecl install xdebug

USER root
RUN apt-get update \
    && apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y --allow-unauthenticated install php-xdebug
COPY ./php-cli/conf.d/xdebug.ini /etc/php/7.4/mods-available/xdebug.ini

# Copy bash aliases to container
USER root
COPY ./aliases.sh /home/aliases.sh
RUN echo "" >> ~/.bashrc && \
    echo "# Load Custom Aliases" >> ~/.bashrc && \
    echo "source /home/aliases.sh" >> ~/.bashrc && \
    echo "source /home/docker-shells/custom.sh" >> ~/.bashrc && \
    echo "admin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
	echo "" >> ~/.bashrc && \
	sed -i 's/\r//' /home/aliases.sh && \
	sed -i 's/^#! \/bin\/sh/#! \/bin\/bash/' /home/aliases.sh
