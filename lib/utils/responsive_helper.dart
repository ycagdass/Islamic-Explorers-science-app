import 'package:flutter/material.dart';

// ─── Ekran tipi enum ────────────────────────────────────────────────────────

enum ScreenType { phone, smallTablet, mediumTablet, largeTablet }

// ─── Görünüm ölçeği modu ────────────────────────────────────────────────────

enum AppScaleMode { auto, small, medium, large }

// ─── AppScale: tüm UI ölçümlerini barındıran veri sınıfı ────────────────────

class AppScale {
  /// Ekran tipi (breakpoint tabanlı)
  final ScreenType screenType;

  /// Ölçek çarpanı (0.8 – 1.2)
  final double scaleFactor;

  /// Bilim insanı fotoğraf kartı çapı
  final double cardSize;

  /// Kartlar arası yatay boşluk
  final double cardSpacing;

  /// Kartlar arası dikey boşluk
  final double cardRunSpacing;

  /// Genel sayfa padding
  final EdgeInsets pagePadding;

  /// Detail ekranı sol kolon genişlik oranı (0..1)
  final double detailLeftWidthRatio;

  /// İkon boyutu
  final double iconSize;

  /// Başlık font boyutu (AppBar)
  final double titleFontSize;

  /// Kart başlık font boyutu
  final double cardTitleFontSize;

  /// Kart alt yazı font boyutu
  final double cardSubtitleFontSize;

  /// Detail ekranı bilim insanı fotoğraf boyutu
  final double detailImageSize;

  const AppScale({
    required this.screenType,
    required this.scaleFactor,
    required this.cardSize,
    required this.cardSpacing,
    required this.cardRunSpacing,
    required this.pagePadding,
    required this.detailLeftWidthRatio,
    required this.iconSize,
    required this.titleFontSize,
    required this.cardTitleFontSize,
    required this.cardSubtitleFontSize,
    required this.detailImageSize,
  });
}

// ─── ResponsiveHelper ────────────────────────────────────────────────────────

class ResponsiveHelper {
  // Breakpoint sabitleri
  static const double _kPhoneMax        = 599;
  static const double _kSmallTabletMax  = 839;
  static const double _kMediumTabletMax = 1199;

  /// Ekran genişliğine göre ScreenType döndürür.
  static ScreenType screenType(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return screenTypeFromWidth(w);
  }

  static ScreenType screenTypeFromWidth(double w) {
    if (w <= _kPhoneMax)        return ScreenType.phone;
    if (w <= _kSmallTabletMax)  return ScreenType.smallTablet;
    if (w <= _kMediumTabletMax) return ScreenType.mediumTablet;
    return ScreenType.largeTablet;
  }

  // ─ Otomatik ölçek çarpanı ─────────────────────────────────────────────────

  static double _autoScaleFactor(ScreenType type) {
    switch (type) {
      case ScreenType.phone:        return 0.80;
      case ScreenType.smallTablet:  return 0.90;
      case ScreenType.mediumTablet: return 1.00;
      case ScreenType.largeTablet:  return 1.10;
    }
  }

  static double _manualScaleFactor(AppScaleMode mode) {
    switch (mode) {
      case AppScaleMode.small:  return 0.80;
      case AppScaleMode.medium: return 1.00;
      case AppScaleMode.large:  return 1.20;
      case AppScaleMode.auto:   return 1.00; // fallback
    }
  }

  // ─ Ana hesaplama metodu ────────────────────────────────────────────────────

  /// [context] ve [scaleMode] kullanarak ekrana özgü AppScale hesaplar.
  static AppScale compute(BuildContext context, AppScaleMode scaleMode) {
    final size   = MediaQuery.of(context).size;
    final width  = size.width;
    final height = size.height;
    final type   = screenTypeFromWidth(width);

    final double sf = scaleMode == AppScaleMode.auto
        ? _autoScaleFactor(type)
        : _manualScaleFactor(scaleMode);

    // Kullanılabilir yükseklik: AppBar + safe area tahmini
    final double usableH = height - 56 - 32;
    final double usableW = width;

    double rawCardSize;
    switch (type) {
      case ScreenType.phone:
        // 2 sütun, 3 satır (5 kart: 2+2+1)
        rawCardSize = (usableW - 48) / 2;
        final maxByH = (usableH / 3) / 1.35;
        if (rawCardSize > maxByH) rawCardSize = maxByH;
        break;
      case ScreenType.smallTablet:
        // 3 sütun, 2 satır
        rawCardSize = (usableW - 80) / 3;
        final maxByH2 = (usableH / 2) / 1.35;
        if (rawCardSize > maxByH2) rawCardSize = maxByH2;
        break;
      case ScreenType.mediumTablet:
        // 5 kart tek satırda
        rawCardSize = (usableW - 120) / 5;
        final maxByH3 = (usableH * 0.75).clamp(0.0, usableH);
        if (rawCardSize > maxByH3) rawCardSize = maxByH3;
        break;
      case ScreenType.largeTablet:
        // 5 kart tek satırda, daha geniş
        rawCardSize = (usableW - 160) / 5;
        final maxByH4 = (usableH * 0.75).clamp(0.0, usableH);
        if (rawCardSize > maxByH4) rawCardSize = maxByH4;
        break;
    }

    // Minimum / maksimum sınırlar + ölçek uygula
    rawCardSize = rawCardSize.clamp(70.0, 220.0) * sf;

    // Spacing: ekran genişliğinin %2'si
    final double spacing    = (width * 0.02).clamp(8.0, 48.0) * sf;
    final double runSpacing = (width * 0.02).clamp(8.0, 48.0) * sf;

    // Padding
    final double hPad = (width  * 0.03).clamp(8.0, 32.0) * sf;
    final double vPad = (height * 0.02).clamp(8.0, 24.0) * sf;

    // Font boyutları
    final double titleFont    = (14 * sf).clamp(10.0, 18.0);
    final double subtitleFont = (10 * sf).clamp(8.0,  13.0);
    final double appBarFont   = (18 * sf).clamp(14.0, 22.0);
    final double iconSz       = (22 * sf).clamp(16.0, 28.0);

    // Detail ekranı sol kolon oranı
    double detailRatio;
    switch (type) {
      case ScreenType.phone:        detailRatio = 1.0;
      case ScreenType.smallTablet:  detailRatio = 0.38;
      case ScreenType.mediumTablet: detailRatio = 0.33;
      case ScreenType.largeTablet:  detailRatio = 0.30;
    }

    final double detailImgSize = type == ScreenType.phone
        ? (rawCardSize * 0.90).clamp(90.0, 180.0)
        : (rawCardSize * 1.10).clamp(120.0, 220.0);

    return AppScale(
      screenType:           type,
      scaleFactor:          sf,
      cardSize:             rawCardSize,
      cardSpacing:          spacing,
      cardRunSpacing:       runSpacing,
      pagePadding:          EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      detailLeftWidthRatio: detailRatio,
      iconSize:             iconSz,
      titleFontSize:        appBarFont,
      cardTitleFontSize:    titleFont,
      cardSubtitleFontSize: subtitleFont,
      detailImageSize:      detailImgSize,
    );
  }

  // ─ Geriye dönük uyumluluk yardımcıları ───────────────────────────────────

  static bool isMobile(BuildContext context) =>
      screenType(context) == ScreenType.phone;

  static bool isTablet(BuildContext context) {
    final t = screenType(context);
    return t == ScreenType.smallTablet || t == ScreenType.mediumTablet;
  }

  static bool isLargeTablet(BuildContext context) =>
      screenType(context) == ScreenType.largeTablet;

  static EdgeInsets getPadding(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w <= _kPhoneMax)        return const EdgeInsets.all(16);
    if (w <= _kSmallTabletMax)  return const EdgeInsets.all(20);
    if (w <= _kMediumTabletMax) return const EdgeInsets.all(24);
    return const EdgeInsets.all(32);
  }

  static double getCardSize(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w <= _kPhoneMax)        return ((w - 48) / 2).clamp(70, 180);
    if (w <= _kSmallTabletMax)  return ((w - 80) / 3).clamp(90, 200);
    if (w <= _kMediumTabletMax) return ((w - 120) / 5).clamp(110, 210);
    return ((w - 160) / 5).clamp(130, 220);
  }
}
