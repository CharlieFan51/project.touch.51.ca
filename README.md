## 运行环境

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
# vi /etc/hosts

127.0.0.1    dev.m.51.ca
127.0.0.1    dev.discovery.51.ca
127.0.0.1    dev.news-app.api.51.ca
127.0.0.1    dev.api.51.ca
127.0.0.1    dev.phpmyadmin.ca
```

#### Database

```bash
# 应用数据库资料
cp database .data

# 访问 dev.phpmyadmin.ca
username = default
password = secret
```



## news-app.api.51.ca

51网站中间层接口，分别为 51 Touch版、51 App、问吧 App 提供数据支持，详细文档请查阅对应代码库的 README.md

#### Repository

https://github.com/51-CA/news-app.api.51.ca


## m.51.ca

51网站的手机 Touch版，主要包含了新闻，黄页和租房模块，以 React 开发，详细文档请查阅对应代码库的 README.md

#### Repository

https://github.com/51-CA/m.51.ca.git

#### 依赖
接口 ([文档](https://51dotca.atlassian.net/wiki/spaces/5NA/pages/1048704/51+API))
```bash
http://news-app.api.51.ca
```


## discovery.51.ca

51 App 和 问吧 App的发现页面，以 React 开发，详细文档请查阅对应代码库的 README.md

#### Repository

https://github.com/51-CA/discovery.51.ca.git

#### 依赖
接口 ([文档](https://51dotca.atlassian.net/wiki/spaces/5NA/pages/1048704/51+API))
```bash
http://news-app.api.51.ca
```