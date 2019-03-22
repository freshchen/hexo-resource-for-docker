---
title: REHL网络学习笔记
date: 2019-03-21 15:29:29
categories: Linux
top: 19
---

## 简介

工作中发现网络方面的基础比较重要，在这方面比较薄弱，决心好好学一波。本文主要是一些重要知识点的笔记，以及遇到过问题的解决记录。主要学习链接如下：

[红帽子7官方网络指南](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/7/html/networking_guide/ch-configure_ip_networking)

## 常用命令

1.在 Red Hat Enterprise Linux 7 中编辑 `ifcfg` 文件时，**NetworkManager** 不会自动意识到更改，需为其提供通知。如果使用以下工具之一更新 **NetworkManager** 配置文件，则 **NetworkManager** 会在使用该配置文件重新连接后方可实施那些更改。例如：如果使用编辑器更改配置文件，则必须让 **NetworkManager** 重新读取该配置文件。方法是作为 `root` 运行以下命令：

```
nmcli connection reload
```

上述命令会读取所有连接配置文件。另外也可以运行下面的命令，只重新载入那些有变化的文件 `ifcfg-*ifname*`：

```
nmcli con load /etc/sysconfig/network-scripts/ifcfg-ifname
```



2.ifup脚本是一个通用脚本，可完成一些任务，并调用具体接口脚本，比如 ifup-ethX，ifup-wireless，ifup-ppp

等等。用户手动运行 ifup eth0后：

1. `ifup` 会查找名为 `/etc/sysconfig/network-scripts/ifcfg-eth0` 的文件；
2. 如果存在 `ifcfg` 文件，`ifup` 会在那个文件中查找 `TYPE` 密钥，以确定要调用的脚本类型；
3. `ifup` 根据 `TYPE` 调用 `ifup-wireless` 或 `ifup-eth` 或 `ifup-XXX`；
4. 具体类型脚本执行具体类型设置；
5. 然后具体类型脚本让通用功能执行与 `IP` 相关的任务，比如 `DHCP` 或静态设置。
