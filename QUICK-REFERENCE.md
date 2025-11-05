# Quick Reference Card

## 🚀 Quick Start

```bash
# Start everything
docker compose up -d

# Use interactive menu
./start.sh

# Stop everything
docker compose down
```

## 📊 Database Summary (17 Total)

| Database | Port | User | Password | Type |
|----------|------|------|----------|------|
| PostgreSQL | 5432 | postgres | postgres | SQL |
| MySQL 8 | 3308 | root | root | SQL |
| MySQL 5.7 | 3307 | root | root | SQL |
| MariaDB | 3309 | root | root | SQL |
| MS SQL Server | 1433 | sa | YourStrong@Passw0rd | SQL |
| Oracle XE | 1521 | system | oracle | SQL |
| CockroachDB | 26257 | root | - | SQL |
| NeonDB | 5434 | neon | neon | SQL |
| MongoDB | 27017 | mongo | mongo | NoSQL |
| Redis | 6379 | - | redis | NoSQL |
| Cassandra | 9042 | - | - | NoSQL |
| Neo4j | 7687 | neo4j | neo4jpassword | Graph |
| ArangoDB | 8529 | root | arango | Multi |
| ClickHouse | 9000 | clickhouse | clickhouse | Analytical |
| InfluxDB | 8086 | influx | influxpassword | Time-series |
| DuckDB | shell | - | - | Analytical |
| SQLite | shell | - | - | File-based |

## 🛠️ Management Tools (7 Total)

| Tool | URL | User | Password |
|------|-----|------|----------|
| phpMyAdmin | http://localhost:8081 | (use DB creds) | (use DB creds) |
| Adminer | http://localhost:8082 | (use DB creds) | (use DB creds) |
| pgAdmin | http://localhost:5050 | admin@admin.com | admin |
| CloudBeaver | http://localhost:8978 | (setup on first run) | - |
| DBGate | http://localhost:3001 | - | - |
| Mongo Express | http://localhost:8083 | admin | admin |
| Redis Commander | http://localhost:8084 | - | - |

## 🔧 Common Commands

### Start/Stop Services

```bash
# Start specific databases
docker compose up -d postgresql mysql8 mongodb

# Stop all
docker compose down

# Stop and remove all data (⚠️ destructive)
docker compose down -v

# Restart a service
docker compose restart postgresql
```

### View Status & Logs

```bash
# Check status
docker compose ps

# View all logs
docker compose logs -f

# View specific service logs
docker compose logs -f postgresql

# View last 100 lines
docker compose logs --tail=100 postgresql
```

### Connect to Databases

```bash
# PostgreSQL
docker exec -it pdi-postgresql psql -U postgres -d testdb

# MySQL 8
docker exec -it pdi-mysql8 mysql -uroot -proot testdb

# MongoDB
docker exec -it pdi-mongodb mongosh -u mongo -p mongo --authenticationDatabase admin

# Redis
docker exec -it pdi-redis redis-cli -a redis

# CockroachDB
docker exec -it pdi-cockroachdb ./cockroach sql --insecure

# Neo4j
docker exec -it pdi-neo4j cypher-shell -u neo4j -p neo4jpassword

# Cassandra
docker exec -it pdi-cassandra cqlsh

# ClickHouse
docker exec -it pdi-clickhouse clickhouse-client --user clickhouse --password clickhouse
```

### Backup & Restore

```bash
# Backup PostgreSQL
docker exec pdi-postgresql pg_dump -U postgres testdb > backup.sql

# Restore PostgreSQL
docker exec -i pdi-postgresql psql -U postgres testdb < backup.sql

# Backup MySQL
docker exec pdi-mysql8 mysqldump -uroot -proot testdb > backup.sql

# Restore MySQL
docker exec -i pdi-mysql8 mysql -uroot -proot testdb < backup.sql

# Export MongoDB collection
docker exec pdi-mongodb mongoexport -u mongo -p mongo --authenticationDatabase admin -d testdb -c users --out /tmp/users.json

# Backup all data (volume backup)
docker run --rm -v pdi-database-management-experimentation_postgres-data:/data -v $(pwd):/backup alpine tar czf /backup/postgres-backup.tar.gz /data
```

### Resource Management

```bash
# View resource usage
docker stats

# View disk usage
docker system df

# Clean up unused resources
docker system prune

# Remove specific volume
docker volume rm pdi-database-management-experimentation_postgres-data
```

## 🐛 Troubleshooting

### Port Already in Use
```bash
# Check what's using the port
lsof -i :5432  # Replace 5432 with your port

# Change port in docker-compose.yml
# Change "5432:5432" to "5433:5432"
```

### Container Won't Start
```bash
# Check logs
docker compose logs [service-name]

# Check if port is available
netstat -an | grep [port-number]

# Remove and recreate
docker compose down
docker compose up -d
```

### Out of Memory
```bash
# Check Docker memory limit
docker info | grep Memory

# Reduce running services
docker compose up -d postgresql mysql8  # Only start what you need

# Increase Docker memory in Docker Desktop settings
```

### Slow Performance
```bash
# Check resource usage
docker stats

# Reduce concurrent services
# Allocate more resources to Docker
# Use SSD instead of HDD
```

## 📝 Tips

1. **Start small**: Begin with 2-3 databases you need
2. **Monitor resources**: Use `docker stats` regularly
3. **Use management tools**: Easier than CLI for exploration
4. **Backup often**: Before destructive operations
5. **Read logs**: Most issues are visible in logs
6. **Check health**: Use `docker compose ps` to see health status

## 🔗 Quick Links

- Full Documentation: [README.md](README.md)
- Testing Examples: [TESTING.md](TESTING.md)
- Offline Guide: [OFFLINE.md](OFFLINE.md)
- Contributing: [CONTRIBUTING.md](CONTRIBUTING.md)

## ⚡ One-Liners

```bash
# Start only relational databases
docker compose up -d postgresql mysql8 mysql57 mariadb mssql oracle cockroachdb

# Start only NoSQL databases  
docker compose up -d mongodb redis cassandra neo4j arangodb

# Start only management tools
docker compose up -d phpmyadmin adminer pgadmin cloudbeaver dbgate

# View all running containers
docker compose ps --format table

# Follow logs from all services
docker compose logs -f --tail=10

# Remove all stopped containers and volumes
docker compose down -v && docker system prune -f
```

## 🎯 Use Cases

- **Learning**: Compare SQL vs NoSQL databases
- **Testing**: Test app against multiple databases
- **Development**: Local dev environment
- **Migration**: Test data migration scripts
- **Comparison**: Compare database features
- **Education**: Teach database concepts

---

**Print this card for quick reference! 🖨️**
