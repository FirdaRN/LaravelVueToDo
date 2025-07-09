# ----------------------------------------
# Laravel + Vue Dockerfile for Railway (PHP 7.4)
# ----------------------------------------

# Stage 1: Build frontend assets
FROM node:20-alpine as nodebuild

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Stage 2: Laravel backend (PHP 7.4)
FROM php:7.4-fpm-alpine

# Install system dependencies
RUN apk add --no-cache \
    bash \
    zip \
    unzip \
    curl \
    libpng \
    libpng-dev \
    oniguruma-dev \
    libxml2-dev \
    icu-dev \
    shadow \
    libzip-dev \
    postgresql-dev \
    mysql-client \
    git \
    nodejs \
    npm \
    mariadb-dev \
    && docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl intl


# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www

# Copy Laravel source code
COPY . .

# Copy built assets from Node stage
COPY --from=nodebuild /app/public /var/www/public

# Set permissions
RUN addgroup -g 1000 www && adduser -u 1000 -G www -s /bin/sh -D www \
    && chown -R www:www /var/www

# Install Laravel dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Laravel clear commands
RUN php artisan config:clear && php artisan route:clear && php artisan view:clear

USER www

# ENV Settings
ENV LOG_CHANNEL=stack
ENV APP_ENV=production
ENV APP_DEBUG=false

# Start Laravel server
CMD php artisan serve --host=0.0.0.0 --port=${PORT:-8000}
