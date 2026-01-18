# Debug Flutter dengan Chrome/Edge Windows di WSL

## Setup Awal

### 1. Set Environment Variable Chrome/Edge

Tambahkan ke `~/.bashrc` atau `~/.zshrc`:

```bash
# Chrome (pilih salah satu lokasi yang ada)
export CHROME_EXECUTABLE="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"
# atau
export CHROME_EXECUTABLE="/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe"

# Atau gunakan Edge
export CHROME_EXECUTABLE="/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe"
```

Reload:
```bash
source ~/.bashrc
```

### 2. Verifikasi Browser Terdeteksi

```bash
cd /var/www/mylab-ui-flutter
flutter devices
```

Output yang diharapkan:
```
Edge (web) • edge • web-javascript • Microsoft Edge
Chrome (web) • chrome • web-javascript • Google Chrome
```

## Cara Menjalankan

### Opsi 1: Menggunakan Script (Recommended)

```bash
cd /var/www/mylab-ui-flutter

# Gunakan Edge
./scripts/run-chrome.sh edge

# Atau gunakan Chrome
./scripts/run-chrome.sh chrome
```

### Opsi 2: Command Flutter Langsung

```bash
cd /var/www/mylab-ui-flutter

# Dengan Edge
flutter run -d edge \
  --web-hostname 0.0.0.0 \
  --web-port 36883 \
  --web-browser-flag="--remote-debugging-port=9222"

# Dengan Chrome
flutter run -d chrome \
  --web-hostname 0.0.0.0 \
  --web-port 36883 \
  --web-browser-flag="--remote-debugging-port=9222"
```

### Opsi 3: VS Code Launch Configuration

Tekan `F5` atau gunakan menu Debug di VS Code, pilih:
- "Flutter Web (Edge Windows)" 
- "Flutter Web (Chrome Windows)"

## Hot Reload & Debugging

Setelah Flutter berjalan:

### Hot Reload (tanpa restart state)
- Tekan `r` di terminal
- Atau save file di VS Code (auto hot reload)

### Hot Restart (reset state)
- Tekan `R` di terminal

### DevTools Debugging
1. Browser akan terbuka otomatis di Windows
2. Flutter DevTools tersedia di: `http://localhost:9100`
3. Chrome DevTools remote: `chrome://inspect` atau `edge://inspect`

### Breakpoints di VS Code
1. Set breakpoint di file Dart (klik kiri nomor baris)
2. Jalankan dengan F5 (debug mode)
3. Breakpoint akan pause saat kode dijalankan

## Troubleshooting

### Browser tidak terbuka
```bash
# Cek apakah browser path benar
ls -la "$CHROME_EXECUTABLE"

# Coba jalankan manual
"$CHROME_EXECUTABLE" --version
```

### Port sudah digunakan
```bash
# Cek proses di port 36883
lsof -i :36883

# Kill proses
kill $(lsof -t -i:36883)

# Atau gunakan port lain
PORT=38000 ./scripts/run-chrome.sh edge
```

### Flutter tidak terdeteksi Edge/Chrome
```bash
# Install extension Flutter di VS Code
# Restart VS Code
# Jalankan:
flutter doctor -v
```

### CORS Error
Script sudah include `--disable-web-security` untuk development.
Jangan gunakan flag ini di production!

## Keuntungan Debugging dengan Browser Windows

1. **Full DevTools**: Inspect element, console, network tab
2. **Hot Reload**: Perubahan kode langsung terlihat
3. **Breakpoints**: Debug step-by-step di VS Code
4. **Performance**: Lebih cepat dari web-server mode
5. **Responsive Testing**: Gunakan browser responsive mode

## Network Access dari Host Windows

Jika ingin akses dari browser lain di Windows:
1. Flutter sudah running di `0.0.0.0:36883`
2. Dari Windows, akses: `http://WSL_IP:36883`
3. Cari WSL IP: `ip addr show eth0 | grep inet`

Contoh: `http://172.28.192.1:36883`

## Stop Flutter

```bash
# Jika running di background
kill $(cat /var/www/mylab-ui-flutter/dev-chrome.pid)

# Atau Ctrl+C di terminal
```
