# Docker Image Lab + Dive

Project ini dibuat untuk **bedah image Docker** dengan 2 pendekatan:

1. **Inspect cepat** — lihat metadata image dan layer history
2. **Dive** — eksplor isi layer, efisiensi image, dan cek wasted space
3. **Rekonstruksi** — pahami cara kerja image, alur build, lalu buat ulang kerangkanya

Terinspirasi dari project `wagoodman/dive`:
https://github.com/wagoodman/dive

---

## Struktur project

- `docker-compose.yml` → container tools dasar
- `Dockerfile` → image helper berbasis Alpine + Docker CLI + jq
- `Dockerfile.dive` → wrapper image untuk `dive` + config bawaan
- `scripts/inspect-image.sh` → inspect metadata + history image
- `scripts/dive-ui.sh` → buka UI `dive` untuk image tertentu
- `scripts/dive-build.sh` → build image lalu langsung analisis dengan `dive`
- `scripts/dive-ci.sh` → jalankan `dive` mode CI (tanpa UI)
- `scripts/export-image.sh` → export image ke tar dan ekstrak isinya
- `scripts/reconstruct-dockerfile.sh` → buat Dockerfile perkiraan dari history image
- `scripts/explain-layers.sh` → jelaskan tiap layer dengan bahasa manusia
- `scripts/build-story.sh` → ceritakan alur build dari layer awal sampai akhir
- `scripts/full-analysis.sh` → jalankan alur lengkap dan hasilkan panduan belajar
- `scripts/self-test.sh` → uji kelayakan project sebelum dipakai/deploy
- `.dive-ci` → aturan lulus/gagal untuk mode CI
- `.dive.yaml` → konfigurasi UI `dive`
- `TROUBLESHOOTING.md` → panduan cari error dan langkah perbaikannya

---

## Mode pakai yang paling gampang

### A. Inspect cepat (tanpa UI)

```bash
docker compose build
docker compose run --rm image-lab sh /work/scripts/inspect-image.sh nginx:latest
```

Ini cocok kalau Ayang cuma mau lihat:
- image id
- env
- entrypoint/cmd
- ukuran
- layer history

---

### B. Dive UI (mode interaktif)

```bash
./scripts/dive-ui.sh nginx:latest
```

Ini cocok kalau Ayang mau:
- lihat isi file per layer
- lihat file mana yang berubah
- lihat kemungkinan wasted space
- telusuri struktur filesystem image

---

### C. Build lalu langsung bedah

Kalau sedang berada di folder project Docker:

```bash
../openclaw/scripts/dive-build.sh my-image:dev
```

Atau dari root project ini:

```bash
./scripts/dive-build.sh my-image:dev /path/ke/project
```

---

### D. CI mode (tanpa UI, buat lulus/gagal)

```bash
./scripts/dive-ci.sh nginx:latest
```

Mode ini pakai aturan dari file `.dive-ci`.

Contoh gunanya:
- cek wasted space terlalu besar atau tidak
- fail kalau efisiensi image terlalu rendah

---

## Aturan CI sekarang

File `.dive-ci` saat ini diset cukup ramah:

- `lowestEfficiency: 0.90`
- `highestWastedBytes: 50MB`
- `highestUserWastedPercent: 0.20`

Kalau Ayang mau lebih ketat, tinggal ubah nilainya.

---

## Mode PRO: pahami image sampai bisa bikin ulang

Kalau target Ayang bukan cuma audit, tapi juga:
- paham image ini jalan bagaimana
- paham urutan pembangunannya
- punya kerangka untuk membuat ulang

pakai ini:

```bash
./scripts/full-analysis.sh nginx:latest
```

Script ini akan membuat folder:

```text
output/<nama-image>/
```

isi utamanya:

- `inspect.json` → metadata runtime image
- `history.txt` → urutan layer/build history
- `image.tar` → export image mentah
- `extracted/` → isi tar image
- `reconstructed.Dockerfile` → Dockerfile hasil rekonstruksi perkiraan
- `layer-explanations.md` → penjelasan otomatis tiap layer
- `BUILD-STORY.md` → cerita urutan build dari layer awal sampai akhir
- `LEARN-ME.md` → panduan baca image langkah demi langkah

---

## Cara baca hasil analisis

### 1) Mulai dari `LEARN-ME.md`
File ini adalah panduan ringkas yang menjelaskan:
- image ini untuk apa
- entrypoint/cmd-nya apa
- env pentingnya apa
- folder mana yang harus dibaca dulu

### 2) Lihat `inspect.json`
Di sini Ayang bisa lihat:
- `Env`
- `Entrypoint`
- `Cmd`
- `WorkingDir`
- arsitektur dan ukuran image

Ini menjawab:
> "image ini ketika dijalankan sebenarnya mengeksekusi apa?"

### 3) Lihat `history.txt`
Di sini Ayang bisa lihat:
- urutan layer
- command build yang pernah dijalankan
- bagian mana yang menambah size

Ini menjawab:
> "image ini dibangun lewat langkah apa saja?"

### 4) Lihat `reconstructed.Dockerfile`
Ini bukan Dockerfile asli 100%, tapi **kerangka rekonstruksi** dari history.

Cocok untuk:
- belajar pola build image
- memulai clone/ulang image
- menulis ulang Dockerfile yang lebih rapi

### 5) Lihat `extracted/`
Kalau mau lebih dalam, Ayang bisa buka:
- `manifest.json`
- config JSON image
- layer tar per layer

Ini menjawab:
> "isi image ini sebenarnya apa saja?"

### 6) Lihat `layer-explanations.md`
Ini file yang menjelaskan layer satu per satu dalam bahasa yang lebih gampang dipahami.

Contohnya:
- layer ini install package
- layer ini copy file
- layer ini set env/cmd/workdir
- layer ini cuma metadata

Ini menjawab:
> "layer ini gunanya apa dan efeknya apa ke image?"

### 7) Lihat `BUILD-STORY.md`
Ini adalah ringkasan urutan build dalam bentuk cerita:
- mulai dari base filesystem
- install package
- copy file
- set workdir
- set cmd
- metadata akhir

Ini menjawab:
> "kalau image ini dibangun dari nol, urutan logisnya seperti apa?"

---

## Kenapa pakai Dive?

Dari repo aslinya, `dive` unggul untuk:
- eksplor isi image per layer
- melihat file yang ditambah/diubah/dihapus
- menghitung efisiensi image
- mode CI untuk quality gate

Jadi project ini sekarang punya:
- **mode cepat** untuk inspect dasar
- **mode visual/interaktif** via `dive`
- **mode CI** untuk audit image

---

## Catatan penting

Semua mode `dive` di sini butuh akses ke Docker host yang sama lewat:

```text
/var/run/docker.sock
```

Kalau image ada di host Docker yang sama, script ini bisa dipakai langsung.

Wrapper image `dive` akan dibuild otomatis saat pertama kali script `dive-*` dijalankan.

---

## Uji kelayakan sebelum dipakai/deploy

Jalankan ini:

```bash
./scripts/self-test.sh
```

Script ini akan mengecek:
- image helper bisa dibuild
- inspect dasar jalan
- `dive` CI jalan
- mode PRO jalan
- file output penting berhasil dibuat

Kalau hasilnya `PASS`, project cukup siap untuk dicoba lagi besok.
