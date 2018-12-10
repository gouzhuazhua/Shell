#!/bin/bash


echo -e "\n--------- 继续安装锐速 ---------"
echo -e "\n--------- 2.安装锐速 ---------"
sudo wget -N --no-check-certificate https://raw.githubusercontent.com/91yun/serverspeeder/master/serverspeeder-all.sh && bash serverspeeder-all.sh
echo -e "\n--------- 启动锐速 ---------"
sudo service serverSpeeder start
echo -e "\n--------- 锐速启动成功 ---------"
echo -e "\n--------- 锐速安装完成 ---------"


echo -e "\n--------- 开启防火墙端口 ---------"
firewalld-cmd --zone=public --add-port=8388/tcp --permanent
firewall-cmd --zone=public --add-port=8388/tcp --permanent
firewall-cmd --zone=public --add-port=8389/tcp --permanent
firewall-cmd --zone=public --add-port=8390/tcp --permanent
firewall-cmd --zone=public --add-port=8391/tcp --permanent
echo -e "\n--------- 防火墙端口开启成功 ---------"


echo -e "\n--------- 启动ShadowSocks系统服务 ---------"
sudo systemctl daemon-reload
sudo systemctl enable ssserver
sudo systemctl start ssserver
sudo systemctl restart ssserver
echo -e "\n--------- ShadowSocks系统服务启动成功 ---------"

echo -e "\n--------- ShadowSocks安装完成！ ---------"
echo -e "\n-ShadowSocks配置文件目录：/etc/shadowsocks.json"
echo -e "\n-ShadowSocks使用命令：systemctl start/stop/restart/status ssserver"
echo -e "\n---------------- end -------------------"