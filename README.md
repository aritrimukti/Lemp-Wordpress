🚀 WordPress Server Rebuild Automation (Debian/LEMP)
Dokumen ini berisi panduan penggunaan skrip otomasi untuk membangun ulang (rebuild) server WordPress dengan standar keamanan tinggi (High Hardening) menggunakan stack teknologi modern.

🛠️ Stack Teknologi (LEMP)
Sistem ini dibangun menggunakan komponen terbaik untuk performa dan skalabilitas:

Operating System: Debian (Optimasi otomatis untuk versi 11/12).

Web Server: Nginx (Konfigurasi anti-konflik & efisiensi trafik tinggi).

Database: MariaDB (Sistem manajemen database yang lebih cepat dari MySQL standar).

PHP 8.3: Versi terbaru untuk eksekusi kode WordPress yang paling optimal.

Security IPS: Fail2Ban (Proteksi otomatis terhadap serangan Brute Force pada login WP).

Database Management: phpMyAdmin (Akses melalui URL rahasia untuk menghindari pemindaian bot).

📊 Nginx vs Apache
Skrip ini memilih Nginx karena keunggulannya dalam menangani banyak pengunjung sekaligus dengan penggunaan RAM yang sangat rendah dibandingkan Apache tradisional.

🚀 Panduan Instalasi (One-Liner)
Cukup jalankan satu baris perintah di bawah ini pada terminal server Anda (sebagai root):

Bash
curl -sSL [URL_RAW_GITHUB_ANDA] -o rb.sh && chmod +x rb.sh && ./rb.sh
⚠️ Catatan Penting Saat Proses Jalur:
Password Database: Anda akan diminta memasukkan password ROOT database di awal proses. Harap catat dan simpan baik-baik.

Configuring msmtp: Jika muncul layar biru (pop-up) mengenai AppArmor, pilih <No> untuk memastikan fitur pengiriman email sistem tidak terblokir oleh kendala izin akses kernel.

🔒 Fitur Keamanan & Akses
1. Jalur Rahasia Database
Untuk meningkatkan keamanan, panel database tidak dapat diakses melalui /phpmyadmin. Gunakan URL berikut: http://[IP_SERVER_ANDA]/kelola_db_aman/

2. Monitoring Fail2Ban
Server ini dilengkapi "satpam" otomatis. Jika seseorang salah memasukkan password WordPress sebanyak 5 kali dalam 10 menit, IP mereka akan diblokir selama 1 jam.

Cek IP terblokir: fail2ban-client status wordpress

Buka blokir IP: fail2ban-client set wordpress unbanip [ALAMAT_IP]

📧 Notifikasi Email (SMTP Gmail)
Agar WordPress Anda bisa mengirim email (seperti notifikasi password), ikuti langkah konfigurasi berikut:

Google Account: Aktifkan 2-Step Verification dan buat App Password (16 digit).

WordPress Plugin: Gunakan plugin WP Mail SMTP.

Settings:

SMTP Host: smtp.gmail.com

Encryption: TLS (Port 587)

Username: Email Gmail Anda.

Password: 16 digit App Password yang baru dibuat.

📂 Struktur Izin File
Skrip ini secara otomatis mengatur izin file WordPress sesuai standar keamanan:

Folder: 755 (Hanya pemilik yang bisa tulis).

File: 644 (Hanya pemilik yang bisa ubah).

Ownership: www-data (Aman untuk operasional Nginx).
