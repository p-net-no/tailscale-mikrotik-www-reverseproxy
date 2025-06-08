FROM ghcr.io/fluent-networks/tailscale-mikrotik:latest

# Install nginx
RUN apk update && \
    apk add --no-cache nginx && \
    mkdir -p /run/nginx /etc/nginx/http.d/

# Add wrapper startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# CMD runs both Tailscale and dynamic nginx
CMD ["/start.sh"]

