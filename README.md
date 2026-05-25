# Docker Setup for Laravel

## Overview
Dokumentasi ini menjelaskan setup Docker untuk aplikasi Laravel dengan kode aplikasi di folder `src`.

Stack:
- Nginx
- PHP-FPM 8.3
- Composer
- Node.js 22 LTS

## Struktur aplikasi
- `src/` — kode Laravel aplikasi utama
- `nginx/default.conf` — konfigurasi Nginx
- `php-fpm/php.ini` — konfigurasi runtime PHP
- `Dockerfile` — image PHP-FPM untuk aplikasi
- `docker-compose.yml` — service `app` (PHP-FPM) dan `web` (Nginx)
- `.dockerignore` — file/folder yang diabaikan pada build context

## Docker volume mapping
- `./src` dipetakan ke `/var/www/html`
- `./src/vendor` dipetakan ke `/var/www/html/vendor`
- `./src/node_modules` dipetakan ke `/var/www/html/node_modules`

## Menjalankan
1. Buka terminal di folder `www`
2. Jalankan:

```bash
docker compose up -d --build
```

3. Buka browser ke:

```text
http://localhost:8080
```

## Rebuild setelah perubahan konfigurasi
Jika kamu mengubah konfigurasi Docker atau file build (`Dockerfile`, `docker-compose.yml`, `php-fpm/php.ini`, `nginx/default.conf`), jalankan:

```bash
docker compose up -d --build
```

Jika hanya mengubah kode aplikasi di `src/`, biasanya cukup:

```bash
docker compose up -d
```

## Perintah umum

- Install dependencies PHP:

```bash
docker compose exec app composer install
```

- Jalankan migrasi / artisan:

```bash
docker compose exec app php artisan migrate
```

- Install dependency frontend:

```bash
docker compose exec app npm install
```

- Build assets:

```bash
docker compose exec app npm run build
```

## Akses shell container

```bash
docker ps

docker exec -it laravel_app bash
```

Jika `bash` tidak tersedia:

```bash
docker exec -it laravel_app sh
```

## Konfigurasi kustom PHP
- `php-fpm/php.ini` berisi pengaturan `memory_limit`, `upload_max_filesize`, `post_max_size`, `max_execution_time`, dan OPCache production.

## Notes
- Service `app` menyediakan PHP-FPM.
- Service `web` menyediakan Nginx pada `80`.
- Karena volume terpasang, kode lokal akan langsung terlihat di container.
- Untuk panduan copy stack ini ke project baru, lihat `PROJECT.md`.
