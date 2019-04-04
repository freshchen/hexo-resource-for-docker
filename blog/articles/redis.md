---
title: Redis安装与使用学习笔记
date: 2019-03-13 10:23:19
categories: Linux
top: 26
---

## 简介

Redis is an open source (BSD licensed), in-memory data structure store, used as a database, cache and message broker. It supports data structures such as strings, hashes, lists, sets, sorted sets with range queries, bitmaps, hyperloglogs, geospatial indexes with radius queries and streams. Redis has built-in replication, Lua scripting, LRU eviction, transactions and different levels of on-disk persistence, and provides high availability via Redis Sentinel and automatic partitioning with Redis Cluster.

## 安装

```bash
cd /usr/local/
wget http://download.redis.io/releases/redis-5.0.4.tar.gz
tar -zxvf redis-5.0.4.tar.gz
cd redis-5.0.4/
make MALLOC=libc
make test
make PREFIX=/usr/local/redis install
cd /usr/local/redis
cp /usr/local/rediss-5.0.4/redis.conf /usr/local/redis/
mkdir -p /etc/redis/
cp /usr/local/redis/redis.conf /etc/redis/6379.conf
cp /usr/local/redis-4.0.6/utils/redis_init_script /etc/init.d/redisd
# 改变conf文件中的 daemonize 参数为 yes
chkconfig redisd on
systemctl start redisd
systemctl status redisd
```

## CLI命令

| 通用命令  | 示例           | 描述                                        |
| --------- | -------------- | ------------------------------------------- |
| SET       | SET name lingc | 给key赋予string类型值，key重复则覆盖        |
| GET       | GET name       | 得到key的值，如果得到的不是string类型值报错 |
| KEYS      | KEYS *         | 查寻key，支持正则                           |
| RANDOMKEY | RANDOMKEY      | 随机显示一个key                             |
| EXISTS    | EXISTS name    | 判断key是否存在                             |
|TYPE|TYPE name|看key类型（1有0没有）|
|DEL|DEL name|删除key|
|RENAME|RENAME name myname|更改key，如果要变为的key存在，覆盖原值|
|RENAMENX|RENAMENX name myname|更改key，如果要变为的key存在，则放弃操作|
|SELECT|SELECT 0|切换数据库，默认有16个库（0-15）|
|MOVE|MOVE name 1|把key移到别的库|
||||
||||
||||
||||
||||
||||
||||
||||
||||
||||
||||
||||
||||
||||