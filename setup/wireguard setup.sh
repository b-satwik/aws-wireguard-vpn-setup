#!/bin/bash
# ======================================================
# WireGuard Installer Script (Modified for AWS)
# 
# Original Source: Open-source WireGuard auto-installers
# Modified By: Bala Satwik (AWS adaptation, cleanup)
# With Assistance From: ChatGPT (automation & refactor)
#
# Purpose: Automate WireGuard VPN installation and 
#          configuration on Ubuntu (AWS EC2 instance).
# License: MIT (same as original base script)
# ======================================================

set -e

# Detect public IP (for AWS EC2 instances)
PUBLIC_IP=$(curl -s ifconfig.me || wget -qO- ifconfig.me)

# Default values (can be modified)
WG_PORT=51820
WG_INTERFACE="wg0"
WG_CONF="/etc/wireguard/${WG_INTERFACE}.conf"

echo "====================================="
echo " WireGuard VPN Auto-Setup (AWS EC2)  "
echo "====================================="
echo "Detected Public IP: ${PUBLIC_IP}"
echo ""

# Install WireGuard if not already installed
install_wireguard() {
    echo "[*] Installing WireGuard..."
    apt-get update
    apt-get install -y wireguard qrencode
}

# Generate keys
generate_keys() {
    echo "[*] Generating server keys..."
    SERVER_PRIVATE_KEY=$(wg genkey)
    SERVER_PUBLIC_KEY=$(echo $SERVER_PRIVATE_KEY | wg pubkey)

    echo "[*] Generating client keys..."
    CLIENT_PRIVATE_KEY=$(wg genkey)
    CLIENT_PUBLIC_KEY=$(echo $CLIENT_PRIVATE_KEY | wg pubkey)
    CLIENT_PRESHARED_KEY=$(wg genpsk)
}

# Configure server
configure_server() {
    echo "[*] Creating WireGuard server config at ${WG_CONF}..."
    cat > $WG_CONF <<EOL
[Interface]
Address = 10.8.0.1/24
ListenPort = ${WG_PORT}
PrivateKey = ${SERVER_PRIVATE_KEY}

[Peer]
PublicKey = ${CLIENT_PUBLIC_KEY}
PresharedKey = ${CLIENT_PRESHARED_KEY}
AllowedIPs = 10.8.0.2/32
EOL

    chmod 600 $WG_CONF
    systemctl enable wg-quick@${WG_INTERFACE}
    systemctl start wg-quick@${WG_INTERFACE}
}

# Generate client config
generate_client_conf() {
    CLIENT_CONF="client-wg0.conf"
    echo "[*] Creating client configuration file (${CLIENT_CONF})..."

    cat > ${CLIENT_CONF} <<EOL
[Interface]
PrivateKey = ${CLIENT_PRIVATE_KEY}
Address = 10.8.0.2/24
DNS = 1.1.1.1

[Peer]
PublicKey = ${SERVER_PUBLIC_KEY}
PresharedKey = ${CLIENT_PRESHARED_KEY}
Endpoint = ${PUBLIC_IP}:${WG_PORT}
AllowedIPs = 0.0.0.0/0, ::/0
EOL

    echo "[*] Client configuration generated: ${CLIENT_CONF}"
    qrencode -t ansiutf8 < ${CLIENT_CONF}
}

# Run steps
install_wireguard
generate_keys
configure_server
generate_client_conf

echo ""
echo "====================================="
echo " WireGuard setup complete!"
echo " Server config: ${WG_CONF}"
echo " Client config: client-wg0.conf"
echo "====================================="
