-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Drop existing tables if rebuilding schema
DROP TABLE IF EXISTS password_reset_tokens;
DROP TABLE IF EXISTS dashboard_tokens;
DROP TABLE IF EXISTS verification_tokens;
DROP TABLE IF EXISTS username_history;
DROP TABLE IF EXISTS users;

-- Users table
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    two_factor_method TEXT,
    email_code TEXT,
    email_code_expires INTEGER,
    bypass_2fa BOOLEAN DEFAULT 0,
    current_token TEXT,
    dashboard_token TEXT UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_login DATETIME,
    reset_password_token TEXT UNIQUE,
    reset_password_expires DATETIME
);

-- Username history table to track username changes
CREATE TABLE username_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    username TEXT NOT NULL,
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Create indexes for better performance
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_reset_token ON users(reset_password_token);
CREATE INDEX idx_username_history_username ON username_history(username);
CREATE INDEX idx_username_history_user_id ON username_history(user_id);
