# Docker Setup for Laravel

## Overview
This document explains the Docker setup for a Laravel application with the app code located in the `src` folder.

Stack:
- Nginx
- PHP-FPM 8.3
- Composer
- Node.js 22 LTS

## Application Structure
- `src/` — main Laravel application code
- `nginx/default.conf` — Nginx configuration
- `php-fpm/php.ini` — PHP runtime configuration
- `Dockerfile` — PHP-FPM application image
- `docker-compose.yml` — `app` (PHP-FPM) and `web` (Nginx) services
- `.dockerignore` — files/folders excluded from build context

## Docker volume mapping
- `./src` is mapped to `/var/www/html`
- `./src/vendor` is mapped to `/var/www/html/vendor`
- `./src/node_modules` is mapped to `/var/www/html/node_modules`

## Running
1. Open a terminal in the project root
2. Run:

```bash
docker compose up -d --build
```

3. Open your browser to:

```text
http://localhost:8080
```

## Rebuild after configuration changes
If you change Docker configuration or build files (`Dockerfile`, `docker-compose.yml`, `php-fpm/php.ini`, `nginx/default.conf`), run:

```bash
docker compose up -d --build
```

If you only change application code in `src/`, usually this is enough:

```bash
docker compose up -d
```

## Stop and remove containers
- Stop running containers:

```bash
docker compose stop
```

- Remove stopped containers, networks, and default volumes created by Compose:

```bash
docker compose down
```

- Remove containers, networks, and volumes created by Compose (use with care):

```bash
docker compose down -v
```

- Clean up more completely, including images built by Compose and orphan containers:

```bash
docker compose down --rmi all -v --remove-orphans
```

This is the most thorough cleanup for the Compose stack. It removes:
- containers
- networks
- volumes created by Compose
- images built by Compose
- orphan containers from the same project

## Common commands

- Install PHP dependencies:

```bash
docker compose exec app composer install
```

- Run migrations / artisan:

```bash
docker compose exec app php artisan migrate
```

- Install frontend dependencies:

```bash
docker compose exec app npm install
```

- Build assets:

```bash
docker compose exec app npm run build
```

## Access container shell

```bash
docker ps

docker exec -it laravel_app bash
```

If `bash` is not available:

```bash
docker exec -it laravel_app sh
```

## Custom PHP configuration
- `php-fpm/php.ini` contains settings for `memory_limit`, `upload_max_filesize`, `post_max_size`, `max_execution_time`, and production OPCache.

## Notes
- The `app` service provides PHP-FPM.
- The `web` service provides Nginx on port `80`.
- Because volumes are mounted, local code changes are immediately visible inside the container.
- For guidance on copying this stack to a new project, see `PROJECT.md`.
