---

# 🚀 Arsitektur & Otomasi Server WordPress (High Hardening)

Dokumen ini berisi panduan arsitektur dan instruksi penggunaan skrip otomatisasi untuk membangun server WordPress berbasis **LEMP Stack** dengan standar keamanan tinggi (*High Hardening*).

## 🛠️ Penjelasan Teknologi (Stack)

Sistem ini dirancang untuk performa maksimal dan penggunaan sumber daya yang efisien menggunakan komponen berikut:

### 1. Core Stack (LEMP)

* **Linux (Ubuntu/Debian):** Fondasi sistem operasi yang stabil.
* **Nginx (Engine-X):** Server web *event-driven* yang ringan dan unggul dalam menangani trafik tinggi.
* **MariaDB 10.x:** Database tangguh (drop-in replacement untuk MySQL) dengan fitur keamanan lebih baik.
* **PHP 8.3:** Versi PHP terbaru yang menawarkan kecepatan eksekusi kode paling optimal.

### 2. Keamanan & Monitoring

* **Fail2Ban (IPS):** Memantau log akses secara *real-time* dan otomatis memblokir IP yang terdeteksi melakukan *Brute Force*.
* **Nginx Hardening:** Konfigurasi khusus untuk menyembunyikan identitas server dan memblokir injeksi karakter berbahaya.
* **SMTP Relay (msmtp):** Memastikan email sistem (notifikasi admin) terkirim dengan aman melalui jalur terenkripsi.

---

## 📊 Nginx vs Apache: Mengapa Nginx?

| Fitur | Nginx (Modern) | Apache (Tradisional) |
| --- | --- | --- |
| **Koneksi** | Menangani ribuan koneksi secara simultan. | Terbatas oleh jumlah proses RAM. |
| **Konten Statis** | Sangat Cepat. | Standar. |
| **Keamanan** | Konfigurasi terpusat (Lebih Terkontrol). | Berbasis `.htaccess` (Rentan kesalahan user). |

---

## 🚀 Panduan Penggunaan

### Persiapan Server

1. Pastikan Anda memiliki server bersih (Clean Install) Ubuntu atau Debian.
2. Pastikan Anda memiliki akses **Root**.

### Cara Instalasi (Metode Manual)

1. Buat file script di direktori root:
```bash
nano /root/rebuild_wpbynginx.sh

```


2. Tempelkan kode skrip ke dalam file tersebut.
3. Berikan izin akses:
```bash
chmod +x /root/rebuild_wpbynginx.sh

```


4. Jalankan instalasi:
```bash
./rebuild_wpbynginx.sh

```



### Cara Instalasi (Metode One-Liner GitHub)

Jika skrip sudah diunggah ke GitHub, gunakan perintah ini untuk instalasi instan:

```bash
curl -sSL [URL_RAW_GITHUB_ANDA] -o rb.sh && chmod +x rb.sh && ./rb.sh

```

---

## 🔒 Manajemen Keamanan (Fail2Ban)

Skrip ini secara otomatis melindungi folder login WordPress.

* **Cek IP yang diblokir:** `fail2ban-client status wordpress`
* **Buka blokir IP:** `fail2ban-client set wordpress unbanip [ALAMAT_IP]`
* **Aturan:** 5x gagal login dalam 10 menit akan mengakibatkan blokir selama 1 jam.

---

## 📧 Konfigurasi Email (Gmail SMTP)

Agar WordPress dapat mengirim email tanpa dianggap spam, ikuti langkah ini:

1. **Google App Password:**
* Aktifkan *2-Step Verification* di akun Google.
* Buat "App Password" baru untuk "WordPress Server".
* Simpan 16 digit kode yang diberikan.


2. **Plugin WordPress:**
* Gunakan plugin **WP Mail SMTP**.
* Gunakan SMTP Host: `smtp.gmail.com`, Port: `587`, Encryption: `TLS`.
* Gunakan 16 digit kode tadi sebagai password SMTP.



---

## 📂 Akses Database (Secret URL)

Untuk alasan keamanan, **phpMyAdmin** tidak menggunakan URL standar. Anda dapat mengaksesnya melalui:
`http://[IP_SERVER_ANDA]/kelola_db_aman`

---

**Status Proyek:** Final / Terintegrasi

---
