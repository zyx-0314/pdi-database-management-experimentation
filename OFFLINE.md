# Offline Operation Guide

This environment is designed to run **completely offline** without requiring an internet connection.

## Initial Setup (Requires Internet)

The only time you need an internet connection is when you first download the Docker images:

```bash
# Pull all images (one-time operation)
docker compose pull
```

This will download all the database and management tool images to your local machine.

## Running Offline

After the images are downloaded, you can run the entire environment without an internet connection:

```bash
# Start all services (no internet needed)
docker compose up -d
```

All databases and management tools will work fully offline because:
- All Docker images are stored locally
- All data is stored in local Docker volumes
- No external API calls are required
- No cloud services are used

## Databases Included

All 17 databases run completely locally:

### Relational Databases (8)
1. PostgreSQL
2. MySQL 8
3. MySQL 5.7
4. MariaDB
5. MS SQL Server
6. Oracle XE
7. CockroachDB
8. SQLite

### NoSQL Databases (5)
1. MongoDB
2. Redis
3. Cassandra
4. Neo4j
5. ArangoDB

### Analytical Databases (3)
1. ClickHouse
2. InfluxDB
3. DuckDB

### Cloud-Native (1)
1. NeonDB (local PostgreSQL instance)

## Management Tools (7)

All web-based management tools also run locally:

1. phpMyAdmin - http://localhost:8081
2. Adminer - http://localhost:8082
3. pgAdmin - http://localhost:5050
4. CloudBeaver - http://localhost:8978
5. DBGate - http://localhost:3001
6. Mongo Express - http://localhost:8083
7. Redis Commander - http://localhost:8084

## Excluded Services

The following services were excluded because they require online connectivity:

- **Firebase** - Requires connection to Google Firebase services
- **Supabase** - Cloud-based service with complex local setup

## Disk Space Requirements

Ensure you have enough disk space for Docker images and volumes:

- Docker images: ~10-15 GB
- Data volumes: Varies based on usage (recommend 5-10 GB free)

## Pre-downloading Images for Offline Use

If you're preparing a machine that will be used offline:

1. **On a machine with internet:**
```bash
# Pull all images
docker compose pull

# Save images to tar files
docker save $(docker compose config | grep 'image:' | awk '{print $2}') -o database-images.tar

# Transfer database-images.tar to offline machine
```

2. **On the offline machine:**
```bash
# Load images
docker load -i database-images.tar

# Start services
docker compose up -d
```

## Troubleshooting Offline Issues

### "Failed to pull image"
- This means the image is not available locally
- Download the image on a connected machine first
- Transfer it using `docker save` and `docker load`

### "Cannot resolve host"
- This is normal when offline
- As long as images are local, services will start fine
- Ignore DNS-related warnings in logs

### Update Check Failures
- Some tools may try to check for updates
- This is harmless and won't affect functionality
- Services will timeout and continue working offline

## Data Persistence

All data is stored in Docker volumes and persists across restarts:

```bash
# View volumes
docker volume ls

# Backup a specific database
docker run --rm -v pdi-database-management-experimentation_postgres-data:/data -v $(pwd):/backup alpine tar czf /backup/postgres-backup.tar.gz /data

# Restore from backup
docker run --rm -v pdi-database-management-experimentation_postgres-data:/data -v $(pwd):/backup alpine tar xzf /backup/postgres-backup.tar.gz -C /
```

## Network Requirements

The only network used is the internal Docker bridge network (`db-network`). No external network access is required or used during operation.

## Conclusion

This setup provides a fully functional, multi-database testing environment that works completely offline once the initial images are downloaded. Perfect for:

- Air-gapped environments
- Traveling without internet
- Restricted network environments
- Educational settings with limited connectivity
- Development in areas with poor internet

---

**Happy Offline Database Testing! 🔌❌➡️✅**
