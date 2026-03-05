Aşağıdaki gereksinimlere göre production-level, tablet odaklı bir Flutter uygulaması geliştirmeni istiyorum. Kod temiz mimaride, modüler, scalable ve null-safety uyumlu olmalı.

1️⃣ TASARIM REFERANSI (ÇOK ÖNEMLİ)

Proje dizininde Stitch kullanılarak oluşturulmuş UI tasarımları bulunmaktadır.

Flutter uygulamasının arayüzünü bu tasarımları referans alarak oluştur.

Klasör yapısı:
ornek_tasarim/
  ana_sayfa_light/
    code.html
    screen.png

  ana_sayfa_dark/
    code.html
    screen.png

  bilim_insani_detay_light_tema/
    code.html
    screen.png

  bilim_insani_detay_dark_tema/
    code.html
    screen.png

  ayarlar_light_tema/
    code.html
    screen.png

  ayarlar_dark_tema/
    code.html
    screen.png

    UI geliştirirken:

screen.png görsel düzeni referans alınmalı

code.html içindeki CSS değerleri Flutter widget yapılarına çevrilmeli

spacing, padding, radius, shadow ve font size değerleri korunmalı

tasarıma mümkün olduğunca görsel olarak yakın bir Flutter UI oluşturulmalı

Not:

Tasarım birebir kopyalanmak zorunda değil fakat layout, component hiyerarşisi ve stil mantığı korunmalıdır.

2️⃣ PROJE AMACI

Tablet (landscape) için çalışan bir bilim insanı tanıtım uygulaması geliştirilecek.

Tanıtılacak bilim insanları:

Harezmi

Ali Kuşçu

İbn-i Sina

Uluğ Bey

Cahit Arf

Her bilim insanı için:

fotoğraf

hakkında metni

eser listesi

sesli anlatım

bulunacaktır.

3️⃣ CİHAZ KISITLAMASI

Uygulama sadece tablet cihazlar için tasarlanacaktır.

Kurallar:

sadece landscape orientation

portrait tamamen kapalı

tablet responsive layout

minimum genişlik 900px düşünülmeli

büyük ekran spacing kullanılmalı

UI elemanları mobil gibi sıkışık olmamalı

4️⃣ ANA SAYFA TASARIMI

Ana sayfa layout'u şu şekilde olmalıdır:

        Harezmi           Ali Kuşçu


             Cahit Arf


        İbn-i Sina        Uluğ Bey


    Yerleşim:

Sol üst → Harezmi
Sağ üst → Ali Kuşçu
Sol alt → İbn-i Sina
Sağ alt → Uluğ Bey
Merkez → Cahit Arf

Kart Tasarımı

Cahit Arf:

circular container

büyük kart

merkezde

shadow

modern card

Diğer bilim insanları:

rectangular card

aynı boyut

image + name

Kart özellikleri:

border radius

box shadow

BoxFit.cover

responsive cropping

tıklanabilir görünüm

Kart tıklanınca detay sayfası açılmalıdır.

5️⃣ DETAY SAYFASI

Detay sayfası tablet için iki sütunlu layout kullanmalıdır.

Sol sütun

bilim insanı fotoğrafı

isim

kısa bilgi

Sağ sütun

İki ayrı bölüm:

HAKKINDA BÖLÜMÜ

Ayrı bir Card/Container.

Başlık:
    Hakkında

    İçerik:

multiline text

scrollable

edit mode

Edit özellikleri:

düzenle butonu

multiline TextField

maksimum 2000 karakter

kaydet butonu

Kaydedilen veri kalıcı saklanmalıdır.

ESERLERİ BÖLÜMÜ

Ayrı bir Card/Container.

Başlık:

Eserleri

Özellikler:

liste halinde

ListView.builder

her eser ayrı satır

edit ve delete ikonları

Kullanıcı:

eser ekleyebilir

eser silebilir

eser düzenleyebilir

Model yapısı:

String about
List<String> works

Bu iki veri asla aynı TextField içinde birleşmemelidir.

6️⃣ SESLİ ANLATIM

Detay sayfasında audio player bulunmalıdır.

Özellikler:

play / pause

progress bar

kulaklık ikonu

lifecycle yönetimi

Paket:

just_audio

En güncel stabil versiyon kullanılmalı.

7️⃣ AYARLAR SAYFASI

Ayrı bir ekran olacak.

Bu ekran uygulamanın tüm yönetimini sağlar.

Tema Yönetimi

Light Mode
Dark Mode

Özellikler:

anlık değişim

global theme state

tercih kalıcı saklanmalı

Görsel Yönetimi

Her bilim insanı için:

küçük profil görseli

görsel değiştirme butonu

Kullanıcı:

galeriden fotoğraf seçebilir

fotoğraf kalıcı saklanır

Paket:

image_picker
İçerik Yönetimi

Ayarlar sayfasından:

hakkında metni düzenlenebilir

eser listesi düzenlenebilir

8️⃣ VERİ KALICILIĞI

Kalıcı veri yönetimi:

küçük ayarlar için:

shared_preferences

görseller ve içerik için:

sqflite

Alternatif olarak JSON serialization kullanılabilir.

9️⃣ PAKET YÖNETİMİ

Şunlara mutlaka uy:

pub.dev üzerinden en güncel sürümler

deprecated API kullanma

Flutter stable uyumlu

Paketler:

just_audio

image_picker

shared_preferences

sqflite

provider veya riverpod

10️⃣ MİMARİ

Temiz klasör yapısı:

lib/

models/
screens/
widgets/
services/
providers/
utils/

State management:

Provider veya Riverpod.

Tema yönetimi global state üzerinden yapılmalıdır.

11️⃣ NAVIGATION

Navigation yapısı:

Ana Sayfa
→ Detay Sayfası
→ Ayarlar Sayfası

Detay sayfasında:

sol üstte geri butonu bulunmalı.

12️⃣ TASARIM KRİTERLERİ

UI özellikleri:

modern

minimal

tablet optimized

Material 3

büyük padding

yuvarlak köşeler

soft shadows

Light ve Dark tema uyumlu olmalıdır.

13️⃣ ÇIKTI

Claude şu çıktıları üretmelidir:

pubspec.yaml

main.dart

tüm klasör yapısı

tüm dart dosyaları

model sınıfları

provider yapısı

tema sistemi

ana sayfa

detay sayfası

ayarlar sayfası

audio servisi

veri saklama yapısı

Kod eksiksiz ve çalıştırılabilir olmalıdır.