# Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                   PDI Database Management Experimentation                    │
│                         Docker Compose Environment                           │
└─────────────────────────────────────────────────────────────────────────────┘

                              ┌──────────────┐
                              │  User / CLI  │
                              └──────┬───────┘
                                     │
                ┌────────────────────┼────────────────────┐
                │                    │                    │
         ┌──────▼──────┐      ┌─────▼─────┐      ┌──────▼──────┐
         │  start.sh   │      │  docker   │      │   Web UI    │
         │  (Menu)     │      │  compose  │      │  (Browser)  │
         └─────────────┘      └───────────┘      └─────────────┘
                                     │
                    ┌────────────────┴────────────────┐
                    │    Docker Network (db-network)  │
                    └────────────────┬────────────────┘
                                     │
        ┌────────────────────────────┼────────────────────────────┐
        │                            │                            │
   ┌────▼─────┐               ┌─────▼──────┐             ┌──────▼──────┐
   │RELATIONAL│               │   NoSQL    │             │ ANALYTICAL  │
   │DATABASES │               │ DATABASES  │             │  DATABASES  │
   └────┬─────┘               └─────┬──────┘             └──────┬──────┘
        │                            │                            │
        │                            │                            │
┌───────┴────────┐          ┌────────┴─────────┐        ┌────────┴────────┐
│                │          │                  │        │                 │
│ PostgreSQL     │          │ MongoDB          │        │ ClickHouse      │
│   :5432        │          │   :27017         │        │   :8123/:9000   │
│                │          │                  │        │                 │
│ MySQL 8        │          │ Redis            │        │ InfluxDB        │
│   :3308        │          │   :6379          │        │   :8086         │
│                │          │                  │        │                 │
│ MySQL 5.7      │          │ Cassandra        │        │ DuckDB          │
│   :3307        │          │   :9042          │        │   (shell)       │
│                │          │                  │        │                 │
│ MariaDB        │          │ Neo4j (Graph)    │        └─────────────────┘
│   :3309        │          │   :7474/:7687    │
│                │          │                  │
│ MS SQL Server  │          │ ArangoDB (Multi) │
│   :1433        │          │   :8529          │
│                │          │                  │
│ Oracle XE      │          └──────────────────┘
│   :1521        │
│                │
│ CockroachDB    │
│   :26257/:8080 │
│                │
│ SQLite         │
│   (file-based) │
│                │
│ NeonDB         │
│   :5434        │
│                │
└────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│                      MANAGEMENT TOOLS (Web-Based)                       │
└─────────────────────────────────────────────────────────────────────────┘
        │
        ├── phpMyAdmin        → http://localhost:8081  (MySQL/MariaDB)
        ├── Adminer           → http://localhost:8082  (Universal)
        ├── pgAdmin           → http://localhost:5050  (PostgreSQL)
        ├── CloudBeaver       → http://localhost:8978  (Universal DBeaver)
        ├── DBGate            → http://localhost:3001  (Universal)
        ├── Mongo Express     → http://localhost:8083  (MongoDB)
        └── Redis Commander   → http://localhost:8084  (Redis)

┌─────────────────────────────────────────────────────────────────────────┐
│                          DATA PERSISTENCE                               │
└─────────────────────────────────────────────────────────────────────────┘
        │
        ├── Docker Volumes (Named)
        │   ├── postgres-data
        │   ├── mysql8-data
        │   ├── mysql57-data
        │   ├── mariadb-data
        │   ├── mssql-data
        │   ├── oracle-data
        │   ├── sqlite-data
        │   ├── cockroach-data
        │   ├── mongodb-data
        │   ├── redis-data
        │   ├── cassandra-data
        │   ├── neo4j-data
        │   ├── arangodb-data
        │   ├── clickhouse-data
        │   ├── influxdb-data
        │   ├── duckdb-data
        │   ├── neon-data
        │   ├── pgadmin-data
        │   ├── cloudbeaver-data
        │   └── dbgate-data
        │
        └── Initialization Scripts
            ├── postgres-init.sql
            ├── mysql-init.sql
            └── mongo-init.js

┌─────────────────────────────────────────────────────────────────────────┐
│                        STATISTICS & DETAILS                             │
└─────────────────────────────────────────────────────────────────────────┘

Total Services:       24
├── Databases:        17
│   ├── Relational:    8  (PostgreSQL, MySQL 8, MySQL 5.7, MariaDB, 
│   │                      MS SQL, Oracle, CockroachDB, SQLite)
│   ├── NoSQL:         5  (MongoDB, Redis, Cassandra, Neo4j, ArangoDB)
│   ├── Analytical:    3  (ClickHouse, InfluxDB, DuckDB)
│   └── Cloud-Native:  1  (NeonDB)
└── Management Tools: 7

Network Mode:         Bridge (isolated internal network)
Offline Capable:      Yes (after initial image download)
Health Checks:        Enabled for all services
Data Persistence:     Docker volumes
Resource Usage:       ~8-16GB RAM recommended
Disk Space:           ~20GB for images + volumes

┌─────────────────────────────────────────────────────────────────────────┐
│                         DEPLOYMENT FLOW                                 │
└─────────────────────────────────────────────────────────────────────────┘

    1. docker compose pull      → Download images (one-time, requires internet)
    2. docker compose up -d     → Start all services
    3. Health checks run        → Verify services are healthy
    4. Access management tools  → Open web browsers
    5. Connect to databases     → Use clients or docker exec
    6. Store data in volumes    → Persistent across restarts
    7. docker compose down      → Stop services (data persists)
    8. docker compose down -v   → Remove all data (optional)

┌─────────────────────────────────────────────────────────────────────────┐
│                        ACCESS PATTERNS                                  │
└─────────────────────────────────────────────────────────────────────────┘

CLI Access:
  docker exec -it pdi-[service] [command]
  Example: docker exec -it pdi-postgresql psql -U postgres

Web Access:
  http://localhost:[port]
  Example: http://localhost:8082 (Adminer)

Connection String:
  [protocol]://[user]:[password]@localhost:[port]/[database]
  Example: mongodb://mongo:mongo@localhost:27017/testdb

┌─────────────────────────────────────────────────────────────────────────┐
│                      KEY FEATURES                                       │
└─────────────────────────────────────────────────────────────────────────┘

✓ Complete Offline Operation    ✓ Health Monitoring
✓ One-Command Deployment        ✓ Data Persistence
✓ Interactive Management        ✓ Environment Configuration
✓ Multi-Database Support        ✓ Resource Isolation
✓ Web-Based Management         ✓ Production Patterns
✓ Comprehensive Documentation  ✓ Easy Customization

┌─────────────────────────────────────────────────────────────────────────┐
│                    DOCUMENTATION FILES                                  │
└─────────────────────────────────────────────────────────────────────────┘

├── README.md              → Main documentation & getting started
├── QUICK-REFERENCE.md     → Command cheat sheet
├── TESTING.md             → Testing examples for each database
├── OFFLINE.md             → Complete offline operation guide
├── CONTRIBUTING.md        → Guide for extending environment
├── SUMMARY.md             → Project overview & statistics
└── ARCHITECTURE.md        → This file

┌─────────────────────────────────────────────────────────────────────────┐
│                         SECURITY MODEL                                  │
└─────────────────────────────────────────────────────────────────────────┘

Network Isolation:     All services on private bridge network
Credentials:           Default dev passwords (not for production)
External Access:       Only through mapped ports
Data Encryption:       None (development environment)
SSL/TLS:              Disabled (can be enabled via config)

⚠️  WARNING: This is a DEVELOPMENT/TESTING environment
    DO NOT use default passwords in production
    DO NOT expose these ports to the internet without proper security

┌─────────────────────────────────────────────────────────────────────────┐
│                       SYSTEM REQUIREMENTS                               │
└─────────────────────────────────────────────────────────────────────────┘

Software:
  ├── Docker:         20.10+ (or Docker Desktop)
  ├── Docker Compose: 2.0+
  └── Bash:          4.0+ (for start.sh script)

Hardware:
  ├── CPU:   4+ cores recommended
  ├── RAM:   8GB minimum, 16GB recommended
  ├── Disk:  20GB+ free space
  └── OS:    Linux, macOS, Windows (WSL2)

Network:
  └── Internet: Required only for initial image download
```

---

**Architecture Version:** 1.0.0  
**Last Updated:** 2025-11-05  
**Maintained by:** PDI Database Management Experimentation Project
