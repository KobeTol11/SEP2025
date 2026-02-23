#!/bin/bash
#
# Provisioning script for web server

#------------------------------------------------------------------------------
# Bash settings
#------------------------------------------------------------------------------
set -euo pipefail  # Strict mode

# Function for logging messages
log() {
    echo "[INFO] $1"
}

# Install Apache, PHP, and MySQL extension
log "Installing Apache, PHP, and MySQL extension..."
dnf install -y httpd php php-mysqlnd

# Enable and start Apache
log "Enabling and starting Apache..."
systemctl enable --now httpd

# Configure firewall for HTTP traffic
log "Checking if firewalld is installed and running..."
if ! systemctl is-active --quiet firewalld; then
    log "Installing and starting firewalld..."
    dnf install -y firewalld
    systemctl enable --now firewalld
else
    log "firewalld is already running."
fi

log "Configuring firewall rules for HTTP traffic..."
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --reload

# Allow Apache to connect to the database
log "Setting SELinux permissions for Apache to connect to databases..."
setsebool -P httpd_can_network_connect_db 1
setsebool -P httpd_can_network_connect 1

# Set up document root and database connection
WEB_DIR="/var/www/html"
DB_HOST="db_server_ip"   # Replace with actual DB server IP
DB_USER="www_user"
DB_PASS="password"
DB_NAME="g07-databank"
DB_TABLE="syndus_tbl"

log "Setting up web server document root and database connection..."
cat <<EOF > "$WEB_DIR/index.php"
<?php
\$servername = "$DB_HOST";
\$username = "$DB_USER";
\$password = "$DB_PASS";
\$dbname = "$DB_NAME";

// Create connection
\$conn = new mysqli(\$servername, \$username, \$password, \$dbname);

// Check connection
if (\$conn->connect_error) {
    die("Connection failed: " . \$conn->connect_error);
}

// Fetch data
\$sql = "SELECT * FROM $DB_TABLE";
\$result = \$conn->query(\$sql);

if (\$result->num_rows > 0) {
    while (\$row = \$result->fetch_assoc()) {
        echo "ID: " . \$row["id"] . " - Name: " . \$row["name"] . "<br>";
    }
} else {
    echo "No results";
}
\$conn->close();
?>
EOF

# Set proper permissions
log "Setting permissions for web directory..."
chown -R apache:apache "$WEB_DIR"
chmod -R 755 "$WEB_DIR"

log "Web server setup complete! Access it at http://g07-synbus.internal/"
