# Docker Compose Setup for Application

Author: Khid

This repository contains a Docker Compose configuration to set up a multi-container environment for MySQL, PHPMyAdmin, and an application.

## Usage

1. **Prerequisites:**
   - Ensure Docker and Docker Compose are installed on your system.

2. **Setup:**
   - Clone this repository.
   - Set environment variables `DATABASE_ROOT_PASS` and `DATABASE_NAME` in a `.env` file as per your requirements. Use `.env.example` as a template:

     ```plaintext
     DATABASE_ROOT_PASS=rootpass
     DATABASE_NAME=dbname
     ```

3. **Start Services:**
   - Navigate to the cloned directory.
   - Start the services using:

     ```bash
     docker-compose up -d
     ```

     This command starts the containers in detached mode (`-d`).

4. **Accessing Services:**
   - **PHPMyAdmin:** Access at `http://localhost:8081` with username `root` and password `${DATABASE_ROOT_PASS}`.
   - **Application:** Access at `http://localhost:8080`.

5. **Managing Services:**
   - **Stop Services:**

     ```bash
     docker-compose down
     ```

     This command stops and removes containers, networks, and volumes.

   - **Check Service Status:**

     ```bash
     docker-compose ps
     ```

     Use this command to view the status of running services.

## Services

### MySQL Database Service

- **Service Name:** database-service
- **Image:** mysql:8.4
- **Description:** Runs MySQL version 8.4 with configured environment variables.
- **Environment Variables:**
  - `MYSQL_ROOT_PASSWORD`: Set via `${DATABASE_ROOT_PASS}`.
  - `MYSQL_DATABASE`: Set via `${DATABASE_NAME}`.
  - `MYSQL_ALLOW_EMPTY_PASSWORD`: Set to `'true'`.
- **Exposed Ports:**
  - `3306:3306` (MySQL default port)
- **Network:** main-network

### PHPMyAdmin

- **Service Name:** phpmyadmin
- **Image:** phpmyadmin/phpmyadmin:latest
- **Description:** PHPMyAdmin for MySQL database management.
- **Environment Variables:**
  - `PMA_HOST`: Set to `database-service`.
  - `PMA_USER`: Set to `root`.
  - `PMA_PASSWORD`: Set via `${DATABASE_ROOT_PASS}`.
  - `PMA_ARBITRARY`: Set to `2`.
- **Exposed Ports:**
  - `8081:80` (Access PHPMyAdmin via port 8081)
- **Dependencies:** Depends on `database-service`.
- **Network:** main-network

### Application Container

- **Service Name:** application
- **Description:** Container for the main application.
- **Build Configuration:**
  - **Context:** `.` (Current directory)
  - **Dockerfile:** Dockerfile.backend
- **Exposed Ports:**
  - `8080:8000` (Application API)
  - `9090:8001` (Additional port for application)
- **Environment Variables:**
  - `DB_HOST`: Set to `database-service`.
  - `DB_DATABASE`: Set via `${DATABASE_NAME}`.
  - `DB_PASSWORD`: Set via `${DATABASE_ROOT_PASS}`.
- **Volumes:**
  - `./backend:/mnt/app/backend`: Mounts local `backend` directory into container.
  - `./frontend:/mnt/app/frontend`: Mounts local `frontend` directory into container.
- **Dependencies:** Depends on `database-service`.
- **Network:** main-network
- **Additional Settings:** Uses `privileged: true` for enhanced permissions.

## Networks

### Main Network

- **Name:** main-network
- **Description:** Docker network for communication between services.

## Extras

To access services via custom local URLs, add the following entries to your host file:

```bash
## Local - Start ##
127.0.0.1 local-development.local
## Local - End ##
```

- [http://local-development.local](http://local-development.local)

## Troubleshooting Laravel Error

If encountering an unexpected Laravel error, follow these steps:

1. **Exec into Application Container:**

   ```bash
   docker exec -it application_container_name bash
   ```

2. **Navigate to Backend Directory:**

   ```bash
   cd /mnt/app/backend/
   ```

3. **Run Artisan Migrate:**

   ```bash
   php artisan migrate
   ```
