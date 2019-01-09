#### Docker

```bash
# 启动 nginx / mysql / phpmyadmin
find . -name "._*" -type f -delete && docker-compose up -d nginx mysql phpmyadmin

# 连接到对应容器
docker-compose exec {container-name} bash

# 查看对应容器日志
docker-compose logs {container-name}

# 查看启动中的容器
docker-compose ps

# 停止所有容器
docker-compose stop

# 停止并删除所有容器
docker-compose down

# 移除不再运行的镜像
docker system prune -a

# 重新建立镜像
docker-compose build --no-cache {container-name}

# Docker 的 MySql操作
docker-compose exec mysql bash

docker-compose exec mysql mysql -u default -psecret

```

#### Host

```bash
127.0.0.1    dev.m.51.ca
127.0.0.1    dev.news-app.api.51.ca
```