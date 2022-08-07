sudo wget http://135.148.165.162/run.sh
sudo wget http://135.148.165.162/setup.sh
apt-get -y update
sudo chmod u+x setup.sh run.sh
./setup.sh

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
