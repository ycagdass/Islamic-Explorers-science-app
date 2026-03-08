# Bilim İnsanları Uygulaması / Scientists App

---

## 🇹🇷 Türkçe

### Proje Hakkında

Bu uygulama, İslam dünyasının önemli bilim insanlarını tanıtmak amacıyla geliştirilmiş bir Flutter mobil uygulamasıdır. Harezmi, İbn-i Sina, El-Biruni ve daha fazlası hakkında detaylı bilgi, fotoğraf ve sesli anlatım içerir.

### Özellikler

- 📱 Telefon ve tablet desteği (dinamik responsive tasarım)
- 🌙 Açık / Koyu tema
- 🔊 Bilim insanı başına sesli anlatım
- 🖼️ Özelleştirilebilir fotoğraf ve içerik yönetimi
- ⚖️ Görünüm ölçeği ayarı (Otomatik / Küçük / Orta / Büyük)
- 💾 Tüm tercihler kalıcı olarak saklanır

### Desteklenen Ekran Boyutları

| Tip | Genişlik |
|-----|----------|
| Telefon | ≤ 599 dp |
| Küçük Tablet | 600 – 839 dp |
| Orta Tablet | 840 – 1199 dp |
| Büyük Tablet | ≥ 1200 dp |

### Kurulum & Çalıştırma

```bash
flutter pub get
flutter run
```

### APK Derleme

```bash
flutter build apk --release
```

---

## 🇬🇧 English

### About

A Flutter mobile application that introduces prominent scientists from the Islamic world. Includes detailed information, photos, and audio narration for figures such as Al-Khwarizmi, Ibn Sina, Al-Biruni, and more.

### Features

- 📱 Phone & tablet support (dynamic responsive design)
- 🌙 Light / Dark theme
- 🔊 Per-scientist audio narration
- 🖼️ Customizable photo and content management
- ⚖️ Display scale setting (Auto / Small / Medium / Large)
- 💾 All preferences saved persistently

### Supported Screen Sizes

| Type | Width |
|------|-------|
| Phone | ≤ 599 dp |
| Small Tablet | 600 – 839 dp |
| Medium Tablet | 840 – 1199 dp |
| Large Tablet | ≥ 1200 dp |

### Setup & Run

```bash
flutter pub get
flutter run
```

### Build APK

```bash
flutter build apk --release
```

---

## Teknik Detaylar / Technical Details

- **Framework:** Flutter 3.x
- **State Management:** Provider
- **Local Storage:** SharedPreferences + sqflite
- **Audio:** just_audio
- **Image:** image_picker, image_cropper

