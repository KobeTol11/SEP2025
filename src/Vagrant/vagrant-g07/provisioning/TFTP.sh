#! /bin/bash
#
# Provisioning script for TFTP

#------------------------------------------------------------------------------
# Bash settings
#------------------------------------------------------------------------------

# Enable "Bash strict mode"
set -eou pipefail


# Install and configure firewalld if needed
echo "Checking if firewalld is installed and running..."
if ! systemctl is-active --quiet firewalld; then
    echo "Installing and starting firewalld..."
    sudo dnf install firewalld -y
    sudo systemctl start firewalld
    sudo systemctl enable firewalld
else
    echo "firewalld is already running."
fi

# Allow TFTP traffic through the firewall
echo "Configuring firewall to allow TFTP traffic..."
sudo firewall-cmd --permanent --add-service=tftp
sudo firewall-cmd --reload

# Update system and install TFTP server + xinetd
echo "Installing TFTP-server and xinetd..."
sudo dnf install -y tftp-server xinetd

# Configure TFTP service
echo "Configuring TFTP service..."
sudo tee /etc/systemd/system/tftp.service > /dev/null <<EOF
[Unit]
Description=TFTP Server
After=network.target

[Service]
ExecStart=/usr/sbin/in.tftpd -c -p -s /var/lib/tftpboot
TimeoutStartSec=30
StandardInput=socket
Restart=always
User=nobody
Group=nobody

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to recognize the new service
sudo systemctl daemon-reload

# Create TFTP directory and set permissions
echo "Creating TFTP directory and setting permissions..."
sudo mkdir -p /var/lib/tftpboot
sudo chmod -R 777 /var/lib/tftpboot
sudo chown -R nobody:nobody /var/lib/tftpboot

# Start and enable TFTP service
echo "Starting and enabling TFTP service..."
sudo systemctl start tftp.service
sudo systemctl enable tftp.service

# Check the status of the TFTP service
echo "Checking the status of TFTP service..."
sudo systemctl status tftp.service

# Create a test file to verify TFTP functionality
echo "Creating test file for TFTP..."
echo "TFTP test" | sudo tee /var/lib/tftpboot/testfile.txt
sudo chmod 666 /var/lib/tftpboot/testfile.txt

# Print success message
echo "TFTP server installation and configuration completed!"
