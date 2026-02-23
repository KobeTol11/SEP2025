#!/bin/bash
#
# Provisioning script for Reverse Proxy (OpenResty on g07-syndus.internal)
#
# This script installs OpenResty and firewalld, generates a self-signed SSL certificate
# with an OCSP extension (note: for production, use a certificate from a trusted CA),
# and configures the reverse proxy. Because self-signed certificates do not have a valid OCSP responder,
# OCSP stapling is disabled.
#
#------------------------------------------------------------------------------
# Bash settings
#------------------------------------------------------------------------------
set -o errexit   # abort on nonzero exit status
set -o nounset   # abort on unbound variable
set -o pipefail  # fail on errors in piped commands

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------
PROXY_PASS_HOST="192.168.207.50"     # IP of the web server
cert_path="/etc/ssl/certs/myCertificate.crt"
key_path="/etc/ssl/private/myKey.key"
chain_path="/etc/ssl/certs/fullchain.crt"  # Full certificate chain
intermediate_cert="/etc/ssl/certs/intermediate.crt"  # Intermediate certificate (if available)

SSL_CERT="$chain_path"
SSL_KEY="$key_path"

GATEWAY_IP="192.168.207.17"
INTERNAL_NETWORK="192.168.207.0/24"

#------------------------------------------------------------------------------
# Function: log
#------------------------------------------------------------------------------
log() {
    echo "[INFO] $1"
}

#------------------------------------------------------------------------------
# Install required packages and configure repository
#------------------------------------------------------------------------------
log "Installing EPEL release and configuring the OpenResty repository"
sudo dnf install -y epel-release
sudo dnf config-manager --add-repo https://openresty.org/package/centos/openresty.repo
sudo dnf install -y --nogpgcheck openresty firewalld

#------------------------------------------------------------------------------
# Configure firewalld
#------------------------------------------------------------------------------
log "Checking if firewalld is running"
if ! systemctl is-active --quiet firewalld; then
    log "Starting firewalld"
    sudo systemctl enable --now firewalld
else
    log "firewalld is already running"
fi

log "Configuring firewall rules for HTTP (port 80) and HTTPS (port 443)"
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
sudo firewall-cmd --zone=public --add-port=443/tcp --permanent
sudo firewall-cmd --reload

#------------------------------------------------------------------------------
# Enable OpenResty (and firewalld) on boot
#------------------------------------------------------------------------------
log "Enabling OpenResty to start on boot"
sudo systemctl enable --now openresty

#------------------------------------------------------------------------------
# Set SELinux permissions for OpenResty
#------------------------------------------------------------------------------
log "Setting SELinux permissions for OpenResty (httpd_can_network_connect)"
sudo setsebool -P httpd_can_network_connect 1

#------------------------------------------------------------------------------
# Prepare SSL certificate directories
#------------------------------------------------------------------------------
log "Creating directories for SSL certificates"
sudo mkdir -p /etc/ssl/certs /etc/ssl/private
sudo chmod 700 /etc/ssl/certs /etc/ssl/private

#------------------------------------------------------------------------------
# Generate SSL certificate with an OCSP extension
#------------------------------------------------------------------------------
if [ ! -f "$cert_path" ] || [ ! -f "$key_path" ]; then
    log "Generating self-signed SSL certificate with OCSP extension"
    TMP_OPENSSL_CONFIG="/tmp/openssl_ocsp.cnf"
    cat > "$TMP_OPENSSL_CONFIG" <<EOF
[ req ]
default_bits       = 4096
prompt             = no
default_md         = sha256
distinguished_name = req_distinguished_name
x509_extensions    = v3_req

[ req_distinguished_name ]
C  = BE
ST = OV
L  = Ghent
O  = Hogent
CN = g07-syndus.internal

[ v3_req ]
subjectKeyIdentifier    = hash
authorityKeyIdentifier  = keyid,issuer
basicConstraints        = CA:FALSE
keyUsage                = digitalSignature, keyEncipherment
extendedKeyUsage        = serverAuth
authorityInfoAccess     = OCSP;URI:http://ocsp.g07-syndus.internal
EOF

    sudo openssl req -new -newkey rsa:4096 -x509 -nodes -days 365 \
        -config "$TMP_OPENSSL_CONFIG" -extensions v3_req \
        -keyout "$key_path" -out "$cert_path"
    rm "$TMP_OPENSSL_CONFIG"
else
    log "SSL certificate already exists"
fi
sudo chmod 600 "$key_path" "$cert_path"

#------------------------------------------------------------------------------
# Assemble fullchain certificate (including intermediate if available)
#------------------------------------------------------------------------------
if [ ! -f "$chain_path" ]; then
    if [ -f "$intermediate_cert" ]; then
        log "Assembling fullchain certificate with intermediate certificate"
        sudo cat "$cert_path" "$intermediate_cert" > "$chain_path"
    else
        log "No intermediate certificate found; using domain certificate as fullchain"
        sudo cp "$cert_path" "$chain_path"
    fi
else
    log "Fullchain certificate already exists"
fi
sudo chmod 600 "$key_path" "$chain_path"

#------------------------------------------------------------------------------
# Create custom error page file if it doesn't exist
#------------------------------------------------------------------------------
if [ ! -f "/usr/share/nginx/html/custom_50x.html" ]; then
    log "Creating custom error page at /usr/share/nginx/html/custom_50x.html"
    sudo mkdir -p /usr/share/nginx/html
    echo "<html><head><title>Error</title></head><body><h1>Service Unavailable</h1><p>Please try again later.</p></body></html>" | sudo tee /usr/share/nginx/html/custom_50x.html > /dev/null
fi

#------------------------------------------------------------------------------
# Configure OpenResty for Reverse Proxy
#------------------------------------------------------------------------------
log "Configuring OpenResty reverse proxy"
sudo mkdir -p /etc/openresty/conf.d

OPENRESTY_CONF="/usr/local/openresty/nginx/conf/nginx.conf"
sudo tee "$OPENRESTY_CONF" > /dev/null <<EOF
worker_processes  1;
pid              logs/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';
    access_log  logs/access.log  main;
    error_log   logs/error.log  warn;

    sendfile        on;
    tcp_nopush     on;
    tcp_nodelay    on;
    keepalive_timeout  65;
    types_hash_max_size 2048;

    # SSL settings
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256';
    ssl_session_cache shared:SSL:10m;
    ssl_session_tickets off;
    ssl_stapling off;
    ssl_stapling_verify off;
    resolver 8.8.8.8 valid=300s;  # External resolver for OCSP stapling
    resolver_timeout 5s;

    # Custom server header for security through obscurity
    more_set_headers 'Server: Apache';

    # Rate limiting setup
    limit_req_zone \$binary_remote_addr zone=one:10m rate=5r/s;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
    #add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://trustedscripts.example.com;";


    server {
        listen 80;
        server_name g07-syndus.internal www.g07-syndus.internal;
        return 301 https://\$host\$request_uri;
    }

    server {
        listen 443 ssl ;
        listen [::]:443 ssl ;
        http2 on;
        server_name g07-syndus.internal www.g07-syndus.internal;

        ssl_certificate /etc/ssl/certs/fullchain.crt;  # if you have a chain certificate
        ssl_certificate_key /etc/ssl/private/myKey.key;
        # Optionally disable stapling if not applicable
        ssl_stapling off;
        ssl_stapling_verify off;

        location / {
            proxy_pass http://$PROXY_PASS_HOST;
            proxy_redirect off;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header Host \$http_host;
        }
    }
}
EOF
#------------------------------------------------------------------------------
# Ensure the hostname is correctly mapped
#------------------------------------------------------------------------------

if ! grep -q "192.168.207.50 g07-syndus.internal" /etc/hosts; then
    echo "192.168.207.50 g07-syndus.internal" | sudo tee -a /etc/hosts
    echo "Added g07-syndus.internal to /etc/hosts"
fi

#------------------------------------------------------------------------------
# Test and restart OpenResty
#------------------------------------------------------------------------------
log "Testing OpenResty configuration"
if ! sudo openresty -t; then
    echo "ERROR: OpenResty configuration test failed."
    exit 1
fi

log "Restarting OpenResty"
if ! sudo systemctl restart openresty; then
    echo "ERROR: OpenResty failed to restart."
    exit 1
fi

#------------------------------------------------------------------------------
# Adjust network configuration for the internal network
#------------------------------------------------------------------------------
log "Setting network routes for internal network $INTERNAL_NETWORK"
if ! sudo ip route | grep -qE "^$INTERNAL_NETWORK"; then
    sudo ip route add "$INTERNAL_NETWORK" via "$GATEWAY_IP" || true
fi

#------------------------------------------------------------------------------
# Final message
#------------------------------------------------------------------------------
log "Reverse Proxy setup complete."
log "You can access your services via: https://g07-syndus.internal"