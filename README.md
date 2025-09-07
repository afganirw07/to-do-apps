# 📝 Todo List App (Flutter + Supabase)

Aplikasi **Todo List** modern dengan **Flutter** sebagai frontend dan **Supabase** sebagai backend.  
Mendukung **CRUD (Create, Read, Update, Delete)** dengan autentikasi user.  
UI dibuat minimalis dengan warna utama biru 🌊.

---

## ✨ Fitur Utama
- 🔐 **Autentikasi** dengan Supabase (Register & Login).
- 📝 **CRUD Todo**:
  - Tambah todo
  - Lihat daftar todo
  - Edit todo
  - Hapus todo
- ⚡ **Realtime Update** (opsional, jika diaktifkan di Supabase).
- 🎨 **UI Modern** dengan animasi fade + warna inti biru.

---

## 📂 Struktur Project
```
lib/
├── main.dart                # Entry point aplikasi
├── screens/
│   ├── login_screen.dart    # Halaman login
│   ├── register_screen.dart # Halaman register
│   └── homepage.dart        # Halaman utama (Todo CRUD)
└── widgets/
    └── todo_item.dart       # Widget todo individual
```

---

## 🛠️ Instalasi & Setup

### 1. Clone repository
```bash
git clone https://github.com/username/todo_flutter_supabase.git
cd todo_flutter_supabase
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Buat Project di Supabase
- Masuk ke [Supabase](https://supabase.com).
- Buat project baru.
- Ambil **API URL** dan **Anon Key** dari **Project Settings > API**.
- Tambahkan ke file `lib/main.dart`:
  ```dart
  await Supabase.initialize(
    url: "YOUR_SUPABASE_URL",
    anonKey: "YOUR_SUPABASE_ANON_KEY",
  );
  ```

### 4. Setup Database Schema
Jalankan SQL berikut di **Supabase SQL Editor**:

```sql
-- Tabel users (otomatis dibuat oleh Supabase Auth, 
-- tapi kita simpan full_name juga di sini)
create table if not exists users (
  id uuid references auth.users on delete cascade,
  full_name text,
  email text unique,
  primary key (id)
);

-- Tabel todos
create table if not exists todos (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references auth.users on delete cascade,
  title text not null,
  is_done boolean default false,
  created_at timestamp default now()
);
```

<img src="https://i.ibb.co.com/35dk2kzf/Untitled-2.png" alt="Database Schema" width="500">


---

## ▶️ Menjalankan Aplikasi
### Android / iOS
```bash
flutter run
```

### Web
```bash
flutter run -d chrome --web-renderer html
```

> ⚠️ Catatan: Flutter Web butuh HTTPS/localhost agar service worker jalan normal.

---

