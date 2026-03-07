Mevcut Flutter projesinde aşağıdaki sorunları düzeltmeni ve yeni özellikleri eklemeni istiyorum. Tüm değişiklikler çalışır, derlenebilir ve responsive şekilde uygulanmalı.

GENEL KURAL
- Uygulama hem tablet hem telefon ekranlarında düzgün görünmeli.
- Özellikle 8 inç tablet için responsive düzen yapılmalı.
- Taşma, üst üste binme, butonların görünmemesi gibi tüm layout sorunları çözülmeli.
- Material 3 uyumlu, modern ve temiz bir UI kullanılmalı.
- Mevcut tasarım dili korunmalı ama UI/UX iyileştirilmeli.

1) ANA SAYFADAKİ ÜST ÜSTE BİNME SORUNU
- Ana ekranda bilim insanı kartları üst üste biniyor, bu sorunu düzelt.
- Kartlar ekran boyutuna göre otomatik konumlanmalı.
- Tüm bilim insanı kartları yuvarlak tasarıma dönüştürülsün.
- Kartların boyutu, spacing ve hizalaması responsive olmalı.
- Küçük ekranlarda taşma olmasın, büyük ekranlarda da boşluklar dengeli olsun.
- Gerekirse LayoutBuilder, MediaQuery, Flexible, Expanded veya responsive grid mantığı kullan.

2) HOME BAR / SİSTEM BAR ÇAKIŞMASI
- Uygulamanın üst kısmı sistem alanı / home bar / status bar ile çakışıyor.
- SafeArea, padding ve sistem inset’leri doğru şekilde kullan.
- Üst içerikler çentiğe, bildirim çubuğuna veya sistem alanına taşmasın.

3) DETAY SAYFASINDA SES BUTONU GÖRÜNMÜYOR
- Bilim insanı detay sayfasında oranlama sorunu nedeniyle ses butonu görünmüyor.
- Detay sayfası tamamen responsive hale getirilmeli.
- Telefon ve tablet için otomatik oranlama yapılmalı.
- Ses butonu her zaman görünür ve erişilebilir olmalı.
- Gerekirse iki kolonlu yapı tablet için, daha dikey yapı telefon için kullanılabilir.
- Overflow ve render hataları tamamen giderilmeli.

4) 8 İNÇ TABLET İÇİN OPTİMİZASYON
- Ekran alanı kısıtlı olduğu için 8 inç tabletlerde özel responsive düzen uygulanmalı.
- Yazılar, kart boyutları, boşluklar ve ikonlar buna göre optimize edilmeli.
- Her sayfa taşma yapmadan kullanılabilir olmalı.

5) BİLİM İNSANLARININ BULUŞLARI / KATKILARI GÖRSEL OLARAK EKLENSİN
Her bilim insanının bulduğu şey veya en önemli katkısı görsel bir şekilde sayfaya entegre edilsin.

İstediğim fikir:
- Bilim insanının sayfasında arka planda düşük opaklıkla onun önemli katkısı gösterilebilir.
- Örneğin Harezmi için rakamlar, matematiksel şekiller veya algoritma temalı görsel öğeler kullanılabilir.
- Bu görsel öğe arka plan süslemesi gibi durmalı, içeriği boğmamalı.
- Opacity düşük olmalı, dikkat dağıtmamalı.
- Bu yapı modern ve estetik görünmeli.

Alternatif olarak:
- Bilim insanının katkısını temsil eden dekoratif bir panel,
- hafif blur’lu arka plan çizimi,
- veya içerik kartının yanında tematik illüstrasyon kullanılabilir.

Bu sistem her bilim insanı için ayrı düşünülmeli.
Örnekler:
- Harezmi → rakamlar / cebirsel semboller
- Ali Kuşçu → astronomi / yıldız / gök cisimleri
- İbn-i Sina → tıp / kitap / şifa teması
- Uluğ Bey → yıldız haritaları / gözlem / astronomi
- Cahit Arf → matematiksel formüller / sayı teorisi / cebirsel simgeler

6) RESPONSIVE TASARIM KURALLARI
- Telefon ve tablet için tek sabit layout kullanma.
- Breakpoint tabanlı yapı kur.
- Küçük ekranlarda içerikler alt alta geçebilsin.
- Büyük ekranlarda daha geniş ve dengeli bir yerleşim olsun.
- Text scale, spacing, button size ve image size ekran boyutuna göre ayarlansın.

7) KOD KALİTESİ
- Kod temiz ve modüler olsun.
- Gerekirse ortak responsive helper veya utils dosyası oluştur.
- Tekrarlı UI kodlarını widget’lara böl.
- Derlenebilir, eksiksiz ve çalışır şekilde teslim et.

8) ÇIKTI
Aşağıdakileri güncellenmiş şekilde ver:
- değişen tüm dart dosyaları
- gerekiyorsa yeni widget dosyaları
- responsive yapı için eklenen yardımcı sınıflar
- hangi sorunun nasıl çözüldüğünü kısa kısa açıkla

Eksik bırakma. Tüm sorunları gerçekten çöz ve çalışan kod üret.