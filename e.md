Mevcut Flutter projesinde aşağıdaki sorunları düzeltmeni ve yeni özellikleri eklemeni istiyorum. Tüm değişiklikler çalışır, derlenebilir ve responsive şekilde uygulanmalı.

Oranlama ve responsive yapı konusunda daha genel ve güçlü bir çözüm istiyorum.

Uygulama sadece 8 inç tablet için değil, farklı ekran boyutlarında da düzgün çalışmalı.
Yani uygulama:
- telefonlarda
- küçük tabletlerde
- orta boy tabletlerde
- büyük tabletlerde

doğru oranlama ile çalışmalı.

Bu yüzden çözüm 8 inçe özel sabit bir düzen olmasın.
Breakpoint tabanlı ve dinamik ölçü hesaplamalı bir responsive sistem kur.

İstediğim yapı:

1. Uygulama açıldığında ekran boyutunu algılasın.
2. Kart boyutları, spacing, padding, font size, ikon boyutu ve görsel alanları ekran genişliği/yüksekliğine göre otomatik hesaplansın.
3. Ana sayfa varsayılan olarak mümkün olduğunca tek ekrana sığsın.
4. Scroll sadece son çare olsun, varsayılan çözüm olmasın.
5. Sabit width/height kullanma; oran bazlı ve breakpoint tabanlı yapı kur.
6. Farklı ekran grupları için düzen oluştur:
   - phone
   - small tablet
   - medium tablet
   - large tablet
7. Her grupta home screen, detail screen ve settings screen düzgün görünmeli.
8. Merkezdeki bilim insanı kartı ile diğer kartlar arasında dengeli oran kurulmalı.
9. Kartlar bazı cihazlarda fazla büyük, bazı cihazlarda fazla küçük kalmamalı.
10. Bilim insanı kartlarının tamamı mümkün olduğunca ilk açılışta görünür olmalı.

Ek olarak ayarlara bir seçenek ekle:

“Görünüm Ölçeği”
- Otomatik
- Küçük
- Orta
- Büyük

Kurallar:
- Varsayılan değer “Otomatik” olsun.
- Otomatik modda uygulama cihaz boyutuna göre en uygun oranlamayı kendisi seçsin.
- Kullanıcı isterse manuel olarak görünümü büyütüp küçültebilsin.
- Bu tercih kalıcı olarak saklansın.
- Ölçek değişince home, detail ve settings ekranları buna göre yeniden hesaplanmalı.

Teknik beklenti:
- Responsive helper / screen class oluştur
- Breakpoint, scale factor ve adaptive spacing sistemi kur
- LayoutBuilder, MediaQuery, Flexible, Expanded, Wrap, AspectRatio gibi yapıları gerektiği yerde kullan
- Hardcoded ölçülerden kaçın
- Overflow, clipping ve görünmeyen buton sorunlarını tamamen çöz

Amaç:
Uygulama hangi tablet veya telefon boyutunda açılırsa açılsın düzgün görünmeli; kullanıcı gerekirse ayarlardan görünüm ölçeğini değiştirebilmeli.