# VaultBank

## Team Members 🧑‍💻
| Nama | NIM | GitHub Username |
| --- | --- | --- |
| Frederick Andy Junior | 535240010 | [ToastF](https://github.com/ToastF) |
| Grevano Geraldo | 535240030 | [Grevano](https://github.com/Grevano) |
| Andrew Anstendyk T. | 535240130 | [DRoDREW](https://github.com/DRoDREW) |
| Filbert Ferdinand | 535240135 | [gromx-log](https://github.com/gromx-log) |
| Rafael Theng | 535240153 | [Notelis](https://github.com/Notelis) |

---

## Project Links 🔗
* **Video Demo (YouTube):** [Video UTS VaultBank](https://youtu.be/2ueWqa8bbrc?si=OZ2j-CJreCweDkxN)
* **GitHub Repository:** [Github Project: VaultBank]([https://github.com/your-repo-link](https://github.com/ToastF/VaultBank/))

---

## 🏛️ Arsitektur Aplikasi
Aplikasi kami dibangun menggunakan model **Clean Architecture**, yang memisahkan kepentingan menjadi tiga lapisan berbeda: Domain, Data, dan Presentasi. Kami menggunakan **BLoC/Cubit** untuk manajemen state yang efisien.

* **Lapisan Domain**: Lapisan ini menetapkan logika bisnis inti, mendefinisikan model dan bentuk repositori abstrak.
* **Lapisan Data**: Bertanggung jawab atas semua operasi data, lapisan ini mengimplementasikan repositori yang didefinisikan di lapisan Domain. Ini menangani panggilan ke database lokal (**Isar**) dan layanan cloud (**Firestore** dan **Firebase Authentication**), memastikan bahwa data lokal tetap sinkron dengan cloud.
* **Lapisan Presentasi**: Lapisan ini mengelola UI dan interaksi pengguna. Ini menggunakan BLoC/Cubit untuk menangani logika data yang ditampilkan di layar dan untuk memicu fungsi dari lapisan data. UI mengadopsi **pendekatan offline-first**, selalu membaca dari database Isar lokal. Ini memastikan aplikasi berfungsi secara offline dan secara otomatis sinkron dengan cloud setelah koneksi pulih.

---

## ✨ Fitur Utama
Berikut adalah fitur utama dari aplikasi VaultBank.

### Otentikasi 🔐
Otentikasi adalah gerbang ke aplikasi, memastikan bahwa hanya pengguna yang berwenang yang dapat mengakses fitur utama.

* **Pengguna Terotentikasi**: Jika pengguna sudah masuk, mereka akan langsung dibawa ke layar beranda tetapi diminta untuk memasukkan kode akses yang telah ditetapkan sebelumnya. Jika mereka membatalkan, mereka akan keluar.
* **Pengguna Tidak Terotentikasi**: Pengguna baru atau yang sudah keluar akan diarahkan ke layar selamat datang dengan dua opsi:
    * **Daftar**: Pengguna mengisi formulir pendaftaran untuk membuat akun baru. Setelah berhasil mendaftar, mereka menetapkan kode akses dan masuk ke layar beranda.
    * **Masuk**: Pengguna yang sudah ada dapat masuk dengan email dan kata sandi mereka. Setelah itu, mereka diminta untuk menetapkan kode akses baru untuk mengakses layar beranda.
* **Keluar**: Pengguna dapat keluar dari tab profil, yang akan mengarahkan mereka ke layar selamat datang.

### Dasbor 🏠
Dasbor adalah layar utama, yang menyediakan ringkasan informasi akun pengguna, termasuk nama pengguna, saldo (yang dapat disembunyikan), dan nomor akun. Ini juga dilengkapi tombol aksi cepat untuk **Isi Saldo**, **Tarik Tunai**, dan **Transfer**, bersama dengan tampilan riwayat transaksi terbaru. Bilah navigasi bawah memungkinkan untuk beralih dengan mudah antara halaman Beranda, Transfer, dan Profil.


### Profil 👤
Halaman profil memungkinkan pengguna untuk mengelola pengaturan akun mereka. Dari sini, mereka dapat mengubah gambar profil mereka, melihat pusat bantuan, dan mengakses syarat & ketentuan serta kebijakan privasi. Di sinilah juga tombol keluar berada.


### Transfer 💸
Fitur ini memungkinkan pengguna untuk mengirim uang ke pengguna VaultBank lainnya. Saat ini, ini hanya mendukung transfer di dalam jaringan VaultBank.

Proses transfer meliputi:
1.  **Menyimpan Penerima**: Sebelum melakukan transfer, pengguna harus terlebih dahulu menyimpan nomor rekening dan alias penerima.
2.  **Memulai Transfer**: Pengguna memilih penerima yang disimpan, memasukkan jumlah transfer (minimum Rp 1.000), dan menambahkan pesan opsional (maks 15 karakter).
3.  **Konfirmasi dan PIN**: Setelah meninjau detail di halaman konfirmasi, pengguna memasukkan PIN mereka untuk mengotorisasi transaksi.
4.  **Selesai**: Setelah berhasil, tanda terima ditampilkan, saldo pengguna diperbarui, dan transaksi dicatat dalam riwayat mereka.


### Isi Saldo 💳
Pengguna dapat menambahkan dana ke akun VaultBank mereka melalui fitur isi saldo. Meskipun versi ini tidak menggunakan uang sungguhan, ini mensimulasikan prosesnya.

Pengguna dapat memilih dari dua metode:
* **Transfer Bank**: Mensimulasikan isi saldo melalui akun virtual dari bank-bank besar seperti BCA, BRI, Mandiri, dan BNI, masing-masing dengan biaya admin yang berbeda.
* **Tunai melalui Minimarket**: Memberikan instruksi untuk mengisi saldo melalui minimarket seperti Alfamart, Alfamidi, dan Indomaret.

### Tarik Tunai 💵
Fitur ini memungkinkan pengguna untuk menarik uang tunai dari akun mereka melalui minimarket.

Prosesnya sebagai berikut:
1.  **Pilih Minimarket**: Pengguna memilih antara Indomaret, Alfamart, atau Alfamidi.
2.  **Masukkan Jumlah**: Pengguna memasukkan jumlah yang ingin mereka tarik (min Rp 25.000, maks Rp 10.000.000).
3.  **Konfirmasi**: Setelah mengkonfirmasi jumlah, pengguna memasukkan PIN mereka.
4.  **Terima Kode**: Kode rujukan dibuat, yang dapat ditunjukkan kepada kasir untuk menerima uang tunai.

### Riwayat Transaksi 📜
Aplikasi secara otomatis mencatat semua transaksi, termasuk dana masuk (isi saldo, transfer dari orang lain) dan dana keluar (transfer, tarik tunai). Pengguna dapat melihat riwayat transaksi lengkap mereka, yang dapat difilter berdasarkan bulan dan jenis transaksi (masuk atau keluar). Transaksi masuk ditandai dengan warna hijau, sedangkan yang keluar berwarna merah.


### Keamanan PIN 🛡️
Untuk meningkatkan keamanan, PIN diperlukan untuk semua transaksi yang melibatkan dana keluar, seperti transfer dan tarik tunai. Jika PIN yang salah dimasukkan, transaksi akan gagal hingga PIN yang benar diberikan.

---

## ⚠️ Penanganan Kesalahan dan Batasan
Aplikasi ini mencakup validasi input yang kuat untuk mencegah kesalahan. Pengguna akan ditunjukkan pesan kesalahan yang jelas untuk masalah seperti:
* Kredensial masuk tidak valid
* Bidang kosong dalam formulir
* Kesalahan format nama pengguna, kata sandi, atau nomor telepon
* Kata sandi tidak cocok
* Saldo tidak mencukupi untuk transaksi
* Nomor rekening penerima tidak valid
* Jumlah transfer di bawah batas minimum

---

## 🤝 Kontribusi Individu

* **Frederick Andy Junior**: Merancang arsitektur inti aplikasi (Firestore, Isar, BLoC) dan mengembangkan backend untuk otentikasi dan manajemen pengguna. Ia merefaktor fitur transfer untuk berintegrasi dengan layanan backend dan mengembangkan UI untuk layar otentikasi dan riwayat transaksi.

* **Grevano Geraldo**: Mengembangkan layar Beranda dan Profil, termasuk header, tampilan saldo (dengan fungsionalitas sembunyikan/tampilkan), dan tombol aksi. Ia juga membuat bilah navigasi, animasi transisi halaman, kelas palet warna, layar splash, dan ikon aplikasi.

* **Andrew Anstendyk Takalamingan**: Memimpin seluruh proses desain UI/UX, dari wireframing dan membuat mockup di Figma hingga merancang logo aplikasi. Ia juga mengembangkan fitur Tarik Tunai, memastikan fungsionalitasnya dan integrasi real-time dengan Firebase.

* **Filbert Ferdinand**: Mengembangkan fitur Transfer dan PIN. Ia awalnya membangun versi offline yang komprehensif dari fungsionalitas transfer dan kemudian berkolaborasi dalam mengintegrasikannya dengan Firebase. Ia juga membuat modul PIN yang dapat digunakan kembali untuk mengamankan transaksi dan mengelola dokumentasi proyek.

* **Rafael Theng**: Mengembangkan fitur Isi Saldo, termasuk UI dan fungsionalitas penuhnya. Ia memastikan bahwa semua transaksi isi saldo terhubung ke Firebase untuk pembaruan saldo secara real-time dan bertanggung jawab untuk men-debug fitur tersebut dan mengatasi bug lain dalam aplikasi.
