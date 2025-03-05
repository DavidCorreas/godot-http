FROM alpine:latest

RUN apk add --no-cache openvpn openssl

# Crear directorio para los archivos VPN
RUN mkdir -p /etc/openvpn/client

# Copiar el script de inicio
COPY start-vpn.sh /start-vpn.sh
RUN chmod +x /start-vpn.sh

WORKDIR /etc/openvpn/client

# Usar el script como punto de entrada
CMD ["/start-vpn.sh"]