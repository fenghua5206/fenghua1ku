#!/bin/bash

#######  一键配置yum源  ########
cd /etc/yum.repos.d/
mkdir repo &>/dev/null
mv -f * repo &>/dev/null
#配置本地源
echo -e  "[localdisk]\nname=local disk Centos7\nbaseurl=file:///mnt\nenabled=1\ngapcheck=0 " > localdisk.repo
echo "本地源配置完成。"
##############配置网络源：阿里源、epel源
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo &>/dev/null
echo "阿里源配置完成。"
yum -y install wget &>/dev/null
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo &>/dev/null
echo "epel源配置完成。"
##本地源下载速度快，当本地源无法满足下载需求时，再将CentOS-Base.repo、epel.repo移出
mv -f CentOS-Base.repo epel.repo repo &>/dev/null


#######  一键配置静态IP  #######
cat > /etc/sysconfig/network-scripts/ifcfg-ens33 <<EOF
TYPE=Ethernet
DEVICE=ens33
BOOTPROTO=none
ONBOOT=yes
NETBOOT=yes
IPADDR=192.168.75.$1
PREFIX=24
GATEWAY=192.168.75.2
DNS1=114.114.114.114
DNS2=8.8.8.8
EOF
systemctl restart network
hostnamectl set-hostname $2
