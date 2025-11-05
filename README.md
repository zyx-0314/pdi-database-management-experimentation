# PDI Database Management Experimentation

A comprehensive dockerized environment for testing and experimenting with multiple database systems and management tools.

## 🗄️ Supported Databases

### Relational Databases
- **PostgreSQL** (Port 5432) - Modern open-source relational database
- **MySQL 8** (Port 3308) - Latest MySQL version
- **MySQL 5.7** (Port 3307) - Legacy MySQL version
- **MariaDB** (Port 3309) - MySQL fork with enhanced features
- **MS SQL Server** (Port 1433) - Microsoft's enterprise database
- **Oracle XE** (Port 1521) - Oracle Express Edition
- **CockroachDB** (Port 26257, UI: 8080) - Distributed SQL database
- **SQLite** - Lightweight file-based database

### NoSQL Databases
- **MongoDB** (Port 27017) - Document-oriented database
- **Redis** (Port 6379) - In-memory key-value store
- **Cassandra** (Port 9042) - Wide-column distributed database
- **Neo4j** (Port 7474 HTTP, 7687 Bolt) - Graph database
- **ArangoDB** (Port 8529) - Multi-model database

### Analytical Databases
- **ClickHouse** (Port 8123 HTTP, 9000 Native) - OLAP database
- **InfluxDB** (Port 8086) - Time-series database
- **DuckDB** - In-process analytical database

### Cloud-Native / Modern Databases
- **NeonDB** (Port 5434) - Serverless PostgreSQL (local instance)

**Note:** All databases run **completely offline** and do not require internet connectivity after initial docker image download.

## 🛠️ Management Tools

| Tool | Port | Description | Access |
|------|------|-------------|--------|
| **phpMyAdmin** | 8081 | MySQL/MariaDB web interface | http://localhost:8081 |
| **Adminer** | 8082 | Universal database management | http://localhost:8082 |
| **pgAdmin** | 5050 | PostgreSQL administration | http://localhost:5050 |
| **CloudBeaver** | 8978 | DBeaver web version | http://localhost:8978 |
| **DBGate** | 3001 | Universal database client | http://localhost:3001 |
| **Mongo Express** | 8083 | MongoDB web interface | http://localhost:8083 |
| **Redis Commander** | 8084 | Redis management tool | http://localhost:8084 |

## 🚀 Quick Start

### Prerequisites
- Docker (20.10+)
- Docker Compose (2.0+)
- At least 8GB RAM available
- 20GB free disk space

### Installation

1. Clone the repository:
```bash
git clone https://github.com/zyx-0314/pdi-database-management-experimentation.git
cd pdi-database-management-experimentation
```

2. (Optional) Copy and customize environment variables:
```bash
cp .env.example .env
```

3. Start all services:
```bash
docker-compose up -d
```

4. Start specific services:
```bash
# Start only PostgreSQL and pgAdmin
docker-compose up -d postgresql pgadmin

# Start only MySQL databases
docker-compose up -d mysql8 mysql57 mariadb phpmyadmin

# Start NoSQL databases
docker-compose up -d mongodb redis neo4j
```

5. Check service status:
```bash
docker-compose ps
```

6. View logs:
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f postgresql
```

## 📋 Connection Details

### PostgreSQL
```
Host: localhost
Port: 5432
Database: testdb
User: postgres
Password: postgres
```

### MySQL 8
```
Host: localhost
Port: 3308
Database: testdb
User: mysql / root
Password: mysql / root
```

### MySQL 5.7
```
Host: localhost
Port: 3307
Database: testdb
User: mysql / root
Password: mysql / root
```

### MariaDB
```
Host: localhost
Port: 3309
Database: testdb
User: mariadb / root
Password: mariadb / root
```

### MS SQL Server
```
Host: localhost
Port: 1433
User: sa
Password: YourStrong@Passw0rd
```

### Oracle XE
```
Host: localhost
Port: 1521
Service: testdb
User: system
Password: oracle
```

### CockroachDB
```
Host: localhost
Port: 26257
User: root
Database: defaultdb
UI: http://localhost:8080
```

### MongoDB
```
Host: localhost
Port: 27017
Database: testdb
User: mongo
Password: mongo
Connection String: mongodb://mongo:mongo@localhost:27017/testdb?authSource=admin
```

### Redis
```
Host: localhost
Port: 6379
Password: redis
```

### Cassandra
```
Host: localhost
Port: 9042
Datacenter: dc1
```

### Neo4j
```
HTTP: http://localhost:7474
Bolt: bolt://localhost:7687
User: neo4j
Password: neo4jpassword
```

### ArangoDB
```
URL: http://localhost:8529
User: root
Password: arango
```

### ClickHouse
```
HTTP: http://localhost:8123
Native: localhost:9000
User: clickhouse
Password: clickhouse
Database: testdb
```

### InfluxDB
```
URL: http://localhost:8086
Organization: testorg
Bucket: testbucket
Token: influxtoken123
User: influx
Password: influxpassword
```

### NeonDB
```
Host: localhost
Port: 5434
Database: neondb
User: neon
Password: neon
```

## 🎯 Usage Examples

### Testing Database Connections

#### PostgreSQL with psql
```bash
docker exec -it pdi-postgresql psql -U postgres -d testdb
```

#### MySQL 8 with mysql client
```bash
docker exec -it pdi-mysql8 mysql -uroot -proot testdb
```

#### MongoDB with mongosh
```bash
docker exec -it pdi-mongodb mongosh -u mongo -p mongo --authenticationDatabase admin
```

#### Redis with redis-cli
```bash
docker exec -it pdi-redis redis-cli -a redis
```

#### CockroachDB SQL
```bash
docker exec -it pdi-cockroachdb ./cockroach sql --insecure
```

#### Neo4j Cypher Shell
```bash
docker exec -it pdi-neo4j cypher-shell -u neo4j -p neo4jpassword
```

### Creating Test Data

#### PostgreSQL
```bash
docker exec -it pdi-postgresql psql -U postgres -d testdb -c "
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO users (name, email) VALUES ('John Doe', 'john@example.com');
"
```

#### MongoDB
```bash
docker exec -it pdi-mongodb mongosh -u mongo -p mongo --authenticationDatabase admin --eval "
db = db.getSiblingDB('testdb');
db.users.insertOne({name: 'John Doe', email: 'john@example.com', created: new Date()});
"
```

## 🧪 Testing Scenarios

This environment is perfect for:

1. **Database Comparison**: Test the same operations across different databases
2. **Migration Testing**: Simulate data migrations between different systems
3. **Performance Testing**: Compare query performance across databases
4. **Feature Exploration**: Try database-specific features
5. **Connection Pooling**: Test application connection strategies
6. **Backup/Restore**: Practice backup and restore procedures
7. **Replication**: Test replication setups (some databases)
8. **High Availability**: Experiment with HA configurations

## 🔧 Management

### Stop All Services
```bash
docker-compose down
```

### Stop and Remove Volumes (⚠️ Deletes all data)
```bash
docker-compose down -v
```

### Restart Specific Service
```bash
docker-compose restart postgresql
```

### Update Images
```bash
docker-compose pull
docker-compose up -d
```

### View Resource Usage
```bash
docker stats
```

### Access Container Shell
```bash
docker exec -it pdi-postgresql /bin/bash
```

## 📊 Health Checks

All databases include health checks. View status:
```bash
docker-compose ps
```

Healthy services show `(healthy)` in the status column.

## 🐛 Troubleshooting

### Port Already in Use
If a port is already in use, you can either:
1. Stop the conflicting service
2. Change the port in `docker-compose.yml` (left side of port mapping)

### Container Won't Start
Check logs:
```bash
docker-compose logs [service-name]
```

### Out of Memory
Reduce the number of running services or increase Docker's memory limit.

### Slow Performance
- Reduce the number of concurrent services
- Allocate more CPU/memory to Docker
- Use SSD storage for Docker volumes

### Database Connection Refused
- Wait for health checks to pass (some databases take time to initialize)
- Check if the service is running: `docker-compose ps`
- Verify firewall settings

## 📁 Project Structure

```
.
├── docker-compose.yml          # Main orchestration file
├── .env.example               # Environment variables template
├── .gitignore                # Git ignore rules
├── README.md                 # This file
```
.
├── docker-compose.yml          # Main orchestration file
├── .env.example               # Environment variables template
├── .gitignore                # Git ignore rules
├── README.md                 # This file
└── init-scripts/            # Database initialization scripts
```

## 🔒 Security Notes

**⚠️ WARNING**: This setup uses default passwords and is intended for **development and testing only**. 

**DO NOT use in production without:**
- Changing all default passwords
- Implementing proper network security
- Using secrets management
- Enabling SSL/TLS
- Configuring firewalls
- Regular security updates

## 📝 Notes

- **All databases run completely offline** - No internet connection required after downloading Docker images
- **SQLite** is available in a container but is primarily file-based. Access it via the container shell.
- **DuckDB** runs in a container for consistency but is also file-based and best used via CLI.
- **NeonDB** is simulated using PostgreSQL with similar configuration.
- **TablePlus** is a desktop application and cannot be dockerized. Use **DBGate** or **CloudBeaver** as web alternatives.
- **Beekeeper Studio** is a desktop application. Use **DBGate** as a web alternative.
- **Firebase** and **Supabase** have been omitted as they require online connectivity for proper functionality.

## 🤝 Contributing

Feel free to submit issues or pull requests to improve this testing environment.

## 📄 License

This project is open-source and available under the MIT License.

## 🔗 Useful Links

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [MongoDB Documentation](https://docs.mongodb.com/)
- [Redis Documentation](https://redis.io/documentation)

## 💡 Tips

1. Start with a few services first to understand the setup
2. Use management tools to explore database features
3. Monitor resource usage with `docker stats`
4. Back up important test data regularly
5. Use named volumes for data persistence
6. Check logs when troubleshooting issues

---

**Happy Database Experimenting! 🚀**