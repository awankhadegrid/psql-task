# PostgreSQL Docker Setup

This project sets up a PostgreSQL database using Docker and automatically initializes the database using SQL scripts.

---

## 🚀 Overview

This setup uses **Docker Compose** to:

- Run a PostgreSQL container
- Create a database automatically
- Execute SQL scripts on first startup
- Persist database data using Docker volumes

---

## 📁 Project Structure


.
├── docker-compose.yml
├── init/
│ ├── 1-schema.sql
│ └── 2-schema.sql


---

## ⚙️ How It Works

### 1. PostgreSQL Container

- Uses `postgres:16` image
- Runs on port **5433** (mapped to container port 5432)
- Database credentials:
  - Database: `sqltask_db`
  - User: `postgres`
  - Password: `postgres`

---

### 2. Initialization Scripts

- All `.sql` files inside the `init/` folder are automatically executed
- Location used by PostgreSQL: `/docker-entrypoint-initdb.d`

### 🔁 Execution Behavior

- Scripts run **only once** when the container is created for the first time
- Files are executed in **alphabetical order**
  - `1-schema.sql` runs first
  - `2-schema.sql` runs next

---

### 3. Volume Usage

- `pgdatasqltask` → stores database data permanently
- Even if the container stops, data is preserved

---

## ▶️ How to Run

### Start the container

```bash
docker-compose up
Run in background
docker-compose up -d
Stop the container
docker-compose down
Reset and re-run scripts
docker-compose down -v
docker-compose up
🔌 How to Connect to Database
CLI
psql -h localhost -p 5433 -U postgres -d sqltask_db
