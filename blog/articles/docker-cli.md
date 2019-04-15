---
title: Docker用法总结
date: 2019-03-28 11:41:22
categories: Linux
top: 24
---

## 前言

本文主要介绍docker的一些常见用法，记录一些问题的解决办法。

### Docker 命令记录

```bash
# 容器生命周期管理
run	-itd
start/stop/restart
kill
rm
pause/unpause
create
exec -it
# 容器操作
ps
inspect
top
attach
events
logs
wait
export
port
# 容器rootfs命令
commit
cp
diff
# 镜像仓库
login
pull
push
search
# 本地镜像管理
images
rmi
tag
build
history
save
import
info|version
info
version
```

### Docker File

[参考官方文档](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

| 命令        | 例子                                                         |
| ----------- | ------------------------------------------------------------ |
| FROM        | FROM busybox:$VERSION                                        |
| LABEL       | LABEL com.example.version="0.0.1-beta"                       |
| RUN         | RUN apt-get update                                           |
| RUN         | RUN ["/bin/bash", "-c", "set -o pipefail && wget -O - https://some.site \| wc -l > /number"] |
| CMD         | CMD echo "This is a test." \| wc - 容器docker run 时候执行   |
| EXPOSE      | EXPOSE 80/tcp                                                |
| ENV         | ENV myName John Doe                                          |
| ADD or COPY | COPY requirements.txt /tmp/ 推荐COPY                         |
| ENTRYPOINT  | ENTRYPOINT ["executable", "param1", "param2"]类似CMD，不会被覆盖 |
| VOLUME      | VOLUME /myvol                                                |
| USER        | USER <user>[:<group>]                                        |
| WORKDIR     | WORKDIR /path/to/workdir                                     |
| ARG         | ARG <name>[=<default value>]                                 |