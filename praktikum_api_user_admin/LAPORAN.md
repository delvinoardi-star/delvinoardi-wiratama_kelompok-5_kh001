# Laporan Praktikum Pemrograman Mobile

## REST API User dan Admin dengan Flutter

Nama: Delvino Ardi Wiratama

NIM: 20250801116

## 1. Struktur File Model dan Service

Pada praktikum ini saya membuat aplikasi Flutter yang mengambil dan mengirim data ke REST API. Saya menggunakan paket http dan API dari JSONPlaceholder. Karena NIM saya berakhiran 116, ID User yang dipakai adalah 1116 dan ID Admin adalah 2116. File Model dan Service untuk User dan Admin saya buat terpisah. Model User ada di `lib/models/user.dart` dan Model Admin ada di `lib/models/admin.dart`. Service User ada di `lib/services/api_service.dart` dan Service Admin ada di `lib/services/admin_service.dart`. Halaman tampilan ada di folder `lib/pages`.

## 2. Model User dan Admin

Model User berisi id, name, email, dan city. Model Admin berisi id, name, email, dan department. Di kedua model saya membuat fungsi `fromJson` untuk mengubah data JSON dari API menjadi objek. Pada Model User saya juga membuat `toJson` untuk mengubah objek menjadi JSON saat data dikirim. Di JSONPlaceholder, kota ada di dalam `address`, jadi city diambil dari `address.city`. JSONPlaceholder tidak punya data admin, jadi data Admin saya ambil dari `/users` dan department diisi dari nama perusahaan (`company.name`).

## 3. Proses GET

Untuk mengambil data, saya mengirim request GET ke `/users`. Kalau status code-nya 200, data JSON diubah menjadi list User lalu ditampilkan di layar. Kalau gagal, aplikasi menampilkan pesan error. Detail User diambil dengan GET ke `/users/{id}`. Data Admin diambil dengan cara yang sama lewat `getAdmins()` dan `getAdmin(id)`.

## 4. Proses POST, PUT, PATCH, dan DELETE User

POST dipakai untuk menambah User baru dengan ID 1116, dan server membalas status 201. PUT dipakai untuk memperbarui nama dan email User. PATCH dipakai untuk mengubah nama saja, yaitu menambahkan teks " - Flutter Developer" di belakang nama. DELETE dipakai untuk menghapus User berdasarkan ID. Untuk mencobanya saya membuat halaman Uji CRUD. Di halaman ini ada tombol GET, POST, PUT, PATCH, dan DELETE, lalu hasilnya ditampilkan berupa status code dan isi respons.

## 5. Proses Delete Admin

Admin bisa dihapus dengan menekan ikon hapus di daftar Admin atau dengan memasukkan ID 2116. Sebelum dihapus, muncul dialog konfirmasi. Kalau pengguna memilih Hapus, aplikasi mengirim request DELETE lewat `deleteAdmin(id)`. Kalau berhasil, data Admin hilang dari daftar dan status code ditampilkan.

## 6. Tampilan dan Hasil Pengujian

Setelah aplikasi dijalankan, semua fitur bisa berjalan. Daftar dan detail User tampil dengan status 200. POST mendapat status 201, sedangkan PUT, PATCH, dan DELETE mendapat status 200. Daftar Admin tampil dengan status 200, dan hapus Admin juga berhasil dengan status 200 setelah konfirmasi. Data dengan ID 1116 dan 2116 tidak ditemukan (404) saat dicari, karena JSONPlaceholder adalah API latihan dan data tidak benar-benar tersimpan di server. Karena itu juga, ID yang dikembalikan saat POST adalah 11, bukan 1116.


![Gambar 1](screenshots/01-daftar-user.png)

Gambar 1. Daftar User

![Gambar 2](screenshots/02-detail-user-id-1.png)

Gambar 2. Detail User

![Gambar 3](screenshots/13-uji-post.png)

Gambar 3. Uji POST User

![Gambar 4](screenshots/14-uji-put.png)

Gambar 4. Uji PUT User

![Gambar 5](screenshots/15-uji-patch.png)

Gambar 5. Uji PATCH User

![Gambar 6](screenshots/16-uji-delete.png)

Gambar 6. Uji DELETE User

![Gambar 7](screenshots/05-daftar-admin.png)

Gambar 7. Daftar Admin

![Gambar 8](screenshots/09-hasil-hapus-admin-3.png)

Gambar 8. Hapus Admin

## 7. Kesimpulan

Dari praktikum ini saya belajar memisahkan Model dan Service untuk User dan Admin di Flutter. Saya juga belajar memakai GET, POST, PUT, PATCH, dan DELETE dengan paket http, serta mengecek status code dari setiap respons.
