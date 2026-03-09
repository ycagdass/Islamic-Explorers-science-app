import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    );

    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToHome(BuildContext context) {
    final appState = context.read<AppState>();
    appState.markOnboardingSeen();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary    = Theme.of(context).colorScheme.primary;
    final isDark     = Theme.of(context).brightness == Brightness.dark;
    final size       = MediaQuery.of(context).size;
    final isTablet   = size.width > 600;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xFF221610),
                          const Color(0xFF3D2015),
                          const Color(0xFF221610),
                        ]
                      : [
                          const Color(0xFFFFF8F5),
                          const Color(0xFFFFF0E8),
                          const Color(0xFFFAF0EA),
                        ],
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 80.0 : 32.0,
                    vertical: 32.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo / İkon
                      FadeTransition(
                        opacity: _fadeAnim,
                        child: ScaleTransition(
                          scale: _scaleAnim,
                          child: _buildLogo(context, primary, isTablet),
                        ),
                      ),

                      SizedBox(height: isTablet ? 40 : 28),

                      // Başlık
                      SlideTransition(
                        position: _slideAnim,
                        child: FadeTransition(
                          opacity: _fadeAnim,
                          child: Text(
                            'Bilim İnsanları',
                            style: TextStyle(
                              fontSize: isTablet ? 36 : 28,
                              fontWeight: FontWeight.bold,
                              color: primary,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      SizedBox(height: isTablet ? 16 : 12),

                      // Alt yazı
                      SlideTransition(
                        position: _slideAnim,
                        child: FadeTransition(
                          opacity: _fadeAnim,
                          child: Text(
                            'İslam dünyasının yetiştirdiği\nbüyük bilim insanlarını keşfet',
                            style: TextStyle(
                              fontSize: isTablet ? 18 : 15,
                              color: isDark
                                  ? Colors.white60
                                  : Colors.black54,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      SizedBox(height: isTablet ? 20 : 14),

                      // Bilim insanı etiketleri
                      SlideTransition(
                        position: _slideAnim,
                        child: FadeTransition(
                          opacity: _fadeAnim,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: [
                              'Harezmi',
                              'Ali Kuşçu',
                              'İbn-i Sina',
                              'Uluğ Bey',
                              'Cahit Arf',
                            ]
                                .map((name) => Chip(
                                      label: Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: isTablet ? 13 : 11,
                                          color: primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      backgroundColor:
                                          primary.withValues(alpha: 0.1),
                                      side: BorderSide(
                                        color: primary.withValues(alpha: 0.3),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isTablet ? 10 : 6,
                                        vertical: 0,
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),

                      SizedBox(height: isTablet ? 48 : 36),

                      // Başla butonu
                      SlideTransition(
                        position: _slideAnim,
                        child: FadeTransition(
                          opacity: _fadeAnim,
                          child: SizedBox(
                            width: isTablet ? 280 : double.infinity,
                            child: FilledButton.icon(
                              onPressed: () => _goToHome(context),
                              icon: const Icon(Icons.explore_outlined),
                              label: const Text(
                                'Keşfetmeye Başla',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: FilledButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: isTablet ? 18 : 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context, Color primary, bool isTablet) {
    final logoSize = isTablet ? 140.0 : 110.0;

    return Container(
      width: logoSize,
      height: logoSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            primary.withValues(alpha: 0.2),
            primary.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(color: primary.withValues(alpha: 0.5), width: 3),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.25),
            blurRadius: 28,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Icon(
        Icons.science_outlined,
        size: logoSize * 0.5,
        color: primary,
      ),
    );
  }
}
