---
title: Queens版本Openstack安装记录
date: 2019-02-21 17:10:16
categories: Openstack
top: 16
---

### 准备工作

这次安装的是openstack的queens版本，操作系统是REHL7.6，安装前确保根目录下分配了足够的空间，主要参看[官方文档](https://docs.openstack.org/queens/install/)进行安装，记录遇到问题的解决方案。

[如果不能连外网可以参考另外一篇博客自制YUM源](https://freshchen.github.io/2019/02/14/yumsource/)

需要安装的包如下

```sh
yum install -y https://repos.fedorapeople.org/repos/openstack/openstack-queens/rdo-release-queens-1.noarch.rpm
yum install -y chrony 
yum install -y mariadb mariadb-server python2-PyMySQL
yum install -y rabbitmq-server
yum install -y memcached python-memcached
yum install -y etcd
yum install -y python-openstackclient
# [keystone]
yum install -y openstack-keystone httpd mod_wsgi mod_ssl
# [glance]
yum install -y openstack-glance
# [nova]
yum install -y openstack-nova-api openstack-nova-conductor openstack-nova-console openstack-nova-novncproxy openstack-nova-scheduler openstack-nova-placement-api
yum install -y openstack-nova-compute
# [neutron]
yum install -y openstack-neutron openstack-neutron-ml2 ebtables ipset
# 使用 openstack-neutron-linuxbridge 或者 openstack-neutron-openvswitch. [SRIOV可选]
yum install -y openstack-neutron-linuxbridge
yum install -y openstack-neutron-openvswitch
yum install -y openstack-neutron-sriov-nic-agent
# [horizon]
yum install -y openstack-dashboard
# [cinder]
yum install -y openstack-cinder targetcli python-keystone
# [heat]
yum install -y openstack-heat-api openstack-heat-api-cfn openstack-heat-engine
```

### 基础服务安装

```sh
[root@localhost ~]# hostname
controller
[root@localhost ~]# cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
<IP> controller


# 关闭防火墙：
[root@controller ~]# systemctl status firewalld.service
[root@controller ~]# systemctl stop firewalld.service
[root@controller ~]# systemctl disable firewalld.service

# 已经开启了ip forward:
[root@controller ~]# sysctl -a | grep net.ipv4.ip_forward
net.ipv4.ip_forward = 1

#移除默认的libvirt网络
virsh net-destroy default
virsh net-autostart --disable default
virsh net-undefine default
virsh net-list

#数据库配置
mysql_secure_installation
mysql -u root


systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service
systemctl status rabbitmq-server.service

rabbitmqctl add_user openstack RABBIT_PASS {RABBIT_PASS = openstack1234}
rabbitmqctl add_user openstack openstack1234
rabbitmqctl set_permissions openstack ".*" ".*" ".*"

# 检查：
[root@controller ~]# rabbitmqctl list_users
Listing users ...
openstack	[]
guest	[administrator]


systemctl restart memcached
systemctl status memcached
```

### 安装Openstack组件

主要按照官网来，没遇到问题就不做记录

#### keystone

[官网](https://docs.openstack.org/keystone/queens/install/)

```sh
# 改完可能会apache起不来没有35357和5000端口，重启服务就好了 
apachectl restart
```

```sh
# 重启
systemctl restart httpd.service
```

#### nova

[官网](https://docs.openstack.org/nova/queens/install/)

```sh
# 忽略python警告
sed -n '325,333p' /usr/lib/python2.7/site-packages/oslo_db/sqlalchemy/enginefacade.py
```

```sh
# 重启
systemctl restart openstack-nova-api.service openstack-nova-consoleauth.service openstack-nova-scheduler.service openstack-nova-conductor.service openstack-nova-novncproxy.service
```

#### glance

[官网](https://docs.openstack.org/glance/queens/install/)

```sh
# 问题一
[root@controller ~]# openstack image create "cirros-rhel7.4" --file /home/echneli/rhel-server-7.4-x86_64-kvm.qcow2 --disk-format qcow2 --container-format bare --public
503 Service Unavailable: The server is currently unavailable. Please try again at a later time. (HTTP 503)

[root@controller ~]# vi /var/log/glance/api.log
2019-01-24 21:42:48.597 27505 CRITICAL keystonemiddleware.auth_token [-] Unable to validate token: Identity server rejected authorization necessary to fetch token data: ServiceError: Identity server rejected authorization necessary to fetch token data

# 出现以上情况应该是配置文件中的密码错了，应该填写创建用户时候的密码，忘记了只能改密码，然后重启服务
openstack user set --password GLANCE_PWD  (user id)

```

```sh
# 重启
systemctl restart openstack-glance-api.service openstack-glance-registry.service
```

#### neutron

[官网](https://docs.openstack.org/neutron/queens/install/)

```sh
# 重启
ystemctl restart neutron-server.service neutron-openvswitch-agent.service neutron-l3-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service
```

#### heat

[官网](https://docs.openstack.org/heat/queens/install/)

```sh
# 重启
systemctl restart openstack-heat-api.service openstack-heat-api-cfn.service openstack-heat-engine.service
```

#### horizon

[官网](https://docs.openstack.org/horizon/queens/install/)

```sh
# 重启
systemctl restart httpd.service memcached.service
```

#### tacker

[官网](https://docs.openstack.org/tacker/queens/install/)