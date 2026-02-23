#!/bin/bash
#
# Provisioning script for Reverse Proxy with HTTPS and HTTP/2
#
# Assumes NGINX is installed and available

#------------------------------------------------------------------------------
# Bash settings
#------------------------------------------------------------------------------
set -euo pipefail  # Enable strict mode

# Update package lists
echo "Updating package lists..."
sudo dnf makecache -y

# Install necessary packages
echo "Installing required packages..."
sudo dnf install -y nginx firewalld epel-release openssl

# Enable and start necessary services
echo "Enabling and starting necessary services..."
sudo systemctl enable --now nginx firewalld

#------------------------------------------------------------------------------
# Generate a self-signed certificate for NGINX
echo "Generating self-signed certificate for NGINX..."

# Create directories for SSL if they don't exist
if [ ! -d "/etc/nginx/ssl" ]; then
    sudo mkdir -p /etc/nginx/ssl
fi

# Create a self-signed SSL certificate
if [ ! -f "/etc/nginx/ssl/nginx-selfsigned.crt" ] || [ ! -f "/etc/nginx/ssl/nginx-selfsigned.key" ]; then
    sudo openssl req -x509 -nodes -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx-selfsigned.key -out /etc/nginx/ssl/nginx-selfsigned.crt -days 365 -subj "/C=US/ST=State/L=City/O=Company/OU=IT/CN=l01-thematrix.internal"
fi

# Set correct permissions for SSL certificates
sudo chown nginx:nginx /etc/nginx/ssl/nginx-selfsigned.crt /etc/nginx/ssl/nginx-selfsigned.key

#------------------------------------------------------------------------------
# NGINX Configuration for Reverse Proxy with HTTPS and HTTP/2
echo "Configuring NGINX for reverse proxy with HTTPS and HTTP/2..."

# Check if the reverse proxy config already exists, if not create it
if [ ! -f "/etc/nginx/conf.d/reverseproxy.conf" ]; then
    sudo tee /etc/nginx/conf.d/reverseproxy.conf > /dev/null <<EOF
server {
    listen 443 ssl http2;
    server_name l01-thematrix.internal www.l01-thematrix.internal;

    # SSL settings
    ssl_certificate /etc/nginx/ssl/nginx-selfsigned.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx-selfsigned.key;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers 'TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:ECDHE-RSA-AES128-GCM-SHA256';
    ssl_prefer_server_ciphers on;

    # HTTP Strict Transport Security (HSTS)
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    # Reverse proxy to the internal web server (via HTTP)
    location / {
        proxy_pass http://192.168.207.31;  # IP address of the internal web server
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}

# Redirect HTTP to HTTPS
server {
    listen 80;
    server_name l01-thematrix.internal www.l01-thematrix.internal;

    # Force HTTP to HTTPS redirection
    return 301 https://\$host\$request_uri;
}
EOF
else
    echo "NGINX reverse proxy config already exists."
fi

#------------------------------------------------------------------------------
# Test NGINX configuration for errors
echo "Testing NGINX configuration..."
sudo nginx -t
NGINX_TEST_STATUS=$?

if [ $NGINX_TEST_STATUS -ne 0 ]; then
    echo "NGINX configuration test failed with status code $NGINX_TEST_STATUS."
    echo "Please check the error logs for more details."
    sudo nginx -t 2>&1 | tee nginx_test_error.log
    exit 1
else
    echo "NGINX configuration is correct."
fi

# If configuration is correct, restart NGINX
echo "Restarting NGINX..."
sudo systemctl restart nginx
NGINX_RESTART_STATUS=$?

if [ $NGINX_RESTART_STATUS -ne 0 ]; then
    echo "NGINX failed to restart with status code $NGINX_RESTART_STATUS."
    echo "Please check the systemd logs for more details."
    sudo journalctl -xeu nginx.service | tee nginx_restart_error.log
    exit 1
else
    echo "NGINX restarted successfully."
fi

#------------------------------------------------------------------------------
# Web server settings: Disable version information
echo "Configuring NGINX to hide version information..."
echo "server_tokens off;" | sudo tee -a /etc/nginx/nginx.conf > /dev/null

# Restart NGINX after updating configuration
echo "Restarting NGINX to apply server_tokens change..."
sudo systemctl restart nginx

#------------------------------------------------------------------------------
# Firewall Configuration for HTTP and HTTPS
echo "Configuring firewall for HTTP and HTTPS..."
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload

#------------------------------------------------------------------------------
# Final message
echo "Reverse Proxy setup complete."
echo "You can now access the webserver via HTTPS: https://l01-thematrix.internal or https://www.l01-thematrix.internal"
