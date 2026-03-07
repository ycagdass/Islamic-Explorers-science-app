import 'package:flutter/material.dart';

class ResponsiveHelper {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 650 &&
      MediaQuery.of(context).size.width < 1100;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  // Responsive padding
  static EdgeInsets getPadding(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.all(16.0);
    if (isTablet(context)) return const EdgeInsets.all(24.0);
    return const EdgeInsets.all(32.0);
  }

  static double getCardSize(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    if (isMobile(context)) return (w - 64) / 2; // 2 cards per row
    if (isTablet(context)) return (w - 100) / 3; // 3 cards per row
    return (w - 150) / 4; // 4+ cards per row
  }
}
