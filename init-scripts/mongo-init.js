// MongoDB Initialization Script
// This script creates sample collections and data for testing

// Switch to testdb
db = db.getSiblingDB('testdb');

// Create users collection with sample data
db.users.insertMany([
    {
        username: "jdoe",
        email: "john.doe@example.com",
        firstName: "John",
        lastName: "Doe",
        createdAt: new Date(),
        updatedAt: new Date()
    },
    {
        username: "asmith",
        email: "alice.smith@example.com",
        firstName: "Alice",
        lastName: "Smith",
        createdAt: new Date(),
        updatedAt: new Date()
    },
    {
        username: "bwilson",
        email: "bob.wilson@example.com",
        firstName: "Bob",
        lastName: "Wilson",
        createdAt: new Date(),
        updatedAt: new Date()
    }
]);

// Create products collection with sample data
db.products.insertMany([
    {
        name: "Laptop",
        description: "High-performance laptop",
        price: 999.99,
        stockQuantity: 50,
        category: "Electronics",
        createdAt: new Date()
    },
    {
        name: "Mouse",
        description: "Wireless mouse",
        price: 29.99,
        stockQuantity: 200,
        category: "Electronics",
        createdAt: new Date()
    },
    {
        name: "Keyboard",
        description: "Mechanical keyboard",
        price: 79.99,
        stockQuantity: 150,
        category: "Electronics",
        createdAt: new Date()
    },
    {
        name: "Monitor",
        description: "27-inch 4K monitor",
        price: 399.99,
        stockQuantity: 75,
        category: "Electronics",
        createdAt: new Date()
    },
    {
        name: "Desk Chair",
        description: "Ergonomic office chair",
        price: 249.99,
        stockQuantity: 30,
        category: "Furniture",
        createdAt: new Date()
    }
]);

// Create indexes
db.users.createIndex({ email: 1 }, { unique: true });
db.users.createIndex({ username: 1 }, { unique: true });
db.products.createIndex({ category: 1 });
db.products.createIndex({ name: 1 });

print("MongoDB initialization completed successfully!");
