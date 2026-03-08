Mevcut Flutter projesinde aşağıdaki sorunları düzeltmeni ve yeni özellikleri eklemeni istiyorum. Tüm değişiklikler çalışır, derlenebilir ve responsive şekilde uygulanmalı.

Mevcut Flutter projesinde aşağıdaki değişiklikleri uygula. Tüm kod çalışır, derlenebilir ve responsive olacak şekilde düzenlenmeli.

GENEL KURALLAR

- Uygulama hem telefon hem tablet ekranlarında düzgün çalışmalı.
- Özellikle 7–12 inç tabletler için optimize edilmiş responsive düzen olmalı.
- UI Material 3 uyumlu modern ve temiz olmalı.
- Layout taşmaları, üst üste binmeler ve görünmeyen butonlar tamamen düzeltilmeli.
- Kod modüler ve okunabilir olmalı.

1) ANA SAYFA RESPONSIVE SORUNLARINI DÜZELT

Ana ekranda bilim insanı kartlarının boyutları bazı tabletlerde çok büyük kalıyor.

Bunu şu şekilde çöz:

- Kart boyutları ekran genişliğine göre otomatik hesaplanmalı.
- Kartlar responsive olmalı.
- Scroll varsayılan çözüm olmamalı.
- Kartların mümkün olduğunca ilk ekranda görünmesi sağlanmalı.

Bilim insanı kartları:

- Yuvarlak tasarım kullan.
- Kart boyutu ekran boyutuna göre hesaplanmalı.
- Spacing dengeli olmalı.

Gerekirse şu yapıları kullan:

- LayoutBuilder
- MediaQuery
- Flexible
- Expanded
- Wrap
- Breakpoint sistemi

2) HOME BAR / SİSTEM BAR ÇAKIŞMASINI DÜZELT

Uygulamanın üst kısmı sistem bar ile çakışıyor.

Bunu çözmek için:

- SafeArea kullan
- Sistem inset'lerini dikkate al
- Status bar veya notch ile çakışma olmasın

3) DETAY SAYFASI RESPONSIVE OLSUN

Bilim insanı detay sayfasında ses butonu bazı cihazlarda görünmüyor.

Bunu düzelt:

- Ses butonu her zaman görünür olmalı.
- Overflow hataları olmamalı.

Responsive yapı:

Telefonlarda:

- dikey layout

Tabletlerde:

- iki kolonlu layout

Sol taraf:

- bilim insanı fotoğrafı
- isim
- kısa bilgi

Sağ taraf:

- hakkında
- eserleri
- ses oynatıcı

4) BİLİM İNSANLARININ KATKILARI GÖRSEL OLARAK EKLENSİN

Her bilim insanının sayfasında tematik arka plan görselleri olsun.

Örnekler:

Harezmi  
- rakamlar  
- cebir sembolleri  

Ali Kuşçu  
- yıldızlar  
- teleskop  
- astronomi sembolleri  

İbn-i Sina  
- tıp kitapları  
- şifa sembolleri  

Uluğ Bey  
- yıldız haritaları  

Cahit Arf  
- matematik formülleri  

Bu görseller:

- düşük opaklıkta olsun
- dekoratif arka plan gibi görünsün
- metni kapatmasın
- modern ve estetik olsun

5) AYARLAR PAROLA KORUMASI

Ayarlar ekranına giriş parola ile korunsun.

Şifre:

1881

Kurallar:

- doğru parola girilmeden ayarlar açılmasın
- parola doğrulama sistemi devam etsin
- gerekirse sqflite kullanılabilir

6) AYARLAR MENÜ YAPISI

Ayarlar ekranında şu bölümler olsun:

- İçerik Yönetimi
- Hakkında

7) İÇERİK YÖNETİMİ

Bu bölümde uygulamadaki tüm içerikler düzenlenebilir.

Burada şu ayarlar bulunmalı:

- tema ayarı (Light / Dark)
- bilim insanlarının fotoğraflarını değiştirme
- bilim insanlarının ses dosyalarını değiştirme
- bilim insanlarının hakkında metnini düzenleme
- bilim insanlarının eserlerini düzenleme
- uygulama ikonunu değiştirme
- uygulama adını değiştirme

8) UYGULAMA İKONUNU DEĞİŞTİRME

İçerik yönetimi bölümünde:

"Uygulama İkonu" ayarı ekle.

Kullanıcı:

- galeriden bir resim seçebilsin
- resmi düzenleyebilsin

Düzenleme özellikleri:

- crop
- zoom
- ölçeklendirme
- oran ayarı

Bunun için şu paketler kullanılabilir:

image_picker  
image_cropper

Seçilen görsel uygulama ikonu olarak kullanılmalı.

9) UYGULAMA ADINI DEĞİŞTİRME

İçerik yönetimi içinde:

"Uygulama Adı" ayarı ekle.

Kullanıcı:

- uygulama adını değiştirebilsin
- değişiklik kalıcı saklansın

Bu isim:

- ana sayfada
- karşılama ekranında
- gerekli yerlerde gösterilsin.

10) KARŞILAMA EKRANI (ONBOARDING)

Uygulamaya bir karşılama ekranı ekle.

Kurallar:

- sadece uygulama ilk kez açıldığında gösterilsin
- sonraki açılışlarda görünmesin
- shared_preferences ile ilk açılış durumu saklanabilir

Navigation:

İlk açılış:

Karşılama ekranı  
→ Ana Sayfa

Sonraki açılışlar:

Direkt  
→ Ana Sayfa

Karşılama ekranı:

- modern
- minimal
- Material 3 uyumlu
- merkezde uygulama logosu
- kısa karşılama metni
- responsive tasarım

11) PERFORMANS OPTİMİZASYONU

Uygulama hızlı çalışmalı.

Şunları uygula:

- gereksiz rebuild'leri azalt
- ağır widget kullanma
- görselleri optimize et
- stateless widget kullanımı artır
- UI kodlarını ayrı widgetlara böl
- responsive hesaplamaları optimize et

Amaç:

- hızlı açılan
- akıcı çalışan
- stabil bir uygulama.

12) ÇIKTI

Eksiksiz şekilde ver:

- güncellenmiş pubspec.yaml
- main.dart
- tüm değişen dart dosyaları
- yeni widget dosyaları
- responsive helper sınıfları
- navigation güncellemeleri
- içerik yönetimi ekranı
- ikon değiştirme sistemi
- uygulama adı değiştirme sistemi
- karşılama ekranı

Kod eksik bırakılmamalı.

Uygulama derlenebilir ve çalışabilir durumda olmalı.