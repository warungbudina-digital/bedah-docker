# Troubleshooting Docker Image Lab

Panduan ini dipakai saat project bedah docker error atau hasilnya tidak keluar seperti yang diharapkan.

## 1) Cek Docker hidup atau tidak

```bash
docker ps
docker version
docker info
```

Kalau gagal di sini, masalahnya biasanya bukan di project, tapi di Docker host.

---

## 2) Cek build helper image

```bash
docker compose build
```

Kalau gagal:
- cek koneksi internet
- cek permission Docker
- cek error package install di output build

---

## 3) Cek inspect dasar

```bash
docker compose run --rm image-lab sh /work/scripts/inspect-image.sh nginx:latest
```

Kalau gagal:
- pastikan image target ada:

```bash
docker images
```

- atau pull dulu:

```bash
docker pull nginx:latest
```

---

## 4) Cek Dive wrapper

```bash
./scripts/dive-ci.sh nginx:latest
```

Kalau gagal:
- cek apakah `wagoodman/dive:latest` bisa di-pull
- cek apakah Docker socket tersedia

```bash
ls -l /var/run/docker.sock
```

---

## 5) Cek mode PRO

```bash
./scripts/full-analysis.sh nginx:latest
```

Kalau gagal:
- cek apakah folder `output/` bisa ditulis
- cek apakah image bisa di-`docker save`

```bash
docker save nginx:latest -o /tmp/test-image.tar
ls -lh /tmp/test-image.tar
```

---

## 6) Gejala umum dan arah solusinya

### A. `Cannot connect to the Docker daemon`
Penyebab:
- Docker daemon mati
- user tidak punya akses Docker

Solusi:
- hidupkan Docker
- pastikan user punya permission

### B. `image not found`
Penyebab:
- image target belum ada lokal

Solusi:
- `docker pull <image>`
- atau build dulu image target

### C. `permission denied` pada socket
Penyebab:
- user/container tidak boleh akses `/var/run/docker.sock`

Solusi:
- cek permission socket
- cek group Docker

### D. `dive` timeout / lama
Penyebab:
- image besar
- host lambat

Solusi:
- coba image lebih kecil dulu
- jalankan mode inspect dasar lebih dulu

### E. Output folder tidak lengkap
Penyebab:
- script berhenti di tengah
- image gagal di-save atau di-extract

Solusi:
- jalankan ulang script satu-satu:
  - `export-image.sh`
  - `reconstruct-dockerfile.sh`
  - `explain-layers.sh`
  - `build-story.sh`

---

## 7) Jalur troubleshooting paling aman

Kalau error, urutkan begini:

1. `docker ps`
2. `docker compose build`
3. `inspect-image.sh`
4. `dive-ci.sh`
5. `full-analysis.sh`
6. cek folder `output/`

Dengan urutan ini, masalah biasanya cepat ketemu apakah ada di:
- Docker host
- image target
- Dive wrapper
- atau script analisis
