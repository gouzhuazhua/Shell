#!/bin/bash


echo -e "\n--------- 开始安装依赖包 ---------"
sudo yum -y install wget curl curl-devel zlib-devel openssl-devel perl perl-devel cpio expat-devel gettext-devel git autoconf libtool gcc swig python-devel
echo -e "\n--------- 依赖包安装完成 -------------"


echo -e "\n--------- 开始安装setuptools ---------"
echo -e "\n--------- 下载setuptools到/usr/local/src/ ---------"
cd /usr/local/src
echo -e "\n--------- 开始下载setuptools ---------"
sudo wget --no-check-certificate  https://pypi.python.org/packages/source/s/setuptools/setuptools-19.6.tar.gz#md5=c607dd118eae682c44ed146367a17e26
echo -e "\n--------- 完成下载setuptools，解压到当前目录 ---------"
sudo tar -zvxf setuptools-19.6.tar.gz
echo -e "\n--------- 解压完成 ---------"
echo -e "\n--------- 进入目录安装 ---------"
cd setuptools-19.6
sudo python2.7 setup.py build
cd /
echo -e "\n--------- setuptools安装完成 ---------"


echo -e "\n--------- 开始安装pip ---------"
sudo yum -y install epel-release
sudo yum -y install pip python-pip
echo -e "\n--------- pip安装完成 ---------"
echo -e "\n--------- 更新pip ---------"
sudo pip install --upgrade pip
echo -e "\n--------- pip更新完成 ---------"


echo -e "\n--------- 开始安装ShadowSocks ---------"
sudo pip install shadowsocks
echo -e "\n--------- ShadowSocks安装完成 ---------"


echo -e "\n--------- 创建ShadowSocks配置文件 ---------"
sudo touch /etc/shadowsocks.json
sudo cat <<EOF >/etc/shadowsocks.json
{
"server": "45.77.5.105",
"port_password": {
"8388": "update_password_here",
"8389": "update_password_here",
"8390": "update_password_here",
"8391": "update_password_here"
},
"timeout":30,
"method":"aes-256-cfb",
"fast_open": false
}
EOF
echo -e "\n--------- ShadowSocks配置文件创建完成 ---------"


echo -e "\n--------- 创建ShadowSocks系统服务 ---------"
sudo touch /etc/systemd/system/ssserver.service
sudo cat <<EOF >/etc/shadowsocks.json
[Unit]
Description=ssserver
[Service]
TimeoutStartSec=0
ExecStart=/usr/bin/ssserver -c /etc/shadowsocks.json
[Install]
WantedBy=multi-user.target
EOF
echo -e "\n--------- ShadowSocks系统服务创建完成 ---------"


echo -e "\n--------- 开始安装锐速 ---------"
echo -e "\n--------- 1.开始降低系统内核版本 ---------"
echo -e "\n--------- 注意：完成此步骤后会自动重启！ ---------"
echo -e "\n--------- 重启后请运行ruisu_install.sh ---------"
cd /opt/
sudo wget --no-check-certificate https://blog.asuhu.com/sh/ruisu.sh
sudo bash ruisu.sh
wget --no-check-certificate -O appex.sh https://raw.githubusercontent.com/0oVicero0/serverSpeeder_Install/master/appex.sh && chmod +x appex.sh && bash appex.sh install










