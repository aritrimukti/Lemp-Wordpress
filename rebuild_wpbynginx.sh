#!/bin/bash
# =================================================================
# REBUILD_WPBYNGINX.SH (FINAL STABLE VERSION)
# =================================================================

# Validasi Root
if [ "$EUID" -ne 0 ]; then 
  echo "Harus dijalankan sebagai root (sudo)!"
  exit
fi

echo "==============================================================="
echo "   REBUILD SERVER WORDPRESS - MODE AMAN (DEBIAN)"
echo "==============================================================="
read -sp "Tentukan Password ROOT Database Baru: " DB_PASSWORD
echo -e "\n"
read -p "Masukkan Email Admin untuk Notifikasi: " ADMIN_EMAIL
echo "==============================================================="

# --- 1. CLEANING ---
echo "[1/6] Menghapus data lama & membersihkan repositori rusak..."
systemctl stop nginx mariadb php*-fpm fail2ban 2>/dev/null
apt purge nginx* mariadb* php8.3* phpmyadmin* fail2ban* -y
apt autoremove -y && apt autoclean
rm -rf /var/www/html/* /etc/nginx /etc/mysql /var/lib/mysql /etc/php /usr/share/phpmyadmin /etc/fail2ban
rm -f /etc/apt/sources.list.d/php.list

# --- 2. REPOSITORY SETUP ---
echo "[2/6] Mengonfigurasi Repositori PHP 8.3..."
apt update && apt install -y ca-certificates apt-transport-https gnupg2 curl lsb-release
DEB_VERSION=$(. /etc/os-release && echo "$VERSION_CODENAME")
[ -z "$DEB_VERSION" ] && DEB_VERSION=$(lsb_release -sc)

curl -sSL https://packages.sury.org/php/apt.gpg | gpg --dearmor --yes -o /usr/share/keyrings/php-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/php-archive-keyring.gpg] https://packages.sury.org/php/ $DEB_VERSION main" > /etc/apt/sources.list.d/php.list

apt update

# --- 3. INSTALLATION ---
echo "[3/6] Memasang paket LEMP (PHP 8.3), Fail2Ban & Email Tool..."
apt install nginx mariadb-server php8.3-fpm php8.3-mysql php8.3-gd php8.3-curl php8.3-mbstring php8.3-xml php8.3-zip fail2ban msmtp msmtp-mta -y

# --- 4. DATABASE CONFIG ---
echo "[4/6] Mengonfigurasi MariaDB..."
systemctl start mariadb
mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('$DB_PASSWORD');"
mariadb -e "CREATE DATABASE IF NOT EXISTS wordpress;"
mariadb -e "FLUSH PRIVILEGES;"

# --- 5. NGINX & SECURITY HARDENING ---
echo "[5/6] Mengonfigurasi Nginx (Mengarahkan IP ke Home WordPress)..."
mkdir -p /etc/nginx/sites-available
sed -i 's/# server_tokens off;/server_tokens off;/' /etc/nginx/nginx.conf

cat > /etc/nginx/sites-available/default <<EOF
server {
    listen 80;
    server_name _;
    root /var/www/html;
    index index.php index.html index.htm;

    # Hardening: Blokir query berbahaya
    if (\$query_string ~ "base64_encode.*\(.*\)") { return 403; }
    if (\$query_string ~ "GLOBALS(=|\[|\%[0-9A-Z]{0,2})") { return 403; }

    # PHP-MYADMIN RAHASIA
    location /kelola_db_aman {
        root /var/www/html;
        index index.php index.html;
        location ~ ^/kelola_db_aman/(.+\.php)$ {
            root /var/www/html;
            fastcgi_pass unix:/run/php/php8.3-fpm.sock;
            include snippets/fastcgi-php.conf;
        }
    }

    # WORDPRESS HOME (Mengarahkan IP agar tidak terdownload)
    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    # PHP PROCESSING
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
    }

    location = /xmlrpc.php { deny all; }
    location ~ /\.ht { deny all; }
    location /wp-content/uploads/ { location ~ \.php$ { deny all; } }
}
EOF

# Fail2Ban Config
mkdir -p /etc/fail2ban/filter.d
cat > /etc/fail2ban/filter.d/wordpress.conf <<EOF
[Definition]
failregex = ^<HOST>.*POST.*(wp-login\.php|xmlrpc\.php).* 200
EOF
cat > /etc/fail2ban/jail.local <<EOF
[wordpress]
enabled = true
port = http,https
filter = wordpress
logpath = /var/log/nginx/access.log
maxretry = 5
findtime = 600
bantime = 3600
EOF

# --- 6. WORDPRESS & PHPMYADMIN INSTALL ---
echo "[6/6] Memasang WordPress & phpMyAdmin..."
export DEBIAN_FRONTEND=noninteractive
echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | debconf-set-selections
apt install phpmyadmin -y

ln -s /usr/share/phpmyadmin /var/www/html/kelola_db_aman 2>/dev/null

cd /var/www/html
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz && cp -R wordpress/* . && rm -rf wordpress latest.tar.gz

# Izin File
chown -R www-data:www-data /var/www/html/
find /var/www/html/ -type d -exec chmod 755 {} \;
find /var/www/html/ -type f -exec chmod 644 {} \;

systemctl restart nginx php8.3-fpm fail2ban

# --- RINGKASAN DATA AKHIR ---
echo -e "\n"
echo "==============================================================="
echo "             RINGKASAN DATA (SIMPAN & CATAT!)"
echo "==============================================================="
echo " STATUS          : INSTALASI BERHASIL"
echo " IP SERVER       : $(hostname -I | awk '{print $1}')"
echo " URL DB RAHASIA  : http://$(hostname -I | awk '{print $1}')/kelola_db_aman"
echo " USER DATABASE   : root"
echo " PASS DATABASE   : $DB_PASSWORD"
echo " EMAIL ADMIN     : $ADMIN_EMAIL"
echo "==============================================================="
