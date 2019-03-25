# hexo-resource-for-docker

为了避免换电脑，将hexo源码做成了docker镜像，监听此仓库的改动，自动部署




[Unit]
After=network.target

[Service]
User=root
Type=simple
ExecStart=/bin/bash -xc 'nc -l 0.0.0.0 17732 && docker run --rm <github name>/hexo:blog sh /home/hexo/script/update-blog.sh > /var/log/update-hexo.log 2>&1 '
Restart=always
RestartSec=5
StartLimitInterval=1min
StartLimitBurst=60

[Install]
WantedBy=multi-user.target