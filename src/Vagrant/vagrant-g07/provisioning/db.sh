#!/bin/bash
#
# Provisioning script for database server

#------------------------------------------------------------------------------
# Bash settings
#------------------------------------------------------------------------------
set -euo pipefail  # Strict mode: exit on errors, undefined variables, or pipe failures

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------
readonly DB_ROOT_PASSWORD="password"
readonly DB_NAME="g07_databank"
readonly DB_TABLE="syndus_tbl"
readonly DB_USER="www_user"
readonly DB_PASSWORD="password"

#------------------------------------------------------------------------------
# Functions
#------------------------------------------------------------------------------
log() {
    echo "[LOG] $1"
}

is_mysql_root_password_empty() {
    mysql -uroot -e "SELECT 1" &> /dev/null
}

#------------------------------------------------------------------------------
# Start Provisioning
#------------------------------------------------------------------------------
log "=== Starting server provisioning on ${HOSTNAME} ==="

#------------------------------------------------------------------------------
# Install & Configure MariaDB
#------------------------------------------------------------------------------
log "Installing MariaDB server..."
dnf install -y mariadb-server

log "Enabling and starting MariaDB service..."
systemctl enable --now mariadb.service

#------------------------------------------------------------------------------
# Configure Firewall
#------------------------------------------------------------------------------
log "Checking if firewalld is installed and running..."
if ! systemctl is-active --quiet firewalld; then
    log "Installing and starting firewalld..."
    dnf install -y firewalld
    systemctl enable --now firewalld
else
    log "firewalld is already running."
fi

log "Setting firewall rules..."
firewall-cmd --permanent --add-service=mysql
firewall-cmd --permanent --add-port=22/tcp
firewall-cmd --reload

#------------------------------------------------------------------------------
# Secure Database
#------------------------------------------------------------------------------
log "Securing MariaDB..."
if is_mysql_root_password_empty; then
    mysql -uroot <<_EOF_
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
        DELETE FROM mysql.user WHERE User='';
        DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
        DROP DATABASE IF EXISTS test;
        DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
        FLUSH PRIVILEGES;
_EOF_
    log "Root password set and unnecessary users/databases removed."
else
    log "Root password is already set. Skipping security steps."
fi

#------------------------------------------------------------------------------
# Create Database & User
#------------------------------------------------------------------------------
log "Creating database and user..."
mysql -uroot -p"${DB_ROOT_PASSWORD}" <<_EOF_
    CREATE DATABASE IF NOT EXISTS ${DB_NAME};
    GRANT ALL ON ${DB_NAME}.* TO '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
    FLUSH PRIVILEGES;
_EOF_

#------------------------------------------------------------------------------
# Create Table & Insert Sample Data
#------------------------------------------------------------------------------
log "Creating database table and inserting sample data..."
mysql -u"${DB_USER}" -p"${DB_PASSWORD}" "${DB_NAME}" <<_EOF_
    CREATE TABLE IF NOT EXISTS ${DB_TABLE} (
        id INT(5) NOT NULL AUTO_INCREMENT,
        name VARCHAR(50) DEFAULT NULL,
        PRIMARY KEY(id)
    );
    REPLACE INTO ${DB_TABLE} (id, name) VALUES 
        (1, "Tuxedo T. Penguin"),
        (2, "Bobby Tables");
_EOF_

log "Database setup complete!"
