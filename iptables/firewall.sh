#!/bin/bash
iptables -F
iptables -X

iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Permitir tráfico local
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# SSH Autorizado desde redes específicas
iptables -A INPUT -p tcp --dport 22 -s 192.168.23.0/24 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -s 200.27.0.0/24 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -s 146.83.1.0/24 -j ACCEPT

iptables -A OUTPUT -p tcp --sport 22 -d 192.168.23.0/24 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -d 200.27.0.0/24 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -d 146.83.1.0/24 -j ACCEPT

# Permitir tráfico en RED
iptables -A INPUT -p tcp -m multiport --dports 80,443 -j ACCEPT
iptables -A OUTPUT -p tcp -m multiport --sports 80,443 -j ACCEPT


# Aceptar trafico interno
# Desde PCs de desarrollo, administración, investigación, etc. (192.168.1.32/27)
iptables -A INPUT -s 192.168.1.32/27 -j ACCEPT
iptables -A OUTPUT -d 192.168.1.32/27 -j ACCEPT

# Desde administración TI, switches, AP, router (192.168.1.0/27)
iptables -A INPUT -s 192.168.1.0/27 -j ACCEPT
iptables -A OUTPUT -d 192.168.1.0/27 -j ACCEPT


# Bloquear todo el tráfico no permitido
iptables -A INPUT -j LOG --log-prefix "DROP INPUT: "
iptables -A OUTPUT -j LOG --log-prefix "DROP OUTPUT: "