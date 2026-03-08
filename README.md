# Bilim İnsanları Uygulaması

> İslam dünyasının yetiştirdiği büyük bilim insanlarını keşfet.

---

## Proje Hakkında

**Bilim İnsanları**, Flutter ile geliştirilmiş, telefon ve tablet ekranlarında tamamen uyumlu (responsive) bir mobil uygulamadır. Harezmi, Ali Kuşçu, İbn-i Sina, Uluğ Bey ve Cahit Arf gibi bilim insanlarını; fotoğraf, detaylı biyografi, eserleri ve sesli anlatımla tanıtır.

---

## Özellikler

| # | Özellik | Açıklama |
|---|---------|----------|
| 1 | Responsive Tasarım | Telefon, küçük/orta/büyük tablet ekranları için otomatik layout |
| 2 | Açık / Koyu Tema | Material 3 uyumlu, anlık tema değişimi |
| 3 | Sesli Anlatım | Her bilim insanı için ayrı ses dosyası, otomatik oynatma |
| 4 | Tematik Arka Plan | Her bilim insanına özgü dekoratif CustomPaint görseller |
| 5 | Görünüm Ölçeği | Otomatik / Küçük / Orta / Büyük ölçek seçeneği |
| 6 | İçerik Yönetimi | Fotoğraf, ses, biyografi ve eserler düzenlenebilir |
| 7 | Güvenli Ayarlar | Parola korumalı yönetici paneli |
| 8 | Kalıcı Saklama | Tüm veriler ve tercihler SharedPreferences + SQLite ile saklanır |
| 9 | Onboarding Ekranı | Uygulama ilk açılışında animasyonlu karşılama ekranı |

---

## Bilim İnsanları

| İsim | Alan | Dönem |
|------|------|-------|
| Harezmi | Matematik & Algoritma | 780 – 850 |
| Ali Kuşçu | Astronomi | 1403 – 1474 |
| İbn-i Sina | Tıp & Felsefe | 980 – 1037 |
| Uluğ Bey | Astronomi & Matematik | 1394 – 1449 |
| Cahit Arf | Matematik | 1910 – 1997 |

---

## Ekran Görünümleri

### Breakpoint Sistemi

| Tip | Genişlik | Kart Düzeni |
|-----|----------|-------------|
| Telefon | ≤ 599 dp | 2 sütun, 3 satır |
| Küçük Tablet | 600 – 839 dp | 3 sütun, 2 satır |
| Orta Tablet | 840 – 1199 dp | 5 kart tek satır |
| Büyük Tablet | ≥ 1200 dp | 5 kart tek satır (geniş) |

- **Telefon detay sayfası:** Dikey (tek sütun) layout
- **Tablet detay sayfası:** İki kolonlu; sol = fotoğraf + isim, sağ = biyografi + eserler + ses oynatıcı

---

## Proje Yapısı

```
lib/
├── main.dart                  # Uygulama giriş noktası
├── models/
│   └── scientist.dart         # Bilim insanı veri modeli
├── providers/
│   └── app_state.dart         # Global state (Provider)
├── screens/
│   ├── home_screen.dart       # Ana ekran – kart grid
│   ├── detail_screen.dart     # Detay & ses oynatıcı
│   ├── settings_screen.dart   # Ayarlar & yönetim
│   ├── login_screen.dart      # Parola girişi
│   └── onboarding_screen.dart # İlk açılış ekranı
├── services/
│   ├── audio_service.dart     # Ses oynatma (just_audio)
│   ├── auth_service.dart      # Parola & oturum (sqflite)
│   └── storage_service.dart   # Veri saklama (SharedPreferences)
├── utils/
│   ├── app_theme.dart         # Material 3 tema (light/dark)
│   └── responsive_helper.dart # Breakpoint & ölçek hesaplama
└── widgets/
    └── scientist_background.dart  # Tematik CustomPaint arka planlar
```

---

## Kullanılan Teknolojiler

| Paket | Amaç |
|-------|------|
| `flutter` + `dart` | Framework |
| `provider` | State management |
| `shared_preferences` | Tercih kalıcılığı |
| `sqflite` + `path` | SQLite veritabanı |
| `just_audio` | Ses oynatma |
| `google_fonts` | Özel yazı tipi (Public Sans) |
| `image_picker` | Fotoğraf seçme |
| `image_cropper` | Fotoğraf kırpma |
| `file_picker` | Dosya seçme (ses) |
| `path_provider` | Dosya sistemi yolları |

---

## Kurulum & Çalıştırma

```bash
# Bağımlılıkları kur
flutter pub get

# Uygulamayı çalıştır
flutter run

# Release APK derle
flutter build apk --release
```

**Derlenen APK:** `build/app/outputs/flutter-apk/app-release.apk`

---

## Güvenlik

- Ayarlar paneline parola koruması uygulanmıştır.
- `SafeArea` kullanılarak sistem çubuğu çakışmaları önlenmiştir.
- Kullanıcı verileri yalnızca cihaz üzerinde saklanır; hiçbir veri dışarıya gönderilmez.

---

## Geliştirme Notları

- `flutter analyze` → Hata yok
- `flutter build apk --release` → Başarılı (52.9 MB)
- Minimum SDK: Android API 21+ (Android 5.0)
- Tüm yönlendirmeler aktif (portre + yatay)

---

*Uygulama eğitim amaçlı geliştirilmiştir.*

