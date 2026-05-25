#!/usr/bin/env sh
set -e

wd=/var/www/html
user=www-data
group=www-data
file_perm=664
dir_perm=755
writable_perm=775

# Ensure base app directories exist
mkdir -p "$wd/storage" "$wd/bootstrap/cache"

# Set general permissions, excluding vendor/node_modules and .git if present
find "$wd" \
  -not -path '*/node_modules/*' \
  -not -path '*/.git/*' \
  -type d -exec chmod "$dir_perm" {} +
find "$wd" \
  -not -path '*/node_modules/*' \
  -not -path '*/.git/*' \
  -type f -exec chmod "$file_perm" {} +

# Writable directories for Laravel
chmod -R "$writable_perm" "$wd/storage"
chmod -R "$writable_perm" "$wd/bootstrap/cache"
chown -R "$user":"$group" "$wd/storage" "$wd/bootstrap/cache"

# Ensure the Laravel log file exists and is writable by www-data
mkdir -p "$wd/storage/logs"
touch "$wd/storage/logs/laravel.log"
chown "$user":"$group" "$wd/storage/logs/laravel.log"
chmod "$writable_perm" "$wd/storage/logs/laravel.log"

# Re-create public storage symlink if artisan is available
if [ -f "$wd/artisan" ]; then
  rm -rf "$wd/public/storage"
  php "$wd/artisan" storage:link || true
  chown -R "$user":"$group" "$wd/public/storage"
fi

exec "$@"
