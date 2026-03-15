# https://christitus.com/linux-security-mistakes/
sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Local web servers
sudo ufw allow 8000

# Syncthing
sudo ufw allow 22000/tcp
sudo ufw allow 22000/udp
sudo ufw allow 21027/udp

# iperf3
sudo ufw allow 5201

# localsend - https://forums.linuxmint.com/viewtopic.php?t=408601
sudo ufw allow 53317/tcp

# Jellyfin Server
sudo ufw allow 8096

# Navidrome Server
sudo ufw allow 4533

# KDE Connect Server
sudo ufw allow 1714:1764/tcp
sudo ufw allow 1714:1764/udp

# Unified Remote server
sudo ufw allow 9512/tcp
sudo ufw allow 9512/udp

# Waydroid
sudo ufw allow 67
sudo ufw allow 53
sudo ufw default allow FORWARD

sudo ufw enable
