# ==========================================
# STAGE 1: Backend Builder (Dapur untuk Composer)
# ==========================================
FROM composer:latest AS backend-builder
WORKDIR /app

COPY src/composer.json src/composer.lock ./
RUN composer install --no-dev --ignore-platform-reqs --no-scripts --no-interaction
COPY src/ ./
RUN composer dump-autoload --optimize

# ==========================================
# STAGE 2: Frontend Builder (Dapur untuk Node.js)
# ==========================================
FROM node:22-alpine AS frontend-builder
WORKDIR /app

COPY src/package*.json ./
COPY src/vite.config.js ./
COPY src/resources ./resources
COPY src/public ./public
COPY --from=backend-builder /app/vendor ./vendor

RUN npm ci
RUN npm run build

# ==========================================
# STAGE 3: Production Image (Ruang Makan / Image Final)
# ==========================================
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
COPY ./src /var/www/html
COPY --from=frontend-builder /app/public/build /var/www/html/public/build
COPY --from=backend-builder /app/vendor /var/www/html/vendor

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 9000
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["php-fpm"]
