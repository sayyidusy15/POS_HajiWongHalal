# Dynasty POS 鼎 — Design Concept & Token System

<p align="center">
  <img alt="Typography: Plus Jakarta Sans" src="https://img.shields.io/badge/Typography-Plus_Jakarta_Sans-34CB62?style=flat-square&logo=google-fonts&logoColor=white&labelColor=FAFAFA">
  <img alt="Color System: Emerald & Light" src="https://img.shields.io/badge/Colors-Emerald_&_Light-2EB362?style=flat-square&labelColor=FAFAFA">
  <img alt="Platform: Android Tablet" src="https://img.shields.io/badge/Target-Android_Tablet-3DDC84?style=flat-square&logo=android&logoColor=white&labelColor=FAFAFA">
  <img alt="Architecture: Offline--First" src="https://img.shields.io/badge/Architecture-Offline--First-BEF264?style=flat-square&labelColor=FAFAFA">
</p>

**Sistem desain visual kasir yang ringkas, berkinerja tinggi, dan bersih untuk operasional restoran Chinese yang dinamis.**

Dynasty POS menggunakan pendekatan visual modern berbasis kontras tinggi dalam **Light Mode (Mode Terang)**. Dengan menggabungkan warna **Hijau Emerald (Primary)** sebagai aksen operasional, warna **Putih/Abu Terang (Neutral)** sebagai latar belakang default untuk kenyamanan visual di lingkungan restoran yang terang, serta tipografi **Plus Jakarta Sans** yang geometris pada layar tablet Android.

> *Dynasty POS* 鼎 (dǐng): Terinspirasi dari bejana perunggu kuno Tiongkok yang melambangkan kemakmuran, stabilitas, dan kebersamaan di meja makan.

---

## Filosofi Desain (Visual System Outcomes)

| Pilar Utama | Deskripsi Sistem | Tujuan Operasional |
| :--- | :--- | :--- |
| 🟢 **Emerald Mint Green** | Warna utama yang cerah namun sejuk di mata. | Digunakan untuk tombol aksi utama (*Call to Action*), indikator sukses, dan elemen interaktif agar mata kasir langsung tertuju pada tombol penting saat memproses pesanan cepat. |
| ⚪ **White Light Mode** | Kombinasi warna putih bersih (`#FFFFFF`) hingga abu terang sebagai latar belakang dasar. | Memberikan kesan bersih, higienis, dan sangat profesional yang cocok dengan nuansa restoran modern yang berlimpah cahaya lampu. |
| 🔠 **High-Readability Font** | Menggunakan font *Plus Jakarta Sans* dengan pengaturan *line height* yang longgar. | Memastikan nama menu (seperti *Dimsum*, *Szechuan Beef*) dan angka nominal pembayaran dapat dibaca secara instan dari jarak 30-50 cm tanpa salah baca. |

---

## 1. Sistem Tipografi (Typography)

Menggunakan Google Fonts **Plus Jakarta Sans**. Seluruh gaya teks diatur dengan rasio *line height* yang presisi untuk mencegah teks bertabrakan.

### Heading Styles
| Token | Font Size | Line Height | Font Weights | Penggunaan Utama |
| :--- | :--- | :--- | :--- | :--- |
| **Heading 1** | 64px | 76px *(72px untuk Regular)* | Bold, SemiBold, Medium, Regular | Angka total transaksi besar pada layar konfirmasi |
| **Heading 2** | 46px | 54px | Bold, SemiBold, Medium, Regular | Nominal kembalian atau angka utama di keranjang |
| **Heading 3** | 36px | 44px | Bold, SemiBold, Medium, Regular | Judul modul utama (misal: "Kasir", "Laporan") |
| **Heading 4** | 24px | 30px | Bold, SemiBold, Medium, Regular | Nama kategori menu atau sub-header panel |

*Catatan: Heading 1 Regular secara spesifik memiliki Line Height 72px untuk estetika visual yang lebih rapat.*

### Body Styles
| Token | Font Size | Line Height | Font Weights | Penggunaan Utama |
| :--- | :--- | :--- | :--- | :--- |
| **Body XL** | 20px | 28px | Bold, SemiBold, Medium, Regular | Nama item menu utama di grid kasir |
| **Body L** | 18px | 24px | Bold, SemiBold, Medium, Regular | Harga menu atau deskripsi item di keranjang |
| **Body M** | 16px | 22px | Bold, SemiBold, Medium, Regular | Teks tombol, form input, dan label sekunder |
| **Body S** | 14px | 20px | Bold, SemiBold, Medium, Regular | Keterangan tambahan (porsi, notes pedas/tidak) |
| **Body XS** | 12px | 16px | Bold, SemiBold, Medium, Regular | Detail struk kecil, badge status, timestamp |

---

## 2. Sistem Warna (Color Palette)

Sistem warna resmi diselaraskan dengan spesifikasi Light Mode (latar belakang putih).

### Primary Scale (Emerald Green)
Aksen utama aplikasi untuk menandakan interaksi aktif, tombol bayar, dan status sukses.

| Token | Kode HEX | Nilai RGB | Penggunaan Utama |
| :--- | :--- | :--- | :--- |
| Primary 50 | `#F3FAF7` | `RGB 243, 250, 247` | Latar belakang badge aktif / info ringan |
| Primary 100 | `#DAF4E6` | `RGB 218, 244, 230` | Hover state di layar terang |
| Primary 200 | `#BEEDD2` | `RGB 190, 237, 210` | Border kartu menu yang terpilih |
| Primary 300 | `#98E4B8` | `RGB 152, 228, 184` | Ikon aktif / teks dengan penekanan sedang |
| Primary 400 | `#6AD896` | `RGB 106, 216, 150` | Tombol sekunder interaktif |
| **Primary 500** | `#34CB62` | `RGB 52, 203, 98` | **Warna Utama (Tombol Aksi Utama, Sukses)** |
| Primary 600 | `#2EB362` | `RGB 46, 179, 98` | Tombol state ditekan (*Pressed State*) |
| Primary 700 | `#289656` | `RGB 40, 156, 84` | Elemen penekanan kuat pada background terang |
| Primary 800 | `#218347` | `RGB 33, 131, 71` | Background kontainer gelap |
| Primary 900 | `#1A6637` | `RGB 26, 102, 55` | Aksen paling gelap |

### Neutral Scale (Charcoal / Grey - Light Mode Optimized)
Membentuk struktur UI, latar belakang aplikasi (Scaffold BG), kartu menu, dan pembatas konten.

| Token | Kode HEX | Nilai RGB | Penggunaan Utama |
| :--- | :--- | :--- | :--- |
| **White** | `#FFFFFF` | `RGB 255, 255, 255` | **Latar belakang dasar layar (Scaffold BG), Kartu** |
| Neutral 50 | `#FAFAFA` | `RGB 250, 250, 250` | Latar belakang item list sekunder |
| Neutral 100 | `#F5F5F5` | `RGB 245, 245, 245` | Latar belakang form input field |
| Neutral 200 | `#E5E5E5` | `RGB 229, 229, 229` | Garis batas input field / border |
| Neutral 300 | `#D8D7D7` | `RGB 216, 215, 215` | Border kartu tidak aktif / divider |
| Neutral 400 | `#8F8F8F` | `RGB 143, 143, 143` | Ikon tidak aktif / placeholder |
| Neutral 500 | `#757575` | `RGB 117, 117, 117` | Teks keterangan ringan / teks sekunder |
| Neutral 600 | `#525252` | `RGB 82, 82, 82` | Teks utama pada input field |
| Neutral 700 | `#464646` | `RGB 70, 70, 70` | Teks tubuh utama sekunder |
| Neutral 800 | `#282828` | `RGB 40, 40, 40` | Teks judul modul |
| **Neutral 900** | `#141414` | `RGB 20, 20, 20` | **Teks utama paling gelap (Heading & Body)** |

---

## 3. Sistem Tombol (Button Styles)

Menyediakan variasi tombol kustom untuk memfasilitasi navigasi dan input yang dinamis di layar POS:

| Jenis Tombol | Karakteristik Visual | Penempatan/Penggunaan |
| :--- | :--- | :--- |
| 🟢 **Primary Solid** | Background hijau `#34CB62` (atau gradasi `#35C56E` ➔ `#2E9055`), teks putih, tinggi `54px`, `BorderRadius.circular(12)`. | Aksi utama utama seperti "Bayar", "Simpan", "Login". |
| ⚪ **Outline Button** | Background transparan/putih, border tipis `#DEE2E6`, teks `#141414` (Neutral 900). | Aksi sekunder seperti "Batal", "Continue With Google", "Cetak Ulang". |
| 🟩 **Text Button** | Tanpa background & border, hanya teks berwarna hijau `#34CB62` (atau abu `#757575` jika tidak aktif). | Navigasi minor seperti "Forgot password?", "Tambah Catatan". |
| 🔒 **Disabled Button** | Background abu-abu terang `#E5E5E5`, teks `#8F8F8F`, tidak interaktif. | Menahan aksi hingga validasi lengkap. |

---

## 4. Implementasi Kode (Flutter Token Integration)

Semua token di atas telah terintegrasi di dalam proyek Anda pada folder `lib/core/theme/`:
- 📁 **`app_colors.dart`**: Menyimpan variabel statis warna (contoh: `AppColors.primary500`, `AppColors.white`).
- 📁 **`app_typography.dart`**: Menyimpan objek `TextStyle` Plus Jakarta Sans (contoh: `AppTypography.h3Bold`, `AppTypography.bodyMRegular`).
- 📁 **`app_theme.dart`**: Mengintegrasikan warna dan teks tersebut ke dalam `ThemeData.light()` standar Flutter.
- 📁 **`app_button.dart`**: Widget kustom sekali pakai (`AppButton`) untuk memanggil tombol solid, gradient, outline, atau text secara instan di seluruh layar kasir.
