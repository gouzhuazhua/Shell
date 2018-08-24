# !/bin/bash

echo -e "\n--------- Nginx prot 80 service ---------"

echo -e "\n--------- Update apt-get ----------------"
sudo apt-get update

echo -e "\n--------- Install nginx -----------------"
sudo apt-get install nginx -y

echo -e "\n--------- Start nginx servic-----------------"
service nginx start

echo -e "\n--------- Update the conf.d -------------"
sudo touch /etc/nginx/conf.d/nginx80.conf
sudo chmod 777 /etc/nginx/conf.d/nginx80.conf
cat <<EOF > /etc/nginx/conf.d/nginx80.conf
server {
	listen 80;
	server_name 127.0.0.1;
	
	location / {
		proxy_pass http://127.0.0.1:8069;
	}
}
EOF

echo -e "\n--------- Update nginx.conf--------------"
sudo sed -i '62 s/^/#/' /etc/nginx/nginx.conf

echo -e "\n--------- Reload nginx ------------------"
sudo nginx -s reload

echo -e "\n-----------------------------------------"
echo -e "Mission complete! Now port 80 is listenning port 8069."
echo -e "\n-----------------------------------------"
