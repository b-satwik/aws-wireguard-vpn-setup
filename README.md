# AWS WireGuard VPN Setup on Ubuntu

This project documents my first hands-on AWS EC2 deployment where I set up a WireGuard VPN on an Ubuntu instance.  
I used an open-source automation script (from GitHub/YouTube) to install WireGuard, then customized the configuration for my environment.  

---

## What I Did
- Launched an Ubuntu EC2 instance on AWS.  
- Installed WireGuard using an open-source shell script.  
- Configured WireGuard peers and interface manually.  
- Tested the secure VPN tunnel successfully.  

---

## Requirements
- AWS account with EC2 access.  
- Ubuntu server (tested on Ubuntu 22.04).  
- Open-source WireGuard installation script (credit: [original GitHub/YouTube source link here]).  
- Basic Linux knowledge.  

---

## Example Configuration
The following is an example `wg0.conf` file.  
Note: The IP addresses and keys shown here are not real. They are placeholders to illustrate the format.

```ini
[Interface]
PrivateKey = <YOUR_PRIVATE_KEY>
Address = 10.0.0.1/24
ListenPort = 51820

[Peer]
PublicKey = <PEER_PUBLIC_KEY>
AllowedIPs = 10.0.0.2/32
Endpoint = <EC2_PUBLIC_IP>:51820
