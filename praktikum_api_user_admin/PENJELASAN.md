# Penjelasan Kode — Praktikum REST API User & Admin

> Untuk Bos (Delvino, NIM 20250801116). Baca berurutan dari atas: alur data di aplikasi ini
> **API (JSON) → Service (http + cek status) → Model (fromJson) → Halaman (FutureBuilder)**.
> Sebelum dikumpulkan, cek aturan dosen soal pemakaian AI, dan pastikan Bos bisa menjelaskan tiap file
> tanpa melihat catatan ini.

## 0. Gambaran besar

```
┌──────────────┐  GET/POST/PUT/PATCH/DELETE   ┌──────────────────────────┐
│  pages/*.dart│ ───────────────────────────▶ │ services/api_service.dart│ ──http──▶ JSONPlaceholder
│ (FutureBuilder)◀── User / List<User> ─────── │ services/admin_service   │ ◀─JSON──
└──────────────┘                              └──────────────────────────┘
                                                     │ jsonDecode → Model.fromJson
                                                     ▼
                                              models/user.dart, admin.dart
```

Kenapa dipisah? **Halaman** cukup tahu "minta daftar User", tidak perlu tahu URL atau format JSON.
**Service** cukup tahu cara bicara dengan server. **Model** cukup tahu bentuk datanya. Kalau API diganti,
yang diubah hanya config/service, bukan halaman. Ini prinsip *separation of concerns*.

---

## 1. `lib/config/api_config.dart`

- `ApiConfig.baseUrl` — alamat server di satu tempat. Ganti di sini kalau dosen memakai API lain.
- `userPath` dan `adminPath` — endpoint. `adminPath` sengaja `/users` karena JSONPlaceholder tidak punya data admin.
- `timeout` — batas tunggu 15 detik agar aplikasi tidak loading selamanya.
- `jsonHeaders` — `Content-Type: application/json` wajib saat mengirim body JSON (POST/PUT/PATCH), supaya
  server tahu body-nya JSON.
- `PraktikumIds` — `n = 116`, `userId = 1000 + n = 1116`, `adminId = 2000 + n = 2116`, dan teks
  `patchSuffix = ' - Flutter Developer'`. Ditulis sebagai rumus agar terlihat asalnya dari NIM.

## 2. `lib/models/user.dart`

```dart
factory User.fromJson(Map<String, dynamic> json)
```
- **Apa itu factory constructor?** Constructor yang boleh berisi logika dulu sebelum membuat objek.
  Di sini kita perlu mengambil `city` dari dalam `address`, jadi tidak bisa langsung `User(...)`.
- **Kenapa `city` diambil dari `address.city`?** Bentuk JSON JSONPlaceholder:
  `{"id":1, "name":"Leanne Graham", "email":"...", "address":{"city":"Gwenborough"}}`.
  `city` bukan di level atas. Ada cadangan `json['city']` kalau server lain memakai field datar.
- **Kenapa pakai `?? ''`?** Respons PATCH hanya berisi `name` dan `id`. Tanpa nilai default, `email` akan
  `null` dan aplikasi crash. Ini disebut parsing yang *defensif*.
- `_toInt()` — id kadang dikirim sebagai String (`"11"`), jadi disamakan ke `int`.
- `toJson()` — kebalikan `fromJson`: objek → Map → `jsonEncode` → body request. Bentuknya mengikuti server
  (`address: {city: ...}`) supaya `fromJson(toJson())` menghasilkan data yang sama (diuji di test "round trip").
- `copyWith()` — membuat salinan dengan sebagian field diganti; berguna untuk PUT (data lama + nama/email baru).
- Semua field `final` → objek *immutable*: tidak bisa diubah setelah dibuat, jadi lebih aman.

## 3. `lib/models/admin.dart`

Sama seperti User, tetapi field keempat `department`. Urutan pengambilan:
1. Jika JSON punya `department` (server dosen yang punya data admin) → pakai itu.
2. Jika tidak → ambil `company.name` (JSONPlaceholder).

Jadi model ini tetap jalan di dua jenis server tanpa diubah.

## 4. `lib/services/api_exception.dart` dan `http_helper.dart`

- `ApiException implements Exception` — tetap sebuah Exception (sesuai soal "throw Exception"), tetapi
  membawa `statusCode` dan `body`. UI jadi bisa menulis "404 Not Found" alih-alih pesan umum.
- `sendRequest()` — membungkus pemanggilan http:
  - `TimeoutException` → "Request timeout".
  - `http.ClientException` (tidak ada internet, DNS gagal, CORS di web) → "Gagal terhubung ke server".
  - Di sini `statusCode` masih `null` karena server belum menjawab sama sekali.
- `ensureStatus(response, {200}, pesan)` — **pemisahan error handling**: kalau status code tidak termasuk
  yang dianggap sukses, `throw ApiException(...)`. Contoh: GET sukses hanya `200`, POST `200/201`,
  DELETE `200/204`.

Dua jenis error ini dipisah karena penyebabnya beda: yang satu **tidak sampai ke server**, yang satu
**server menjawab tetapi menolak/tidak menemukan**.

## 5. `lib/services/api_result.dart`

`ApiResult<T>` = method + url + statusCode + body mentah + data (objek Dart). Dipakai halaman "Uji CRUD"
supaya status code dan body bisa ditampilkan dan di-screenshot. `<T>` adalah *generic*: `ApiResult<User>`
untuk POST/PUT/PATCH, `ApiResult<void>` untuk DELETE (tidak ada data).

## 6. `lib/services/api_service.dart` (CRUD User)

Constructor: `ApiService({http.Client? client})`. Kalau kosong pakai `http.Client()` asli; saat test diisi
`MockClient`. Teknik ini disebut **dependency injection** — membuat service bisa diuji tanpa internet.

| Fungsi | Method & URL | Body dikirim | Sukses | Keterangan |
|---|---|---|---|---|
| `getUsers()` | GET `/users` | – | 200 | `jsonDecode` → `List<dynamic>` → `.map(User.fromJson)` → `List<User>` |
| `fetchUser(id)` / `getUser(id)` | GET `/users/{id}` | – | 200 | `fetchUser` mengembalikan `ApiResult` (untuk halaman uji); `getUser` hanya data `User` (untuk halaman detail) |
| `createUser(user)` | POST `/users` | `user.toJson()` (id 1116) | 200/201 | Server membalas **201 Created** |
| `updateUser(user)` | PUT `/users/{id}` | data **utuh** (id, name, email, address) | 200 | PUT = ganti seluruh resource |
| `patchUserName(id, name)` | PATCH `/users/{id}` | `{"name": "... - Flutter Developer"}` | 200 | PATCH = ubah sebagian field |
| `deleteUser(id)` | DELETE `/users/{id}` | – | 200/204 | Body biasanya `{}` |

Pola tiap fungsi selalu sama — hafalkan ini, karena asisten biasanya minta menjelaskan satu fungsi:
1. Susun `Uri` (`_uri(id)`).
2. Kirim request lewat `sendRequest(() => _client.xxx(...))`.
3. `ensureStatus(...)` → kalau gagal, lempar `ApiException`.
4. `jsonDecode(res.body)` → `Model.fromJson(...)` → kembalikan.

## 7. `lib/services/admin_service.dart`

File dan kelas terpisah dari User (sesuai soal). Isinya `getAdmins()`, `getAdmin(id)`, `deleteAdmin(id)`
dengan pola yang sama. Endpoint diambil dari `ApiConfig.adminPath`.

## 8. Halaman (`lib/pages/`)

- `main.dart` — `MaterialApp` + `HomePage` dengan `NavigationBar` 3 tab (User, Admin, Uji CRUD). Pakai
  `IndexedStack` agar tab tidak dibuat ulang (data tidak di-request ulang setiap pindah tab). Service dibuat
  sekali di `main()` lalu dioper ke halaman.
- `user_list_page.dart` — **FutureBuilder**:
  - Future disimpan di `initState` (`_futureUsers = service.getUsers()`), **bukan** dipanggil di `build()`.
    Kalau dipanggil di `build()`, setiap rebuild (misal setState) akan request ulang ke server.
  - 3 keadaan snapshot: `waiting` → loading; `hasError` → `ErrorView`; ada data → `ListView`.
  - Ikon kaca pembesar: dialog input ID (default 1116) → buka detail.
- `user_detail_page.dart` — FutureBuilder `getUser(id)`. Untuk ID 1116 server membalas 404 → muncul pesan
  "User dengan ID 1116 tidak ditemukan" + penjelasan fake API.
- `admin_list_page.dart` — daftar Admin + tombol hapus merah di tiap baris + ikon "hapus berdasarkan ID"
  (default 2116). Alur hapus: `showConfirmDelete` → kalau "Hapus" → `deleteAdmin(id)` → jika 200, Admin
  dibuang dari list di layar (`removeWhere`) dan kartu hasil (status code + body) muncul di atas.
  Kenapa dibuang manual? Karena server demo tidak benar-benar menghapus; kalau di-GET ulang datanya muncul lagi.
- `admin_detail_page.dart` — detail Admin berdasarkan ID + tombol hapus di AppBar (dengan konfirmasi).
- `crud_test_page.dart` — form ID/nama/email/kota + 5 tombol. Hasil tiap request ditampilkan di `ResultCard`.
  PATCH mencoba GET nama lama dulu; kalau 404 (ID 1116 tidak ada di server) pakai nama dari form, lalu
  menambahkan `' - Flutter Developer'`. DELETE memakai dialog konfirmasi juga.
- `widgets/common_widgets.dart` — komponen yang dipakai berulang: `InfoBanner`, `ErrorView`, `StatusChip`
  (hijau 2xx, merah lainnya), `ResultCard`, `prettyJson`, `showIdDialog`, `showConfirmDelete`.

## 9. Test (`test/`)

- `models/model_test.dart` — fromJson/toJson User & Admin, field tidak lengkap, id String, round trip, copyWith.
- `services/service_test.dart` — `MockClient` dari `package:http/testing.dart` berperan sebagai server palsu.
  Di dalamnya kita cek request yang dikirim (method, URL, header, isi body), lalu membalas respons buatan.
  Diuji: GET/POST/PUT/PATCH/DELETE User, 404, 500, gagal koneksi, getAdmins/getAdmin/deleteAdmin.
- `widget_test.dart` — aplikasi dirender dengan MockClient: daftar User tampil; hapus Admin memunculkan dialog
  konfirmasi lalu status 200.

## 10. Perilaku "fake API" JSONPlaceholder (penting untuk dijelaskan)

JSONPlaceholder adalah server latihan. Menurut panduannya, data **tidak benar-benar disimpan/diubah** —
server hanya *berpura-pura* (sumber: https://jsonplaceholder.typicode.com/guide).

| Aksi | Yang terjadi | Kenapa |
|---|---|---|
| GET `/users` | 200, 10 user (ID 1–10) | Data bawaan server |
| GET `/users/1116`, `/users/2116` | **404** body `{}` | ID itu memang tidak ada di server |
| POST `/users` dengan id 1116 | **201**, tetapi `id` di respons = **11** | Server mengabaikan id kiriman dan membuat id baru (jumlah data + 1); data tidak tersimpan |
| PUT/PATCH `/users/{id}` | 200, body = data yang dikirim | Perubahan disimulasikan, tidak permanen |
| DELETE `/users/{id}` | 200, body `{}` | Penghapusan disimulasikan; GET lagi datanya masih ada |

Catatan jujur: perilaku PUT ke ID yang **tidak ada** (1116) belum saya verifikasi langsung, karena server
tidak bisa diakses dari lingkungan pembuat. Kalau di laptop Bos PUT `/users/1116` ternyata error (misal 500
atau 404), aplikasi akan menampilkan status code-nya dengan jelas. Ganti ID target ke `1` lalu tekan PUT lagi
untuk menunjukkan PUT yang berhasil, dan jelaskan alasannya ke asisten.

---

## 11. Pertanyaan yang mungkin ditanya asisten/dosen

**1. Apa beda PUT dan PATCH?**
PUT mengganti resource **secara utuh**, jadi semua field dikirim (`updateUser` mengirim id, name, email,
address). PATCH hanya mengubah **sebagian** field (`patchUserName` hanya mengirim `{"name": ...}`). Kalau PUT
hanya mengirim `name`, secara konsep field lain bisa dianggap hilang.

**2. Kenapa POST id 1116 tapi yang kembali id 11?**
JSONPlaceholder adalah fake API: id dibuat oleh server (data bawaan 10, jadi yang baru 11), id kiriman
diabaikan, dan data tidak benar-benar tersimpan. Karena itu GET `/users/1116` tetap 404. Di server sungguhan
id biasanya juga dibuat server (auto increment), bukan client.

**3. Apa fungsi `fromJson` dan `toJson`?**
`fromJson` mengubah Map hasil `jsonDecode(response.body)` menjadi objek `User`/`Admin` supaya bisa dipakai
dengan aman (`user.name`, bukan `json['name']` yang rawan salah ketik). `toJson` kebalikannya: objek → Map →
`jsonEncode` untuk body POST/PUT.

**4. Bagaimana error handling-nya?**
Dua lapis. (a) `sendRequest` menangkap error jaringan dan timeout. (b) `ensureStatus` mengecek `statusCode`;
jika bukan kode sukses, `throw ApiException(pesan, statusCode, body)`. Di UI, `FutureBuilder` menangkapnya
lewat `snapshot.hasError` dan menampilkan `ErrorView`. Di halaman uji ditangkap dengan `try/catch` lalu
ditampilkan di `ResultCard`.

**5. Kenapa Future disimpan di `initState`, bukan langsung di `FutureBuilder(future: service.getUsers())`?**
`build()` bisa terpanggil berkali-kali (setState, rotasi layar, dsb.). Kalau Future dibuat di `build()`, setiap
rebuild akan mengirim request baru dan loading berulang. Disimpan di state agar request hanya sekali, dan
dibuat ulang hanya saat tombol refresh.

**6. Kenapa data Admin diambil dari `/users`? Dari mana `department`?**
JSONPlaceholder tidak punya endpoint admin. Supaya tetap memakai data asli dari server, Admin diambil dari
`/users` dan `department` diisi `company.name`. Endpoint ada di `ApiConfig.adminPath`, jadi kalau server
dosen punya `/admins`, cukup ganti satu baris. `Admin.fromJson` juga sudah membaca field `department` jika ada.

**7. Setelah hapus Admin, kenapa datanya hilang dari layar padahal server tidak benar-benar menghapus?**
Setelah DELETE membalas 200, Admin itu dibuang dari list di state lokal (`removeWhere` + `setState`) agar user
melihat efeknya. Kalau ditekan refresh (GET ulang), data muncul lagi karena server fake. Penghapusan didahului
dialog konfirmasi (`showConfirmDelete`) supaya tidak terhapus karena salah tekan.

**8. Bagaimana cara menguji service tanpa internet?**
Service menerima `http.Client` lewat constructor (dependency injection). Di test diberikan `MockClient` dari
`package:http/testing.dart` yang membalas respons buatan. Jadi bisa dicek: method benar, URL `/users/1116`
benar, body PATCH hanya berisi `name`, dan 404/500 menghasilkan `ApiException`. Hasilnya `flutter test`:
24 test lulus.

**Bonus — kenapa perlu izin INTERNET di AndroidManifest?**
Di Android, aplikasi build release tidak boleh mengakses jaringan tanpa
`<uses-permission android:name="android.permission.INTERNET"/>`. Mode debug biasanya sudah otomatis punya izin
ini, jadi lupa menambahkannya sering baru ketahuan saat build APK.

**Bonus — arti status code yang muncul:** 200 OK (sukses), 201 Created (data baru dibuat), 204 No Content
(sukses tanpa body), 404 Not Found (resource tidak ada), 500 Internal Server Error (kesalahan di server).
Rujukan: MDN — HTTP response status codes, https://developer.mozilla.org/en-US/docs/Web/HTTP/Status

## Kaitan dengan roadmap

Pola yang sama (endpoint REST, status code, pemisahan model/service, test dengan mock) akan Bos pakai
dari sisi **server** saat membangun Express.js REST API di Project 1 (Expense Tracker API). Di praktikum ini
Bos berada di sisi **client**.
