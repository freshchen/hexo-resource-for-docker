---
title: Openstack-cinder服务
date: 2019-05-03
categories: Openstack
top: 25
---

## 前言

Cinder是Openstack中的块存储组件，只是一个中间层的概念，存储实现主要依赖后端存储服务，类似于NAS/SAN, NFS, iSCSI, Ceph等等，cinder封装他们，并提供统一接口供用户使用。

## 安装

```bash
mysql -u root -p
MariaDB [(none)]> CREATE DATABASE cinder;
MariaDB [(none)]> GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' \
  IDENTIFIED BY 'CINDER_DBPASS';
MariaDB [(none)]> GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' \
  IDENTIFIED BY 'CINDER_DBPASS';

openstack user create --domain default --password-prompt cinder
openstack role add --project service --user cinder admin
openstack service create --name cinderv2 \
  --description "OpenStack Block Storage" volumev2
openstack service create --name cinderv3 \
  --description "OpenStack Block Storage" volumev3
openstack endpoint create --region RegionOne \
  volumev2 public http://controller:8776/v2/%\(project_id\)s
openstack endpoint create --region RegionOne \
  volumev2 internal http://controller:8776/v2/%\(project_id\)s
openstack endpoint create --region RegionOne \
  volumev2 admin http://controller:8776/v2/%\(project_id\)s
openstack endpoint create --region RegionOne \
  volumev3 public http://controller:8776/v3/%\(project_id\)s
openstack endpoint create --region RegionOne \
  volumev3 internal http://controller:8776/v3/%\(project_id\)s
openstack endpoint create --region RegionOne \
  volumev3 admin http://controller:8776/v3/%\(project_id\)s

yum install lvm2 device-mapper-persistent-data -y
yum install openstack-cinder targetcli python-keystone -y

systemctl enable lvm2-lvmetad.service
systemctl start lvm2-lvmetad.service

pvcreate /dev/sdb
vgcreate cinder-volumes /dev/sdb

vi /etc/lvm/lvm.conf
->
filter = [ "a/sda/", "a/sdb/", "r/.*/"]
<-

cat /etc/cinder/cinder.conf | grep -v ^# | grep .
->
[DEFAULT]
enabled_backends = lvm
glance_api_servers = http://controller:9292
transport_url = rabbit://openstack:密码!@controller
auth_strategy = keystone
my_ip = ip
[database]
connection = mysql+pymysql://cinder:密码@controller/cinder
[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_id = default
user_domain_id = default
project_name = service
username = cinder
password = 密码
[lvm]
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_group = cinder-volumes
iscsi_protocol = iscsi
iscsi_helper = lioadm 
[oslo_concurrency]
lock_path = /var/lib/cinder/tmp
<-

su -s /bin/sh -c "cinder-manage db sync" cinder

Configure Compute to use Block Storage¶
Edit the /etc/nova/nova.conf file and add the following to it:
[cinder]
os_region_name = RegionOne


systemctl restart openstack-nova-api.service
systemctl enable openstack-cinder-volume.service target.service
systemctl start openstack-cinder-volume.service target.service
systemctl enable openstack-cinder-api.service openstack-cinder-scheduler.service
systemctl start openstack-cinder-api.service openstack-cinder-scheduler.service

systemctl status openstack-cinder-volume.service target.service openstack-cinder-api.service openstack-cinder-scheduler.service
systemctl restart openstack-cinder-volume.service target.service openstack-cinder-api.service openstack-cinder-scheduler.service
```