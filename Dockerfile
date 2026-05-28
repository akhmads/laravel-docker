FROM php:8.3-fpm
WORKDIR /var/www/html

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        gnupg \
        zip \
        unzip \
        git \
        pkg-config \
        libzip-dev \
        libonig-dev \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        libxml2-dev \
        libicu-dev \
        libsqlite3-dev \
        libpq-dev \
        ca-certificates \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-install \
        pdo_mysql \
        pdo_sqlite \
        pdo_pgsql \
        pgsql \
        mbstring \
        exif \
        pcntl \
        bcmath \
        gd \
        xml \
        intl \
        zip \
    && rm -rf /var/lib/apt/lists/*

COPY ./php-fpm/php.ini /usr/local/etc/php/conf.d/99-custom.ini
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY ./src/composer.json ./src/composer.lock ./src/package*.json ./src/vite.config.js ./
RUN composer install --no-dev --ignore-platform-reqs --no-scripts --no-interaction \
    && npm ci

COPY ./src ./
RUN composer dump-autoload --optimize \
    && npm run build

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 9000
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["php-fpm"]
