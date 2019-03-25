#!/bin/bash
git pull || exit 1
git add .
git commit -m $1
git push origin master
:wq

# 主机上的systemd文件如下
#[Unit]
#After=network.target

#[Service]
#User=root
#Type=simple
#ExecStart=/bin/bash -xc 'nc -l 0.0.0.0 17732 && docker run --rm <github name>/hexo:blog sh /home/hexo/script/update-blog.sh > /var/log/update-hexo.log 2>&1 '
#Restart=always
#RestartSec=5
#StartLimitInterval=1min
#StartLimitBurst=60

#[Install]
#WantedBy=multi-user.target
