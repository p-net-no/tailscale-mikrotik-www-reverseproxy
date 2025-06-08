#!/bin/sh
set -e

echo "[+] Starting Tailscale background service..."
/usr/local/bin/tailscale.sh &

echo "[+] Waiting for tailscale to come up..."
sleep 5

echo "[+] Generating NGINX config..."
NGINX_CONF="/etc/nginx/http.d/default.conf"
echo "# Auto-generated" > "$NGINX_CONF"

IFS=','

for pair in $WEBPROXY_TARGETS; do
  target=$(echo "$pair" | cut -d'@' -f1)
  prefix=$(echo "$pair" | cut -d'@' -f2)

  if [ -z "$target" ]; then
    echo "[-] Skipping invalid target (missing address): $pair"
    continue
  fi

  if [ -z "$prefix" ]; then
    echo "[+] Adding default route → $target"
    cat <<EOF >> "$NGINX_CONF"
server {
    listen 80;
    location / {
        proxy_pass http://${target}/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF
  else
    echo "[+] Adding /$prefix/ → $target"
    cat <<EOF >> "$NGINX_CONF"
server {
    listen 80;
    location /${prefix}/ {
        rewrite ^/${prefix}/(.*)\$ /\$1 break;
        proxy_pass http://${target}/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF
  fi
done

echo "[+] Starting NGINX in foreground..."
nginx -g "daemon off;"

