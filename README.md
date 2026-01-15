---

# 🚀 WordPress Server Rebuild Automation (Debian/LEMP)

Skrip ini dirancang untuk melakukan pembangunan ulang (*rebuild*) server WordPress secara otomatis pada distro berbasis **Debian**. Fokus utama skrip ini adalah kecepatan instalasi, penggunaan stack modern, dan penguatan keamanan (*Hardening*).

## 🛠️ Stack Teknologi (LEMP)

Sistem ini menggunakan kombinasi perangkat lunak terbaik untuk menjamin performa tinggi:

* **Operating System:** Debian (Optimal untuk versi 11/12).
* **Web Server:** Nginx (Konfigurasi anti-konflik, ringan, dan cepat).
* **Database:** MariaDB (Sistem manajemen database yang dioptimalkan untuk performa Linux).
* **PHP 8.3:** Versi terbaru untuk eksekusi kode WordPress yang lebih efisien dan aman.
* **Security:** Fail2Ban (Perlindungan otomatis terhadap serangan *Brute Force* login).
* **Management:** phpMyAdmin (Akses database melalui URL rahasia).

---

## 🚀 Cara Penggunaan (One-Liner)

Jalankan perintah berikut di terminal server Anda dengan hak akses **root**:

```bash
curl -sSL [MASUKKAN_URL_RAW_GITHUB_ANDA] -o rb.sh && chmod +x rb.sh && ./rb.sh

```

### ⚠️ Catatan Penting Saat Instalasi:

1. **Password Database:** Anda akan diminta menentukan password ROOT database di awal skrip. Pastikan untuk mencatatnya.
2. **Konfigurasi msmtp:** Jika muncul dialog biru mengenai **AppArmor**, sangat disarankan untuk memilih **`<No>`**. Hal ini bertujuan agar sistem pengiriman email WordPress tidak terhambat oleh pembatasan izin akses kernel yang terlalu ketat.

---

## 🔒 Fitur Keamanan Unggulan

### 1. URL Database Rahasia

Untuk menghindari serangan otomatis dari bot peretas, akses database tidak menggunakan jalur standar `/phpmyadmin`. Gunakan URL berikut:
`http://[IP_SERVER_ANDA]/kelola_db_aman/`

### 2. Nginx Hardening

Skrip secara otomatis mengonfigurasi Nginx untuk:

* Menyembunyikan versi server (*server_tokens off*).
* Memblokir query berbahaya (seperti *base64_encode* atau *GLOBALS*).
* Mencegah eksekusi file PHP di folder unggahan (*wp-content/uploads*).

### 3. Proteksi Fail2Ban

Server dilengkapi deteksi serangan login otomatis. Jika terdapat 5 kegagalan login dalam waktu 10 menit, IP penyerang akan diblokir selama 1 jam.

* **Cek status blokir:** `fail2ban-client status wordpress`
* **Buka blokir IP:** `fail2ban-client set wordpress unbanip [ALAMAT_IP]`

---

## 📧 Notifikasi Email (SMTP Gmail)

Agar fitur kirim email dari WordPress (seperti lupa password) berfungsi:

1. Gunakan plugin **WP Mail SMTP** di Dashboard WordPress.
2. Konfigurasi menggunakan **App Password** Google (16 digit) dengan metode enkripsi **TLS** pada port **587**.

---

## 📂 Manajemen Izin File

Skrip mengatur izin file secara otomatis agar aman namun tetap fungsional:

* **Folder:** `755`
* **File:** `644`
* **Ownership:** `www-data`

---

**Status Skrip:** Stable - Optimized for Debian 11/12
