# Learnings from AWS WireGuard VPN Setup

This document summarizes the key lessons I learned while setting up a WireGuard VPN on an AWS EC2 instance (Ubuntu).

---

## AWS and EC2
- How to launch an EC2 instance on AWS.  
- Understanding the importance of security groups (allowing only necessary ports).  
- Basics of connecting to EC2 via SSH using a `.pem` key.  

---

## WireGuard
- Learned how WireGuard uses **public and private keys** for secure tunnels.  
- Understood the structure of the `wg0.conf` file:
  - `[Interface]` section for local configuration.  
  - `[Peer]` section for remote peers.  
- Importance of choosing the right IP ranges and ports.  

---

## Linux Server Management
- Gained practice in using Ubuntu commands to install and configure software.  
- Learned to check WireGuard status using `sudo wg show`.  
- Edited configuration files safely with placeholders instead of exposing real values.  

---

## Security Awareness
- Understood the risks of uploading real IPs or private keys to GitHub.  
- Learned the habit of sanitizing sensitive files before sharing.  
- Realized the importance of keeping VPN ports secured with proper firewall rules.  

---

## Reflection
This was my first attempt at setting up a VPN in the cloud.  
Even though I used an open-source script to speed up the installation, the real value came from:
- Understanding what the script was doing step by step.  
- Manually configuring and testing the connection.  
- Documenting the process in a way that others (and my future self) can follow.  
