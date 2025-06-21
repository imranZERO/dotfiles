# https://christitus.com/linux-security-mistakes/
sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

# Local web servers
sudo ufw allow 8000

# localsend - https://forums.linuxmint.com/viewtopic.php?t=408601
sudo ufw allow 53317/tcp

# Unified Remote server
sudo ufw allow 9512/tcp
sudo ufw allow 9512/udp

# KDE Connect Server
sudo ufw allow 1714:1764/tcp
sudo ufw allow 1714:1764/udp

# Navidrome Server
sudo ufw allow 4533
