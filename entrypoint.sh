#!/bin/bash

# Check if .env file exists
if [ ! -f "/mnt/app/backend/.env" ]; then
    cp /mnt/app/backend/.env.example /mnt/app/backend/.env
    echo ".env file copied."
else
    echo ".env file already exists, skipping copy."
fi

# Access backend project directory
cd ./mnt/app/backend/

# Start backend project
composer install
php artisan key:generate --ansi
php artisan migrate --graceful --ansi
php artisan serve --host 0.0.0.0 --port 8000 &

# Access frontend project directory
cd ../frontend
npm install -g npm@10.8.1
npm install
npx vite --host 0.0.0.0 --port 8001 &

# Start the main process
exec /sbin/init
