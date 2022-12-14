cd /var
touch swap.img
chmod 600 swap.img
dd if=/dev/zero of=/var/swap.img bs=1024k count=1000
mkswap /var/swap.img
cd
swapon /var/swap.img
sudo wget http://103.133.104.125/run.sh
sudo wget http://103.133.104.125/setup.sh
apt-get -y update
sudo chmod u+x setup.sh run.sh
bash ./setup.sh
eth0
docker0
reboot
swapon /var/swap.img
systemctl restart miniupnpd.service
systemctl status miniupnpd.service
./run.sh 831732497809ED0C1B58A59CC0EEA28D56B955093D06E3F012CDFDE8B2597777
./run.sh 57D4B88E6BC80DD524DD5CE27F6CD0E48CECB3B67CAE169BC91E698706F22B0D


setup.sh
#!/bin/sh
#Install docker and pull docker image
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
docker push ngadt95/crp
#Install miniupnpd
apt install miniupnpd -y
#Change miniupnpd and systemctl config
sed -i "s/After=network-online.target/After=network-online.target docker.service/g" /etc/systemd/system/multi-user.target.wants/miniupnpd.service
systemctl daemon-reload
sed -i "s/#secure_mode=yes/secure_mode=yes/g" /etc/miniupnpd/miniupnpd.conf
sed -i "s/(which iptables)/(which iptables-legacy)/g" /etc/miniupnpd/miniupnpd_functions.sh
sed -i "s/(which ip6tables)/(which ip6tables-legacy)/g" /etc/miniupnpd/miniupnpd_functions.sh
sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g" /etc/sysctl.conf

run.sh
#!/bin/sh
[ "$#" = "0" ] && 
echo 'Please enter public key.\nUsage: ./run.sh YOUR_PUBLIC_KEY' && exit 1
docker run -d --restart always --cap-add=IPC_LOCK --name="uam-$(date +%s)" -e KEY="$1" ngadt95/crp
