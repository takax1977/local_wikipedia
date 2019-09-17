FROM mediawiki:1.33

ARG PUID
ARG PGID
ARG USER

RUN apt-get update && apt-get install -y \
    git \
    wget \
    mariadb-client \
    parallel \
    libzip-dev \
    pv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pecl install zlib zip && \
    echo "extension=zip.so" > /usr/local/etc/php/conf.d/docker-php-ext-zip.ini && \
    wget https://getcomposer.org/composer.phar && \
    mv composer.phar /usr/local/bin/composer && \
    chmod a+x /usr/local/bin/composer && \
    composer require --quiet --no-plugins --no-scripts wikimedia/css-sanitizer && \
    addgroup --gid ${PGID} ${USER} && \
    adduser --disabled-password --no-create-home --uid ${PUID} --gid ${PGID} ${USER}
