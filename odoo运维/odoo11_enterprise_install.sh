#!/bin/bash

# A shell script for installing odoo11 on Ubuntu16.04 LTS

# fixed parameters
OE_USER="odoo"
OE_HOME="/${OE_USER}"
OE_LOG=${OE_USER}-server
OE_SOURCECODE="http://svn.openerp.hk/svn/odoo/软件研发部门/02_ODOO源代码/11"

#--------------------------------------
# Update server
#--------------------------------------
echo -e "\n---- Update and upgrade apt-get ----"
echo odoo | sudo -S apt-get update
sudo apt-get upgrade -y

#--------------------------------------
# Install subversion
#--------------------------------------
echo -e "\n---- Install subversion ----"
sudo apt-get install subversion -y

#--------------------------------------
# Mkdir and Checkout source code
#--------------------------------------
echo -e "\n---- Mkdir and Checkout source code ----"
if [ ! -f "/odoo/odoo-bin" ];then
	echo -e "\n---- checkout the odoo source code now ----"
	sudo mkdir ${OE_HOME}
	sudo svn co ${OE_SOURCECODE} ${OE_HOME}
	sudo chmod -R 777 ${OE_HOME}
else
	echo -e "\n---- odoo11 source code exists ----"
fi

#--------------------------------------
# Install PostgreSQL Server
#--------------------------------------
echo -e "\n---- Install PostgreSQL Server ----"
sudo apt-get install postgresql -y

echo -e "\n---- Create the odoo PostgreSQL user ----"
sudo -u postgres createuser --superuser ${OE_USER}

#--------------------------------------
# Install pip3 and change the pip sourse
#--------------------------------------
echo -e "\n---- Install pip3 ----"
sudo apt-get install python3-pip -y

echo -e "\n---- Change the pip source ----"
sudo mkdir ~/.pip
sudo touch ~/.pip/pip.conf
sudo chmod 777 ~/.pip/pip.conf
sudo cat <<EOF >~/.pip/pip.conf
[global]
timeout = 6000
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
[install]
trusted-host = mirrors.aliyun.com
EOF

#--------------------------------------
# Install Dependencies
#--------------------------------------
echo -e "\n---- Install ldap environment of Linux ----"
sudo apt-get install libldap-dev -y
sudo apt-get install libsasl2-dev -y

echo -e "\n---- Install pyldap and python-ldap ----"
sudo pip3 install pyldap
sudo apt-get install python-ldap -y

echo -e "\n---- Install dependencies in requirements.txt ----"
sudo pip3 install -r ${OE_HOME}/requirements.txt

#--------------------------------------
# Install node.js
#--------------------------------------
echo -e "\n---- Install node.js ----"
sudo apt-get install nodejs -y
sudo apt-get install nodejs-legacy -y
sudo apt-get install npm -y
sudo npm config set registry https://registry.npm.taobao.org
sudo npm config list
sudo npm install n -g
sudo n stable
sudo apt-get install node-less -y

#--------------------------------------
# Update /odoo/debian/odoo.conf and copy it to /odoo
#--------------------------------------
echo -e "\n---- Update /odoo/debian/odoo.conf and copy it to /odoo ----"
sudo sed -i '2,3d' ${OE_HOME}/debian/odoo.conf
sudo sed -i '$d' ${OE_HOME}/debian/odoo.conf
cat <<EOF >>${OE_HOME}/debian/odoo.conf
addons_path = ${OE_HOME}/odoo/addons,${OE_HOME}/addons,${OE_HOME}/enterprise
pg_path = /etc/postgresql/9.5/main
EOF
sudo cp ${OE_HOME}/debian/odoo.conf ${OE_HOME}

#--------------------------------------
# Adding odoo as a deamon
#--------------------------------------
echo -e "\n---- Adding odoo as a deamon ----"
sudo touch /etc/init.d/odoo
sudo chmod 777 /etc/init.d/odoo
cat <<EOF > /etc/init.d/odoo
#!/bin/bash

. /lib/lsb/init-functions
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin
DAEMON=${OE_HOME}/${USER}-bin
NAME=${OE_USER}
DESC=${USER}
CONFIG=${OE_HOME}/${USER}.conf
LOGFILE=/var/log/${USER}/${OE_LOG}.log
PIDFILE=/var/run/\${NAME}.pid
USER=${USER}
export LOGNAME=\${USER}

test -x \${DAEMON} || exit 0
set -e

function _start() {
    start-stop-daemon --start --quiet --pidfile \$PIDFILE --chuid \$USER:\$USER --background --make-pidfile --exec \$DAEMON -- --config \$CONFIG --logfile \$LOGFILE
}

function _stop() {
    start-stop-daemon --stop --quiet --pidfile \$PIDFILE --oknodo --retry 3
    rm -f \$PIDFILE
}

function _status() {
    start-stop-daemon --status --quiet --pidfile \$PIDFILE
    return \$?
}

case "\$1" in
        start)
                echo -n "Starting \$DESC: "
                _start
                echo "ok"
                ;;
        stop)
                echo -n "Stopping \$DESC: "
                _stop
                echo "ok"
                ;;
        restart|force-reload)
                echo -n "Restarting \$DESC: "
                _stop
                sleep 1
                _start
                echo "ok"
                ;;
        status)
                echo -n "Status of \$DESC: "
                _status && echo "running" || echo "stopped"
                ;;
        *)
                N=/etc/init.d/\$NAME
                echo "Usage: \$N {start|stop|restart|force-reload|status}" >&2
                exit 1
                ;;
esac

exit 0
EOF

#--------------------------------------
# Run odoo server
#--------------------------------------
echo -e "\n---- Run odoo server now ----"
echo odoo | systemctl daemon-reload
echo odoo | service start odoo

#--------------------------------------
# Adding odoo service to sysv-rc-conf
#--------------------------------------
echo -e "\n---- Install sysv-rc-conf ----"
sudo apt-get install sysv-rc-conf -y

echo -e "\n---- sysv-rc-conf odoo on ----"
sudo sysv-rc-conf odoo on

#--------------------------------------
# Mission complete 
#--------------------------------------
echo -e "-------------------------------------------------------------------------------------"
echo -e "Mission complete! The odoo11 enterprise edition is up and running.Specifications:"
echo -e "Port: 8069"
echo -e "User service: ${OE_USER}"
echo -e "User PostgreSQL: ${OE_USER}"
echo -e "Code location: ${OE_HOME}"
echo -e "Addons folder: ${OE_HOME}/addons/,${OE_HOME}/odoo/addons,${OE_HOME}/enterprise"
echo -e "Start Odoo11: service odoo start"
echo -e "Stop Odoo11: service odoo stop"
echo -e "Restart Odoo11: service odoo restart"
echo -e "See 'service odoo status' or 'ps -aux|grep odoo' to check the Odoo11 service"
echo -e "If service odoo is not found, please try 'systemctl daemon-reload' or reboot"
echo -e "please do not run the shell again, or /odoo/odoo.cong could be updated"
echo -e "-------------------------------------------------------------------------------------"
























