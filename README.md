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
│   ├── splash_screen.dart # Splash Screens
│   └── todo_list_screen.dart        # Halaman utama (Todo CRUD)
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
create table public.users (
  id uuid not null default gen_random_uuid (),
  full_name character varying null,
  email character varying null,
  created_at timestamp with time zone not null default now(),
  updated_at timestamp without time zone null default now(),
  constraint users_pkey primary key (id),
  constraint users_email_key unique (email)
) TABLESPACE pg_default;

-- Tabel todos
create table public.todos (
  id uuid not null default gen_random_uuid (),
  user_id uuid not null,
  title text not null,
  description text null,
  is_completed boolean not null default false,
  created_at timestamp with time zone not null default now(),
  updated_at timestamp with time zone not null default now(),
  constraint todos_pkey primary key (id),
  constraint todos_user_id_fkey foreign KEY (user_id) references auth.users (id) on delete CASCADE
) TABLESPACE pg_default;
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

