# L[A|N]MP环境部署

## 一、安装前准备

1. 下载一键安装包
2. 安装screen
3. root权限

## 二、开始安装

- 以下操作均在root权限下完成

  ```shell
  # 安装screen
  apt-get install screen -y
  
  # 获取源码
  wget http://mirrors.linuxeye.com/lnmp-full.tar.gz
  tar -xzf lnmp-full.tar.gz
  cd lnmp
  
  # 开始安装
  screen -S lamp
  ./install.sh
  ```

- 安装过程中根据需求选择环境

## 三、创建虚拟主机

```shell
# 使用一键安装包工具创建虚拟主机
cd /lnmp
./vhost

# 修改Apache配置
vim /usr/local/apache/conf/httpd.conf
# 1，添加监听端口，须与虚拟主机端口一致
Listen 8088
# 修改虚拟主机配置文件
vim /usr/local/apache/conf/vhost/www.example.com.conf
# 2，修改虚拟主机端口
<VirtualHost *:8088>
#,3，修改源码目录(两处)
DocumentRoot "/data/wwwroot/www.example.com"
<Directory "/data/wwwroot/www.88.com">
```

访问虚拟主机：http://ip:port

## 四、其他

- lamp一键安装包教程原地址：[lnmp、lamp、lnmpa一键安装包（Updated: 2018-03-18）](https://blog.linuxeye.cn/31.html)
- 此文档是在`Ubuntu 16.04 LTS`基础上编写