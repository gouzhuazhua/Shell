# frp内网穿透部署

## 一、安装前准备

server端：

- /opt/frp-server/frps 脚本
- /opt/frp-server/frps.ini 配置文件
- /etc/init.d/frps 服务脚本

client端：

- /opt/frp-client/frpc 脚本
- /opt/frp-client/frpc.server.ini 配置文件
- /opt/frp-client/frpc.ssh.ini 配置文件
- /etc/init.d/frpc-server 服务脚本
- /etc/init.d/frpc-ssh 服务脚本

## 二、开始安装

### 1、server端安装

- 创建/opt/frp-server文件夹,把frps和frps.ini拷贝进去，根据需要更改ini文件的配置信息

  ```shell
  mkdir /opt/frp-server
  rz
  touch frps.log
  chmod 775 frps
  chmod 664 frps.*
  ```

- 将frps服务脚本拷贝到/etc/init.d/目录下

  ```shell
    rz
    chmod 775 frps
    service frps start
  ```

- 将服务加入开机启动

  ```shell
  sysv-rc-conf frps on
  ```

### 2、client端

- 创建/opt/frp-clients文件夹，把frpc、frpc.server.ini和frpc.ssh.ini拷贝进去，根据需要更改ini文件的配置信息 

  ```shell
  mkdir /opt/frp-clients
  sz
  touch frpc.log
  chmod 775 frpc
  chmod 664 frpc.*
  ```

- 将frpc-server和frpc-ssh服务脚本拷贝到/etc/init.d/目录下 

  ```shell
  rz
  chmod 775 frpc*
  service frpc-server start
  service frpc-ssh start
  ```

- 将服务加入开机启动

  ```shell
    sysv-rc-conf frpc-server on
    sysv-rc-conf frpc-ssh on
  ```

## 三、可能存在的问题

1. 安装sysv-rc-conf失败

   - 出现”软件包cups-daemon尚未配置”错误，解决方法：重新创建/var/lib/dpkg/info/文件夹

     ```shell
     sudo mv /var/lib/dpkg/info/ /var/lib/dpkg/info_backup/
     sudo mkdir /var/lib/dpkg/info/
     ```

## 四、关于配置信息

1. 每个服务器上的配置文件应该都不一样，需要为每个服务器定制ini配置文件
   - 注意根据服务器定制**server_addr**、**auth_token**和**服务名**[server@servername]
2. server端的ini里存有所有client端的标记信息