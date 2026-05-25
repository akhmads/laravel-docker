# Project Template Guide

## Overview
`PROJECT.md` adalah panduan ketika kamu ingin membuat project baru dengan menyalin konfigurasi Docker dari repository ini.

Ini bukan hanya dokumentasi setup. Dokumen ini fokus pada:
- bagian mana yang harus diubah untuk project baru
- nama project / service / container yang harus disesuaikan
- port dan environment untuk database/cache
- file yang perlu diperiksa selain Docker config

## Stack yang dipakai
- Nginx
- PHP-FPM 8.3
- Composer
- Node.js 22 LTS

## Struktur aplikasi saat ini
- `src/` — kode Laravel aplikasi utama
- `nginx/default.conf` — konfigurasi Nginx
- `php-fpm/php.ini` — konfigurasi runtime PHP
- `Dockerfile` — image PHP-FPM untuk aplikasi
- `docker-compose.yml` — service `app` (PHP-FPM) dan `web` (Nginx)
- `.dockerignore` — file/folder yang diabaikan pada build context

## Bagian yang harus diubah untuk project baru
Ketika membuat project baru dari template ini, ganti nilai spesifik project lama dengan nilai baru.

### 1. Folder aplikasi
- Folder `src/` sudah fixed untuk template ini.
- Jika kamu ingin menggunakan nama folder lain, ganti semua referensi:
  - `Dockerfile`: `COPY ./src /var/www/html`
  - `docker-compose.yml`:
    - `./src:/var/www/html:delegated`
    - `./src/vendor:/var/www/html/vendor`
    - `./src/node_modules:/var/www/html/node_modules`
    - `./src:/var/www/html:ro,delegated`
  - `PROJECT.md` / `DOCKER.md`: semua teks `src`

### 2. Nama service / container / image
- `docker-compose.yml`:
  - `image: laravel_app`
  - `container_name: laravel_app`
  - `container_name: laravel_nginx`
- Jika ingin nama yang lebih spesifik, ganti juga:
  - `app:` → misal `backend:` atau `php-fpm:`
  - `web:` → misal `nginx:` atau `frontend:`
- Jangan lupa sesuaikan perintah di dokumentasi:
  - `docker compose exec app ...`
  - `docker exec -it laravel_app ...`

### 3. Port / URL
- `docker-compose.yml`: `8080:80`
- `PROJECT.md` / `DOCKER.md`: `http://localhost:8080`
- Jika kamu butuh port lain, ganti keduanya.

### 4. Dokumentasi dan path
- `PROJECT.md` dan `DOCKER.md` harus disesuaikan dengan nama project baru.
- Periksa referensi:
  - `src`
  - `laravel_app`
  - `laravel_nginx`
  - `8080`

### 5. Metadata project dalam `src`
- `src/composer.json`: `name`, `description`, `authors`
- `src/package.json`: `name`, `description`
- `src/README.md`
- `src/.env.example` atau `.env`
- Jika kamu menggunakan SQLite, pastikan `database/database.sqlite` atau `DB_DATABASE` sesuai.

### 6. File Docker lain yang perlu diperiksa
- `Dockerfile`
- `docker-compose.yml`
- `php-fpm/php.ini`
- `nginx/default.conf`
- `.dockerignore`

### 7. Rebuild setelah perubahan konfigurasi
Jika kamu mengubah konfigurasi Docker atau file build, jalankan:

```bash
docker compose up -d --build
```

Jika hanya mengubah kode aplikasi di `src/`, biasanya cukup:

```bash
docker compose up -d
```

## Koneksi MySQL / PostgreSQL / Redis untuk project baru
Jika project baru butuh database atau cache, tambahkan service di `docker-compose.yml` dan sesuaikan `src/.env`.

### MySQL
- Tambahkan service `mysql` atau `db` di `docker-compose.yml`.
- Set environment:
  - `MYSQL_ROOT_PASSWORD`
  - `MYSQL_DATABASE`
  - `MYSQL_USER`
  - `MYSQL_PASSWORD`
- Di `src/.env`:
  - `DB_CONNECTION=mysql`
  - `DB_HOST=mysql`
  - `DB_PORT=3306`
  - `DB_DATABASE=...`
  - `DB_USERNAME=...`
  - `DB_PASSWORD=...`

### PostgreSQL
- Tambahkan service `postgres` di `docker-compose.yml`.
- Set environment:
  - `POSTGRES_DB`
  - `POSTGRES_USER`
  - `POSTGRES_PASSWORD`
- Di `src/.env`:
  - `DB_CONNECTION=pgsql`
  - `DB_HOST=postgres`
  - `DB_PORT=5432`
  - `DB_DATABASE=...`
  - `DB_USERNAME=...`
  - `DB_PASSWORD=...`

### Redis
- Tambahkan service `redis` di `docker-compose.yml`.
- Di `src/.env`:
  - `CACHE_DRIVER=redis`
  - `REDIS_HOST=redis`
  - `REDIS_PASSWORD=null`
  - `REDIS_PORT=6379`

> Untuk production, pisahkan data service dari kode dengan volume dan gunakan password kuat.
