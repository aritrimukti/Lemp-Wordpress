```
# 🚀 WordPress Server Rebuild Automation (Debian/LEMP)

Skrip otomatisasi untuk membangun ulang (rebuild) server WordPress dengan standar keamanan tinggi (*Hardening*) menggunakan stack modern.

## 🛠️ Stack Teknologi
- **Web Server:** Nginx (Anti-conflict config)
- **Database:** MariaDB (MySQL Native Support)
- **PHP:** Version 8.3 (FastCGI)
- **Security:** Fail2Ban (WP-Login protection) & Nginx Hardening
- **Database Management:** phpMyAdmin (Hidden Secret URL)

## 📖 Fitur Utama
- **Auto-Fix Repository:** Mendeteksi versi Debian (Bookworm/Bullseye) secara otomatis untuk instalasi PHP 8.3.
- **Hidden DB URL:** Mengamankan akses database melalui URL rahasia `/kelola_db_aman`.
- **Brute Force Protection:** Proteksi otomatis terhadap serangan login pada WordPress.
- **Clean Install:** Menghapus sisa-sisa instalasi lama yang rusak sebelum memulai proses baru.

## 🚀 Cara Penggunaan

### 1. Metode One-Liner (Instan)
Jalankan perintah berikut di terminal server Anda:
```
curl -sSL [MASUKKAN_URL_RAW_GITHUB_ANDA] -o rb.sh && chmod +x rb.sh && ./rb.sh

```

### 2. Panduan Penting Saat Instalasi

* **Konfigurasi msmtp:** Jika muncul layar biru konfigurasi `msmtp`, pilih **`<No>`** pada opsi AppArmor untuk menghindari error perizinan.
* **Password Database:** Masukkan password yang kuat saat diminta di awal skrip.

## 📧 Konfigurasi Email (SMTP Gmail)

Agar WordPress dapat mengirim email:

1. Aktifkan **2-Step Verification** di Akun Google.
2. Buat **App Password** (16 digit).
3. Gunakan plugin **WP Mail SMTP** di WordPress dengan host `smtp.gmail.com` dan port `587 (TLS)`.

## 🔒 Monitoring Keamanan

* Cek IP yang diblokir: `fail2ban-client status wordpress`
* Buka blokir IP: `fail2ban-client set wordpress unbanip [ALAMAT_IP]`

---
