#!/bin/bash

# PDI Database Management Experimentation - Quick Start Script
# This script helps you easily start and manage the database environment

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Print colored message
print_message() {
    echo -e "${2}${1}${NC}"
}

# Print header
print_header() {
    echo ""
    echo "============================================"
    echo "$1"
    echo "============================================"
    echo ""
}

# Check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_message "Docker is not installed. Please install Docker first." "$RED"
        exit 1
    fi
    
    if ! command -v docker compose &> /dev/null && ! docker compose version &> /dev/null; then
        print_message "Docker Compose is not installed. Please install Docker Compose first." "$RED"
        exit 1
    fi
}

# Show main menu
show_menu() {
    print_header "PDI Database Management Experimentation"
    echo "1) Start All Services"
    echo "2) Start Relational Databases Only"
    echo "3) Start NoSQL Databases Only"
    echo "4) Start Analytical Databases Only"
    echo "5) Start Management Tools Only"
    echo "6) Stop All Services"
    echo "7) Stop and Remove All Data (⚠️ Destructive)"
    echo "8) View Service Status"
    echo "9) View Logs"
    echo "10) List Available Ports"
    echo "11) Run Health Check"
    echo "0) Exit"
    echo ""
    read -p "Select an option: " choice
}

# Start all services
start_all() {
    print_message "Starting all services..." "$BLUE"
    docker compose up -d
    print_message "All services started successfully!" "$GREEN"
    show_ports
}

# Start relational databases
start_relational() {
    print_message "Starting relational databases..." "$BLUE"
    docker compose up -d postgresql mysql8 mysql57 mariadb mssql oracle sqlite cockroachdb
    print_message "Relational databases started!" "$GREEN"
}

# Start NoSQL databases
start_nosql() {
    print_message "Starting NoSQL databases..." "$BLUE"
    docker compose up -d mongodb redis cassandra neo4j arangodb
    print_message "NoSQL databases started!" "$GREEN"
}

# Start analytical databases
start_analytical() {
    print_message "Starting analytical databases..." "$BLUE"
    docker compose up -d clickhouse influxdb duckdb
    print_message "Analytical databases started!" "$GREEN"
}

# Start management tools
start_management() {
    print_message "Starting management tools..." "$BLUE"
    docker compose up -d phpmyadmin adminer pgadmin cloudbeaver dbgate mongo-express redis-commander
    print_message "Management tools started!" "$GREEN"
}

# Stop all services
stop_all() {
    print_message "Stopping all services..." "$YELLOW"
    docker compose down
    print_message "All services stopped!" "$GREEN"
}

# Remove all data
remove_all() {
    read -p "⚠️  This will DELETE ALL DATA! Are you sure? (yes/no): " confirm
    if [ "$confirm" = "yes" ]; then
        print_message "Stopping and removing all services and data..." "$RED"
        docker compose down -v
        print_message "All services and data removed!" "$GREEN"
    else
        print_message "Operation cancelled." "$YELLOW"
    fi
}

# Show service status
show_status() {
    print_header "Service Status"
    docker compose ps
}

# Show logs
show_logs() {
    echo ""
    read -p "Enter service name (or press Enter for all): " service
    if [ -z "$service" ]; then
        docker compose logs --tail=50 -f
    else
        docker compose logs --tail=50 -f "$service"
    fi
}

# List available ports
show_ports() {
    print_header "Available Services and Ports"
    cat << EOF
RELATIONAL DATABASES:
  PostgreSQL        : localhost:5432
  MySQL 8           : localhost:3308
  MySQL 5.7         : localhost:3307
  MariaDB           : localhost:3309
  MS SQL Server     : localhost:1433
  Oracle XE         : localhost:1521
  CockroachDB       : localhost:26257 (UI: 8080)
  NeonDB            : localhost:5434

NoSQL DATABASES:
  MongoDB           : localhost:27017
  Redis             : localhost:6379
  Cassandra         : localhost:9042
  Neo4j             : localhost:7474 (Bolt: 7687)
  ArangoDB          : localhost:8529

ANALYTICAL DATABASES:
  ClickHouse        : localhost:8123 (Native: 9000)
  InfluxDB          : localhost:8086
  DuckDB            : (access via container shell)

MANAGEMENT TOOLS:
  phpMyAdmin        : http://localhost:8081
  Adminer           : http://localhost:8082
  pgAdmin           : http://localhost:5050
  CloudBeaver       : http://localhost:8978
  DBGate            : http://localhost:3001
  Mongo Express     : http://localhost:8083
  Redis Commander   : http://localhost:8084

EOF
}

# Run health check
health_check() {
    print_header "Health Check"
    docker compose ps | grep -E "(healthy|up)"
}

# Main loop
main() {
    check_docker
    
    while true; do
        show_menu
        
        case $choice in
            1) start_all ;;
            2) start_relational ;;
            3) start_nosql ;;
            4) start_analytical ;;
            5) start_management ;;
            6) stop_all ;;
            7) remove_all ;;
            8) show_status ;;
            9) show_logs ;;
            10) show_ports ;;
            11) health_check ;;
            0) 
                print_message "Goodbye!" "$GREEN"
                exit 0
                ;;
            *)
                print_message "Invalid option. Please try again." "$RED"
                ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
    done
}

# Run main function
main
