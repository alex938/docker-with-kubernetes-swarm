# Docker Health Checks

```
FROM nginx:latest

COPY health.html /usr/share/nginx/html/health.html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost/health.html || exit 1

CMD ["nginx", "-g", "daemon off;"]

```

```
services:
  nginx:
    image: nginx:latest
    container_name: nginx_healthcheck
    ports:
      - "8080:80"
    volumes:
      - ./health.html:/usr/share/nginx/html/health.html:ro
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/health.html"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 10s

```
