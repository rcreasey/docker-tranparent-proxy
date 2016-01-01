iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to 192.168.201.250:3128
iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to 192.168.201.250:3129

iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to 3128 -w
iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to 3129 -w

iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to 192.168.99.103:3128 -w
iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to 192.168.99.103:3129 -w
