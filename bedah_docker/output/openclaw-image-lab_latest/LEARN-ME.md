# Learn Me: openclaw-image-lab:latest

Panduan ini dibuat supaya image bisa dipelajari, bukan cuma diaudit.

## 1. Mulai dari runtime-summary.txt
Lihat file ini dulu untuk memahami:
- image ini jalan di OS/arsitektur apa
- working directory-nya apa
- entrypoint/cmd-nya apa
- environment variable pentingnya apa

## 2. Lanjut ke history.txt
File ini menunjukkan urutan layer dan command build.
Dari sini Ayang bisa lihat:
- kapan package diinstall
- kapan file disalin
- layer mana yang paling berat

## 3. Lihat reconstructed.Dockerfile
Ini kerangka Dockerfile hasil rekonstruksi.
Pakai ini sebagai titik awal kalau Ayang mau menulis ulang image.

## 4. Buka folder extracted/
Di situ ada hasil extract image tar:
- manifest.json
- config image
- layer tar per layer

## 5. Tujuan akhir
Setelah baca 4 file/folder di atas, Ayang biasanya bisa jawab:
- image ini menjalankan apa?
- image ini dibangun lewat urutan apa?
- bagian mana yang paling penting untuk direplikasi?
- bagaimana memulai membuat ulang image ini?

## File utama
- inspect.json
- runtime-summary.txt
- history.txt
- reconstructed.Dockerfile
- layer-explanations.md
- BUILD-STORY.md
- extracted/
