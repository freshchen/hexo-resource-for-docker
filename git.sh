#!/bin/bash
git pull || exit 1
git add .
if [ $1 ];then
    git commit -m "$*";
else
    git commit -m "update"
fi
git push origin master

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
