Mevcut Flutter projesi büyük ölçüde tamamlandı ve çalışıyor. Projeyi baştan yazma. Sadece aşağıdaki değişiklikleri yap. Mevcut çalışan sistemi bozma.

GENEL KURAL
- Sadece gerekli yerleri değiştir.
- Mevcut çalışan özellikleri koru.
- Kod derlenebilir, çalışabilir ve temiz kalsın.
- Material 3 uyumlu, modern ve responsive yapı korunmalı.
- Gerekirse internetten yardım alabilirsin.

ÖNEMLİ: KORUNMASI GEREKEN ÖZELLİKLER
Aşağıdaki özellikler kesinlikle korunmalı, kaldırılmamalı ve bozulmamalı:

- bilim insanı ses dosyası ekleme sistemi
- ses oynatma sistemi
- ayarlardan ses dosyası değiştirme
- bilim insanı sayfasında otomatik ses oynatma
- tema ayarı (Light / Dark)
- içerik yönetimi sistemi
- ayarlara parola ile giriş (şifre: 1881)
- karşılama ekranı (sadece ilk açılışta gösterilen onboarding)
- bilim insanı fotoğraf değiştirme sistemi
- bilim insanı hakkında metni düzenleme sistemi
- bilim insanı eserleri düzenleme sistemi

Do not refactor the audio system unless necessary.

1) SADECE ŞU ÖZELLİKLERİ KALDIR
Aşağıdaki iki özelliği projeden tamamen kaldır:

- uygulama ikonunu değiştirme
- uygulama adını değiştirme

Yapılması gerekenler:
- Ayarlar / İçerik Yönetimi içindeki bu iki menüyü kaldır.
- Bu iki özellikle ilgili ekranları kaldır.
- Bu iki özellikle ilgili gereksiz widget, service, helper ve provider kodlarını temizle.
- Kullanılmayan importları kaldır.
- Kullanılmayan paketleri pubspec.yaml dosyasından kaldır.
- Mevcut yüklü gelen uygulama adı ve uygulama ikonu aynen kalsın.

2) AYARLAR MENÜSÜNÜ GÜNCELLE
Ayarlar ekranı sade ve düzenli kalsın.

Ayarlar içinde şu yapı olsun:

- İçerik Yönetimi
- Hakkında

İçerik Yönetimi içinde şunlar kalmalı:
- tema ayarı (Light / Dark)
- bilim insanlarının fotoğraflarını değiştirme
- bilim insanlarının ses dosyalarını değiştirme
- bilim insanlarının hakkında metinlerini düzenleme
- bilim insanlarının eserlerini düzenleme

Hakkında sayfasında şunlar olsun:
- uygulama adı
- sürüm bilgisi
- geliştiriciler
- kısa açıklama

Hakkında sayfası sadece okunabilir olsun.

3) UI / UX İYİLEŞTİRMESİ YAP
Mevcut tasarım dilini bozma ama görünümü iyileştir.

Şunları düzenle:
- ana sayfa kart boyutları
- spacing
- padding
- font boyutları
- hizalama
- buton yerleşimi

Amaç:
- telefon ve tablette daha dengeli görünüm
- kartların üst üste binmemesi
- boşlukların düzgün olması
- ekranın daha profesyonel görünmesi

4) HOME BAR / SİSTEM BAR ÇAKIŞMASINI DÜZELT
Uygulamada bazı yerlerde sistem alanlarıyla çakışma olabiliyor.

Bunu tamamen düzelt:
- SafeArea doğru kullanılsın
- üst status bar ile çakışma olmasın
- alt navigation / home bar ile çakışma olmasın
- geri tuşu, alt sistem alanı ve UI elemanları birbirinin üstüne gelmesin
- telefon ve tabletlerde tüm sayfalar güvenli alan içinde kalsın

5) RESPONSIVE YAPIYI KORU VE İYİLEŞTİR
Uygulama şu cihazlarda düzgün çalışmalı:
- telefon
- küçük tablet
- büyük tablet

Şunlar ekran boyutuna göre dengelensin:
- kart boyutları
- spacing
- padding
- text size
- icon size
- image size

Overflow, clipping ve görünmeyen buton sorunları tamamen giderilsin.

6) BİLİM İNSANI DETAY SAYFALARINI GÖRSEL OLARAK İYİLEŞTİR
Detay sayfalarında kullanılan arka plan sembolleri daha estetik olsun.

Kurallar:
- emoji kullanma
- modern, minimal, vektör benzeri dekoratif semboller kullan
- düşük opaklıkla arka planda yer alsın
- metni kapatmasın
- responsive olsun
- profesyonel görünsün

Örnek temalar:
- Harezmi → matematik sembolleri
- Ali Kuşçu → astronomi sembolleri
- İbn-i Sina → tıp / el yazması / şifa temaları
- Uluğ Bey → yıldız haritası / gözlem teması
- Cahit Arf → matematik formülleri / cebirsel yapılar

7) PERFORMANS OPTİMİZASYONU YAP
Uygulamayı optimize et ama çalışan yapıyı bozma.

Şunları yap:
- gereksiz rebuild’leri azalt
- mümkün olan yerlerde StatelessWidget kullan
- tekrar eden UI parçalarını ayrı widgetlara böl
- gereksiz state kullanımını azalt
- kullanılmayan kodları temizle
- kullanılmayan importları kaldır
- gereksiz paketleri kaldır
- navigation akışını sadeleştir ama bozma
- görsel yükleme ve layout hesaplamalarını optimize et

Amaç:
- uygulama daha hızlı açılsın
- daha akıcı çalışsın
- daha az bellek kullansın

8) MEVCUT ÖZELLİKLERİ BOZMA
Tekrar hatırlatma:
Aşağıdaki sistemlere dokunma, sadece gerektiği kadar koru:

- ses sistemi
- tema sistemi
- parola koruması
- onboarding / karşılama ekranı
- içerik yönetimi
- bilim insanı içerikleri
- fotoğraf ve ses seçme alanları

Sadece uygulama adı değiştirme ve uygulama ikonu değiştirme özelliklerini kaldır.

9) ÇIKTI
Aşağıdakileri ver:
- değiştirilen dart dosyaları
- kaldırılan kodların kısa özeti
- yapılan UI iyileştirmeleri
- yapılan performans optimizasyonları
- gerekiyorsa güncellenmiş pubspec.yaml

Kod eksiksiz, derlenebilir ve çalışır durumda olmalı.