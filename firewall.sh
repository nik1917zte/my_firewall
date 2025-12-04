#!/bin/bash

# ==================================
# SIMPLE SAFE LINUX FIREWALL SCRIPT
# ==================================

echo "[+] Applying firewall rules..."

# -----------------------------
# CLEAR OLD RULES
# -----------------------------
iptables -F
iptables -X

# -----------------------------
# DEFAULT POLICIES
# -----------------------------
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# -----------------------------
# LOOPBACK TRAFFIC
# -----------------------------
iptables -A INPUT -i lo -j ACCEPT

# -----------------------------
# ESTABLISHED CONNECTIONS
# -----------------------------
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# -----------------------------
# ALLOW SERVICES
# -----------------------------
iptables -A INPUT -p tcp --dport 80 -j ACCEPT   # Web
iptables -A INPUT -p tcp --dport 443 -j ACCEPT  # HTTPS

# -----------------------------
# RATE-LIMIT LOGGING
# -----------------------------
iptables -A INPUT -m limit --limit 5/min --limit-burst 10 -j LOG \
--log-prefix "[FW BLOCK] " --log-level warning --log-ip-options --log-tcp-options

# -----------------------------
# FINAL DROP (EXPLICIT BLOCK)
# -----------------------------
iptables -A INPUT -j DROP

echo "[+] Firewall active."

