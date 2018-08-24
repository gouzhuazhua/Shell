# NFS服务器挂载

## 一、服务器端

1. 安装NFS服务

   ```shell
   sudo apt-get install nfs-kernel-server -y
   ```

2. 编辑配置文件/etc/exports

   ```shell
   # 添加以下行
   /data *(rw,sync,no_subtree_check,no_root_squash)
   ```

   关于配置：

   ```shell
   /data   ：共享的目录
   *       ：指定哪些用户可以访问
               *  所有可以ping同该主机的用户
               192.168.1.*  指定网段，在该网段中的用户可以挂载
               192.168.1.12 只有该用户能挂载
   (ro,sync,no_root_squash)：  权限
           ro : 只读
           rw : 读写
           sync :  同步
           no_root_squash: 不降低root用户的权限
       其他选项man 5 exports 查看
   ```

3. 创建共享目录

   ```shell
   sudo mkdir /data
   ```

4. 重启NFS服务

   ```shell
   sudo service nfs-kernel-server restart
   ```

## 二、客户端

1. 安装客户端工具

   ```shell
   sudo apt-get install nfs-common -y
   ```

2. 查看NFS服务器上的共享目录

   ```shell
   sudo showmount -e 192.168.0.17
   ```

3. 创建本地挂载目录

   ```shell
   sudo  mkdir -p /mnt/data
   ```

4. 挂载共享目录

   ```shell
   sudo mount -t nfs 192.168.0.17:/data /mnt/data
   ```

## 三、odoo系统指向nfs挂载目录

- 修改/odoo/odoo.conf文件

  ```shell
  date_dir=/mnt/data
  ```

  

