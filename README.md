create /usr/local/bin/daemon_container.sh
create /etc/systemd/system/docker-monitor.service

sudo systemctl daemon-reload
sudo systemctl start docker-monitor.service
sudo systemctl stop docker-monitor.service
sudo systemctl restart docker-monitor.service
sudo systemctl enable docker-monitor.service
