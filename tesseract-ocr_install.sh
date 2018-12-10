#!/bin/bash


echo -e "\n--------- 克隆tesseract-ocr ------------"
sudo yum -y install git
sudo git clone https://github.com/tesseract-ocr/tesseract.git ./tesseract-ocr
echo -e "\n--------- tesseract-ocr克隆完成，源码目录：/opt/tesseract-ocr/ ---------"


echo -e "\n--------- 安装g++ ------------"
sudo yum -y install gcc gcc-c++ make
echo -e "\n--------- g++安装完成 ---------"


echo -e "\n--------- 安装依赖包 ------------"
sudo yum -y install autoconf automake libtool
sudo yum -y install libjpeg-devel libpng-devel libtiff-devel zlib-devel
echo -e "\n--------- 依赖包安装完成 ---------"


echo -e "\n--------- 安装leptonica ------------"
cd /opt/
wget http://www.leptonica.org/source/leptonica-1.76.0.tar.gz
tar -xzvf leptonica-1.76.0.tar.gz
cd /opt/leptonica-1.76.0/
sudo ./configure
sudo make
sudo make install

sudo cat <<EOF >/etc/profile
exportLD_LIBRARY_PATH=$LD_LIBRARY_PAYT:/usr/local/lib
export LIBLEPT_HEADERSDIR=/usr/local/include
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
EOF

source /etc/profile
echo -e "\n--------- leptonica安装完成，源码目录：/opt/leptonica-1.76.0/ ---------"


echo -e "\n--------- 安装tesseract-ocr ------------"
cd /opt/tesseract-ocr/
sudo ./autogen.sh
sudo ./configure
sudo make && make install
echo -e "\n--------- tesseract-ocr安装完成 ---------"


echo -e "\n--------- 安装tesseract-ocr语言包 ------------"
sudo export TESSDATA_PREFIX=/usr/local/share/
cd $TESSDATA_PREFIX/tessdata
sudo for font in chi_sim chi_tra eng ;do wget https://github.com/tesseract-ocr/tessdata/raw/master/$font.traineddata;done
echo -e "\n--------- tesseract-ocr语言包安装完成 ---------"


echo -e "\n--------- 安装pytesseract ------------"
sudo pip install pytesseract
echo -e "\n--------- pytesseract安装完成 ---------"
























