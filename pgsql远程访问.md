# pgsql远程访问

安装完postgres后，默认只能本机访问数据库，下面通过配置实现远程访问postgresql。 

1. 在安装目录下找到pg_hba.conf文件，使用vim打开并定位到如下文本

   ```shell
   # TYPE  DATABASE        USER            ADDRESS                 METHOD
   
   # "local" is for Unix domain socket connections only
   local   all             all                                     peer
   # IPv4 local connections:
   host    all             all             127.0.0.1/32            md5
   # IPv6 local connections:
   host    all             all             ::1/128                 md5
   ```

   在IPv4连接下添加一行文本

   ```shell
   # 这行记录代表允许192.168.0.86主机访问该数据库
   host    all             all             192.168.0.85/32         md5
   ```

   修改后pg_hba.conf文件如下

   ```shell
   # TYPE  DATABASE        USER            ADDRESS                 METHOD
   
   # "local" is for Unix domain socket connections only
   local   all             all                                     peer
   # IPv4 local connections:
   host    all             all             127.0.0.1/32            md5
   host    all             all             192.168.0.85/32         md5
   # IPv6 local connections:
   host    all             all             ::1/128                 md5
   
   ```

2. 在pg_hba.conf文件同级目录下找到postgresql.cong文件，使用vim打开并定位到如下文本

   ```shell
   #listen_addresses = 'localhost'         # what IP address(es) to listen on;
                                           # comma-separated list of addresses;
                                           # defaults to 'localhost'; use '*' for all
                                           # (change requires restart)
   port = 5432                             # (change requires restart)
   ```

   修改listen_addresses行如下

   ```shell
   listen_addresses = '*'         # what IP address(es) to listen on;
                                           # comma-separated list of addresses;
                                           # defaults to 'localhost'; use '*' for all
                                           # (change requires restart)
   port = 5432                             # (change requires restart)
   ```

3. 重启postgresql服务

   ```shell
   service postgresql restart
   ```

4. 其他

   - 影响设置限制访问的关键在pg_hba.conf中的**ADDRESS**，地址段中的后一部分如32代表子网掩码，具体情况如下：

     32 -> 192.168.1.1/32 表示必须是来自这个IP地址的访问才合法； 

     24 -> 192.168.1.0/24 表示只要来自192.168.1.0 ~ 192.168.1.255的都合法； 

     16 -> 192.168.0.0/16 表示只要来自192.168.0.0 ~ 192.168.255.255的都合法； 

     8   -> 192.0.0.0/16 表示只要来自192.0.0.0 ~ 192.255.255.255的都合法； 

     0   -> 0.0.0.0/0 表示全部IP地址都合法，/左边的IP地址随便了只要是合法的IP地址即可； 

     如何设置根据实际情况决定。

5. **odoo系统远程连接pgsql**

   修改/odoo/odoo.conf文件

   ```shell
   db_host = 192.168.0.17
   db_port = 5432
   db_user = pgsql_username
   db_password = pgsql_passwd
   ```

   