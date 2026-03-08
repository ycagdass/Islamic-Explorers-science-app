import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/scientist.dart';
import '../providers/app_state.dart';
import '../utils/responsive_helper.dart';
import 'detail_screen.dart';
import 'login_screen.dart';
import 'dart:io';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState  = context.watch<AppState>();
    final scientists = appState.scientists;
    final scaleMode  = appState.scaleMode;

    if (scientists.isEmpty) return const Scaffold(body: SizedBox());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bilim İnsanları',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale = ResponsiveHelper.compute(context, scaleMode);
            final isPhone = scale.screenType == ScreenType.phone;

            // Ekrana sığacak kart düzeni — scroll son çare
            return _ScientistsLayout(
              scientists: scientists,
              scale: scale,
              isPhone: isPhone,
              constraints: constraints,
            );
          },
        ),
      ),
    );
  }
}

// ─── Akıllı layout widget ────────────────────────────────────────────────────

class _ScientistsLayout extends StatelessWidget {
  final List<Scientist> scientists;
  final AppScale scale;
  final bool isPhone;
  final BoxConstraints constraints;

  const _ScientistsLayout({
    required this.scientists,
    required this.scale,
    required this.isPhone,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    // Kart + etiket yüksekliği tahmini (labelHeight = cardSize * 0.45)
    final double cardH = scale.cardSize + scale.cardSize * 0.45 + scale.cardRunSpacing;

    // Toplam wrap alanı tahmini yüksekliği
    int rows;
    switch (scale.screenType) {
      case ScreenType.phone:
        rows = 3; // 2-2-1
      case ScreenType.smallTablet:
        rows = 2; // 3-2
      case ScreenType.mediumTablet:
      case ScreenType.largeTablet:
        rows = 1; // hepsi tek sıra
    }

    final double estimatedH = rows * cardH + scale.pagePadding.vertical;
    final bool needsScroll  = estimatedH > constraints.maxHeight;

    final Widget content = Center(
      child: Wrap(
        spacing:          scale.cardSpacing,
        runSpacing:       scale.cardRunSpacing,
        alignment:        WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: scientists
            .map(
              (s) => RepaintBoundary(
                child: _ScientistCard(scientist: s, scale: scale),
              ),
            )
            .toList(),
      ),
    );

    if (needsScroll) {
      return SingleChildScrollView(
        padding: scale.pagePadding,
        child: content,
      );
    }

    // Scroll olmadan: Flex + Center ile tam ortala
    return Padding(
      padding: scale.pagePadding,
      child: Center(child: content),
    );
  }
}

// ─── Bilim insanı kartı ──────────────────────────────────────────────────────

class _ScientistCard extends StatelessWidget {
  final Scientist scientist;
  final AppScale scale;

  const _ScientistCard({required this.scientist, required this.scale});

  @override
  Widget build(BuildContext context) {
    final size    = scale.cardSize;
    final primary = Theme.of(context).colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailScreen(scientist: scientist),
            ),
          );
        },
        customBorder: const CircleBorder(),
        splashColor: primary.withValues(alpha: 0.2),
        hoverColor:  primary.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Fotoğraf dairesi
              Container(
                width: size,
                height: size,
                padding: EdgeInsets.all(size * 0.05),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color ??
                      Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.22),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(
                    color: primary.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: _getImageDecoration(scientist.imagePath),
                  ),
                ),
              ),
              SizedBox(height: size * 0.08),
              // İsim & unvan etiketi
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size * 0.12,
                  vertical:   size * 0.05,
                ),
                constraints: BoxConstraints(maxWidth: size * 1.2),
                decoration: BoxDecoration(
                  color: (Theme.of(context).cardTheme.color ??
                          Theme.of(context).cardColor)
                      .withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: primary.withValues(alpha: 0.2),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      scientist.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize:   scale.cardTitleFontSize,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      scientist.title.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color:       primary,
                        fontWeight:  FontWeight.w600,
                        letterSpacing: 0.8,
                        fontSize:    scale.cardSubtitleFontSize,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DecorationImage _getImageDecoration(String path) {
    if (path.startsWith('http')) {
      return DecorationImage(image: NetworkImage(path), fit: BoxFit.cover);
    } else {
      return DecorationImage(image: FileImage(File(path)), fit: BoxFit.cover);
    }
  }
}
