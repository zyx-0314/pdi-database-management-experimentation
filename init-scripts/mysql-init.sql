-- MySQL Initialization Script
-- This script creates sample tables and data for testing

-- Create a sample users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create a sample products table
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    category VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create a sample orders table
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2),
    status VARCHAR(20) DEFAULT 'pending',
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Insert sample data
INSERT IGNORE INTO users (username, email, first_name, last_name) VALUES
    ('jdoe', 'john.doe@example.com', 'John', 'Doe'),
    ('asmith', 'alice.smith@example.com', 'Alice', 'Smith'),
    ('bwilson', 'bob.wilson@example.com', 'Bob', 'Wilson');

INSERT IGNORE INTO products (name, description, price, stock_quantity, category) VALUES
    ('Laptop', 'High-performance laptop', 999.99, 50, 'Electronics'),
    ('Mouse', 'Wireless mouse', 29.99, 200, 'Electronics'),
    ('Keyboard', 'Mechanical keyboard', 79.99, 150, 'Electronics'),
    ('Monitor', '27-inch 4K monitor', 399.99, 75, 'Electronics'),
    ('Desk Chair', 'Ergonomic office chair', 249.99, 30, 'Furniture');

-- Create indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_orders_user_id ON orders(user_id);
