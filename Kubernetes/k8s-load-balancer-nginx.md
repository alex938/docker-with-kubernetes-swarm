# Setup NGINX load balancer

## Create

/mnt/k8s/certs/cloudflare.ini
```
dns_cloudflare_email = example@email
dns_cloudflare_api_key = 111111111111111111111111111111
```
sudo chmod -R 700 /mnt/k8s/certs
chmod 600 /mnt/k8s/certs/cloudflare.ini

### Obtain certs
```
docker run --rm \
  -v /mnt/k8s/certs:/etc/letsencrypt \
  -v /mnt/k8s/certs/cloudflare.ini:/etc/letsencrypt/cloudflare.ini \
  certbot/dns-cloudflare \
  certonly \
  --dns-cloudflare \
  --dns-cloudflare-credentials /etc/letsencrypt/cloudflare.ini \
  --non-interactive \
  --agree-tos \
  --email a@a.com \
  -d k.labjunkie.org
```

### https://github.com/certbot/certbot/blob/main/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf
### /mnt/k8s/options/options-ssl-nginx.conf
```
# This file contains important security parameters. If you modify this file
# manually, Certbot will be unable to automatically provide future security
# updates. Instead, Certbot will print and log an error message with a path to
# the up-to-date file that you will need to refer to when manually updating
# this file. Contents are based on https://ssl-config.mozilla.org

ssl_session_cache shared:le_nginx_SSL:10m;
ssl_session_timeout 1440m;
ssl_session_tickets off;

ssl_protocols TLSv1.2 TLSv1.3;
ssl_prefer_server_ciphers off;

ssl_ciphers "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384";
```

### /mnt/k8s/params/dhparam.pem
```
sudo openssl dhparam -out /mnt/k8s/params/dhparam.pem 2048
```
sudo chmod 600 /mnt/k8s/params/dhparam.pem


### /mnt/k8s/conf
### nginx.conf
```
server {
    listen 443 ssl;
    server_name k.labjunkie.org;

    ssl_certificate /etc/letsencrypt/live/k.labjunkie.org/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/k.labjunkie.org/privkey.pem;

    ssl_dhparam /etc/nginx/ssl/dhparam.pem;

    include /etc/nginx/options/options-ssl-nginx.conf;

    location / {
        proxy_pass https://kubernetes_api;
        proxy_ssl_verify on; #upstream uses self signed certs
        proxy_ssl_trusted_certificate /etc/nginx/ssl/ca.crt;  #upstream uses self signed certs
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

upstream kubernetes_api {
    least_conn;
    server 192.168.2.52:6443 max_fails=3 fail_timeout=5s;
    server 192.168.2.53:6443 max_fails=3 fail_timeout=5s;
}
```

### mkdir -p /mnt/k8s/logs
### docker-compose.yml
```
services:
  nginx:
    image: nginx:latest
    container_name: nginx-k8s-lb
    ports:
      - "443:443"
    volumes:
      - /mnt/k8s/certs:/etc/letsencrypt      # Mount certificates
      - /mnt/k8s/ssl:/etc/nginx/ssl          # Mount DH parameters
      - /mnt/k8s/options:/etc/nginx/options  # Mount security options
      - /mnt/k8s/conf:/etc/nginx/conf.d      # Mount NGINX configuration directory
      - /mnt/k8s/logs:/var/log/nginx         # Mount logs directory
    restart: always
    healthcheck:
      test: ["CMD", "curl", "--cacert", "/etc/nginx/ssl/ca.crt", "-f", "https://localhost"]
      interval: 30s
      timeout: 10s
      retries: 3

volumes:
  certs:
  params:
  options:
  confs:
```

### Trust k8s self-signed cert
```
scp user@control-plane-node:/etc/kubernetes/pki/ca.crt /mnt/k8s/ssl/ca.crt
docker exec nginx-k8s-lb nginx -s reload
curl -k https://k.labjunkie.org
```

### Further fault finding
```
docker exec nginx-k8s-lb nginx -t
docker exec nginx-k8s-lb nginx -s reload
openssl s_client -connect 192.168.2.52:6443 -CAfile /mnt/k8s/ssl/ca.crt
docker exec nginx-k8s-lb curl --cacert /etc/nginx/ssl/ca.crt -f https://localhost
```
