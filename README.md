# How to try it out

1. Build container
```shell
docker-compose up -d --build
```

2. Curl your IP
```shell
curl --proxy socks5h://localhost:1080 https://ipinfo.io/ip
```
