# Database Testing Examples

This document provides practical examples for testing each database in the environment.

## Table of Contents
- [Relational Databases](#relational-databases)
- [NoSQL Databases](#nosql-databases)
- [Analytical Databases](#analytical-databases)
- [Testing Scenarios](#testing-scenarios)

## Relational Databases

### PostgreSQL

**Connect via psql:**
```bash
docker exec -it pdi-postgresql psql -U postgres -d testdb
```

**Run sample queries:**
```sql
-- Create a table
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    salary NUMERIC(10,2)
);

-- Insert data
INSERT INTO employees (name, department, salary) VALUES
    ('Alice Johnson', 'Engineering', 95000.00),
    ('Bob Smith', 'Marketing', 75000.00);

-- Query data
SELECT * FROM employees WHERE salary > 70000;

-- Use PostgreSQL-specific features
SELECT name, department, 
       salary::money as formatted_salary 
FROM employees;

-- JSON queries (PostgreSQL supports JSON)
CREATE TABLE api_logs (
    id SERIAL PRIMARY KEY,
    data JSONB
);

INSERT INTO api_logs (data) VALUES 
    ('{"user": "alice", "action": "login", "timestamp": "2024-01-01T10:00:00Z"}');

SELECT data->>'user' as username FROM api_logs;
```

### MySQL 8

**Connect via mysql client:**
```bash
docker exec -it pdi-mysql8 mysql -uroot -proot testdb
```

**Test MySQL 8 features:**
```sql
-- Window functions (MySQL 8+)
CREATE TABLE sales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product VARCHAR(50),
    amount DECIMAL(10,2),
    sale_date DATE
);

INSERT INTO sales (product, amount, sale_date) VALUES
    ('Laptop', 999.99, '2024-01-01'),
    ('Mouse', 29.99, '2024-01-02'),
    ('Laptop', 899.99, '2024-01-03');

-- Use window function
SELECT product, amount,
       ROW_NUMBER() OVER (PARTITION BY product ORDER BY amount DESC) as rank
FROM sales;

-- Common Table Expressions (CTE)
WITH product_stats AS (
    SELECT product, AVG(amount) as avg_price
    FROM sales
    GROUP BY product
)
SELECT * FROM product_stats WHERE avg_price > 50;
```

### MySQL 5.7

**Connect:**
```bash
docker exec -it pdi-mysql57 mysql -uroot -proot testdb
```

**Test compatibility:**
```sql
-- Test without window functions (not available in 5.7)
SELECT product, amount FROM sales ORDER BY amount DESC;

-- Subqueries instead
SELECT s1.*, 
       (SELECT COUNT(*) FROM sales s2 
        WHERE s2.product = s1.product AND s2.amount > s1.amount) + 1 as rank
FROM sales s1;
```

### MariaDB

**Connect:**
```bash
docker exec -it pdi-mariadb mysql -uroot -proot testdb
```

**Test MariaDB-specific features:**
```sql
-- Test sequences (MariaDB feature)
CREATE SEQUENCE order_seq START WITH 1000 INCREMENT BY 1;

CREATE TABLE orders (
    id BIGINT DEFAULT NEXTVAL(order_seq) PRIMARY KEY,
    customer_name VARCHAR(100),
    order_total DECIMAL(10,2)
);

INSERT INTO orders (customer_name, order_total) 
VALUES ('John Doe', 150.00);

SELECT * FROM orders;
```

### MS SQL Server

**Connect via sqlcmd:**
```bash
docker exec -it pdi-mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "YourStrong@Passw0rd"
```

**Test T-SQL features:**
```sql
-- Enable specific database
USE testdb;
GO

-- Create table
CREATE TABLE customers (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100),
    email NVARCHAR(100)
);
GO

-- Insert data
INSERT INTO customers (name, email) VALUES
    ('Alice', 'alice@example.com'),
    ('Bob', 'bob@example.com');
GO

-- Query with T-SQL syntax
SELECT TOP 10 * FROM customers;
GO

-- Use T-SQL specific functions
SELECT 
    name,
    UPPER(name) as name_upper,
    FORMAT(GETDATE(), 'yyyy-MM-dd') as today
FROM customers;
GO
```

### Oracle XE

**Connect via sqlplus:**
```bash
docker exec -it pdi-oracle sqlplus system/oracle@testdb
```

**Test Oracle features:**
```sql
-- Create table
CREATE TABLE departments (
    dept_id NUMBER PRIMARY KEY,
    dept_name VARCHAR2(100),
    location VARCHAR2(100)
);

-- Insert data
INSERT INTO departments VALUES (1, 'Engineering', 'Building A');
INSERT INTO departments VALUES (2, 'Sales', 'Building B');
COMMIT;

-- Query data
SELECT * FROM departments;

-- Use Oracle-specific features
SELECT dept_name, 
       SUBSTR(dept_name, 1, 3) as abbrev,
       SYSDATE as current_date
FROM departments;
```

### CockroachDB

**Connect via SQL shell:**
```bash
docker exec -it pdi-cockroachdb ./cockroach sql --insecure
```

**Test distributed features:**
```sql
-- Create a distributed table
CREATE TABLE accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    balance DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT current_timestamp()
);

-- Insert data
INSERT INTO accounts (balance) VALUES (1000.00), (2500.00), (750.00);

-- View data distribution
SHOW RANGES FROM TABLE accounts;

-- Test transactions
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = (SELECT id FROM accounts LIMIT 1);
UPDATE accounts SET balance = balance + 100 WHERE id = (SELECT id FROM accounts OFFSET 1 LIMIT 1);
COMMIT;
```

## NoSQL Databases

### MongoDB

**Connect via mongosh:**
```bash
docker exec -it pdi-mongodb mongosh -u mongo -p mongo --authenticationDatabase admin
```

**Test MongoDB features:**
```javascript
// Switch to database
use testdb;

// Insert documents
db.products.insertMany([
    {
        name: "Laptop",
        price: 999.99,
        specs: { cpu: "Intel i7", ram: "16GB", storage: "512GB SSD" },
        tags: ["electronics", "computers"]
    },
    {
        name: "Mouse",
        price: 29.99,
        specs: { type: "wireless", dpi: 1600 },
        tags: ["electronics", "accessories"]
    }
]);

// Query documents
db.products.find({ price: { $lt: 100 } });

// Aggregation pipeline
db.products.aggregate([
    { $match: { "tags": "electronics" } },
    { $group: { _id: "$tags", avgPrice: { $avg: "$price" } } }
]);

// Text search
db.products.createIndex({ name: "text", tags: "text" });
db.products.find({ $text: { $search: "laptop" } });

// Update documents
db.products.updateOne(
    { name: "Laptop" },
    { $set: { "specs.ram": "32GB" } }
);
```

### Redis

**Connect via redis-cli:**
```bash
docker exec -it pdi-redis redis-cli -a redis
```

**Test Redis data structures:**
```redis
# Strings
SET user:1:name "Alice"
GET user:1:name
INCR page:views
GET page:views

# Lists
LPUSH tasks "task1" "task2" "task3"
LRANGE tasks 0 -1
RPOP tasks

# Sets
SADD tags:post1 "redis" "database" "nosql"
SMEMBERS tags:post1
SISMEMBER tags:post1 "redis"

# Sorted Sets
ZADD leaderboard 100 "player1" 250 "player2" 175 "player3"
ZRANGE leaderboard 0 -1 WITHSCORES
ZREVRANK leaderboard "player2"

# Hashes
HSET user:2 name "Bob" email "bob@example.com" age 30
HGETALL user:2
HGET user:2 email

# Expiration
SETEX session:abc123 3600 "user-data"
TTL session:abc123
```

### Cassandra

**Connect via cqlsh:**
```bash
docker exec -it pdi-cassandra cqlsh
```

**Test Cassandra features:**
```cql
-- Create keyspace
CREATE KEYSPACE IF NOT EXISTS testks 
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

USE testks;

-- Create table
CREATE TABLE users (
    user_id UUID PRIMARY KEY,
    username TEXT,
    email TEXT,
    created_at TIMESTAMP
);

-- Insert data
INSERT INTO users (user_id, username, email, created_at) 
VALUES (uuid(), 'alice', 'alice@example.com', toTimestamp(now()));

-- Query data
SELECT * FROM users;

-- Create table with composite key
CREATE TABLE events (
    event_date DATE,
    event_time TIMESTAMP,
    event_type TEXT,
    user_id UUID,
    PRIMARY KEY (event_date, event_time)
) WITH CLUSTERING ORDER BY (event_time DESC);
```

### Neo4j

**Access via browser:** http://localhost:7474

**Or via cypher-shell:**
```bash
docker exec -it pdi-neo4j cypher-shell -u neo4j -p neo4jpassword
```

**Test graph operations:**
```cypher
// Create nodes
CREATE (alice:Person {name: 'Alice', age: 30})
CREATE (bob:Person {name: 'Bob', age: 25})
CREATE (company:Company {name: 'TechCorp'})

// Create relationships
MATCH (a:Person {name: 'Alice'}), (c:Company {name: 'TechCorp'})
CREATE (a)-[:WORKS_AT {since: 2020}]->(c)

MATCH (b:Person {name: 'Bob'}), (a:Person {name: 'Alice'})
CREATE (b)-[:KNOWS]->(a)

// Query graph
MATCH (p:Person)-[:WORKS_AT]->(c:Company)
RETURN p.name, c.name

// Find paths
MATCH path = (a:Person)-[:KNOWS*1..3]-(b:Person)
WHERE a.name = 'Bob'
RETURN path

// Aggregations
MATCH (p:Person)-[:WORKS_AT]->(c:Company)
RETURN c.name, count(p) as employee_count
```

### ArangoDB

**Access via web UI:** http://localhost:8529 (user: root, password: arango)

**Or via arangosh:**
```bash
docker exec -it pdi-arangodb arangosh --server.password arango
```

**Test multi-model features:**
```javascript
// Switch to database
db._useDatabase('testdb');

// Document store
db._create('users');
db.users.save({ name: 'Alice', age: 30, city: 'New York' });
db.users.save({ name: 'Bob', age: 25, city: 'San Francisco' });

// Query documents
db._query('FOR u IN users FILTER u.age > 25 RETURN u');

// Create graph
var graph_module = require('@arangodb/general-graph');
var graph = graph_module._create('social');
graph._addVertexCollection('persons');
graph._extendEdgeDefinitions({
    collection: 'knows',
    from: ['persons'],
    to: ['persons']
});

// Add graph data
db.persons.save({ _key: 'alice', name: 'Alice' });
db.persons.save({ _key: 'bob', name: 'Bob' });
db.knows.save({ _from: 'persons/alice', _to: 'persons/bob', since: 2020 });

// Graph traversal
db._query(`
    FOR v, e, p IN 1..2 OUTBOUND 'persons/alice' knows
    RETURN { vertex: v, edge: e, path: p }
`);
```

## Analytical Databases

### ClickHouse

**Connect via clickhouse-client:**
```bash
docker exec -it pdi-clickhouse clickhouse-client --user clickhouse --password clickhouse
```

**Test analytical features:**
```sql
-- Create table with specific engine
CREATE TABLE events (
    event_date Date,
    event_time DateTime,
    user_id UInt32,
    event_type String,
    value Float64
) ENGINE = MergeTree()
ORDER BY (event_date, event_time);

-- Insert data
INSERT INTO events VALUES
    ('2024-01-01', '2024-01-01 10:00:00', 1, 'click', 1.0),
    ('2024-01-01', '2024-01-01 10:05:00', 1, 'purchase', 99.99),
    ('2024-01-01', '2024-01-01 10:10:00', 2, 'click', 1.0);

-- Analytical queries
SELECT 
    event_date,
    event_type,
    count() as event_count,
    sum(value) as total_value
FROM events
GROUP BY event_date, event_type
ORDER BY event_date, event_count DESC;

-- Time-based aggregation
SELECT 
    toStartOfHour(event_time) as hour,
    uniq(user_id) as unique_users
FROM events
GROUP BY hour
ORDER BY hour;
```

### InfluxDB

**Access via influx CLI:**
```bash
docker exec -it pdi-influxdb influx -t influxtoken123
```

**Test time-series features:**
```influx
# List buckets
buckets()

# Write data using line protocol
# (Usually done via API, but showing the concept)

# Query data using Flux
from(bucket: "testbucket")
  |> range(start: -1h)
  |> filter(fn: (r) => r._measurement == "temperature")
  |> mean()
```

## Testing Scenarios

### Scenario 1: Data Type Comparison

Test how different databases handle the same data types:

```bash
# In PostgreSQL
CREATE TABLE test_types (
    id SERIAL,
    text_field TEXT,
    number_field NUMERIC(10,2),
    date_field TIMESTAMP
);

# In MySQL
CREATE TABLE test_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    text_field TEXT,
    number_field DECIMAL(10,2),
    date_field DATETIME
);

# Compare behavior, performance, storage
```

### Scenario 2: Transaction Testing

Test ACID properties across databases:

```sql
-- Test in PostgreSQL, MySQL, etc.
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
-- Simulate failure
ROLLBACK; -- or COMMIT;
```

### Scenario 3: Performance Comparison

Create identical datasets and compare query performance:

```bash
# Generate test data
for i in {1..10000}; do
    echo "INSERT INTO test_table VALUES ($i, 'data$i', RANDOM());"
done | psql ...
```

### Scenario 4: Replication Testing

Test different replication approaches in MongoDB, PostgreSQL, MySQL.

### Scenario 5: Full-Text Search

Compare full-text search capabilities:
- PostgreSQL: tsvector
- MySQL: FULLTEXT indexes
- MongoDB: text indexes
- Elasticsearch (if added)

## Best Practices

1. **Use transactions** for consistency testing
2. **Monitor performance** with `docker stats`
3. **Check logs** when things go wrong
4. **Backup data** before destructive tests
5. **Use initialization scripts** for repeatable setups
6. **Document findings** for future reference

## Cleanup

After testing, clean up resources:

```bash
# Remove all data
docker-compose down -v

# Or remove specific service data
docker volume rm pdi-database-management-experimentation_postgresql-data
```

---

Happy Testing! 🧪
