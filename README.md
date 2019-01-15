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

- - -

## news-app.api.51.ca

51中间层接口，分别转接51房产、51主站、51论坛、51新闻、问吧的接口，为 51 Touch版、51 App、问吧 App 提供数据支持，详细文档请查阅对应代码库。

#### Repository

https://github.com/51-CA/news-app.api.51.ca

#### 文档

[接口文档](https://51dotca.atlassian.net/wiki/spaces/5NA/pages/1048704/51+API)

#### 依赖

51主站接口 ([文档](https://51dotca.atlassian.net/wiki/spaces/5NA/pages/12222546/BBS.51.CA+API)) (包括工作接口、用户接口、租房接口、黄页接口)
```bash
https://www.51.ca
```

51新闻接口 ([文档](https://51dotca.atlassian.net/wiki/spaces/5NA/pages/12222566/www.51.ca+JSON))
```bash
https://info.51.ca
```

51口碑接口 ([文档](https://51dotca.atlassian.net/wiki/spaces/5NA/pages/16646162/kb.51.ca))
```bash
https://kb.51.ca
```

51论坛接口 ([文档](https://51dotca.atlassian.net/wiki/spaces/5NA/pages/12222546/BBS.51.CA+API))
```bash
https://bbs.51.ca
```


- - -

## api.51.ca

51问吧旧版接口，大部分功能已经改成用 news-app.api.51.ca 接口，现在只为51团购商家版提供登录和消费验证接口，还有分别为51 App、问吧 App 提供黄页、工作机会、打折消息、周末好去处等详情页面，详细文档请查阅对应代码库。

```bash
# 黄页详情页
http://api.51.ca/wen8app/detailpage/service/#/item/199909
# 工作机会详情页
http://api.51.ca/wen8app/detailpage/job/#item/650919
# 打折消息和周末好去处详情页
http://api.51.ca/wen8app/detailpage/event/#item/723783
```

#### Repository

https://github.com/51-CA/api.51.ca

- - -

## m.51.ca

51网站的手机 Touch版，主要包含了新闻，黄页和租房模块，以 React 开发，详细文档请查阅对应代码库。

#### Repository

https://github.com/51-CA/m.51.ca.git

#### 依赖
51中间层接口 ([文档](https://51dotca.atlassian.net/wiki/spaces/5NA/pages/1048704/51+API))
```bash
https://news-app.api.51.ca
```


- - -
## discovery.51.ca

51 App 和 问吧 App的发现页面，以 React 开发，详细文档请查阅对应代码库。

#### Repository

https://github.com/51-CA/discovery.51.ca.git

#### 依赖
51中间层接口 ([文档](https://51dotca.atlassian.net/wiki/spaces/5NA/pages/1048704/51+API))
```bash
https://news-app.api.51.ca
```