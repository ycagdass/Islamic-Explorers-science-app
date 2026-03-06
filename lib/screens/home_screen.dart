import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/scientist.dart';
import '../providers/app_state.dart';
import 'detail_screen.dart';
import 'login_screen.dart';
import 'dart:io';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final scientists = appState.scientists;

    if (scientists.isEmpty) return const SizedBox();

    final harezmi = scientists.firstWhere((s) => s.name == 'Harezmi');
    final aliKuscu = scientists.firstWhere((s) => s.name == 'Ali Kuşçu');
    final cahitArf = scientists.firstWhere((s) => s.name == 'Cahit Arf');
    final ibnSina = scientists.firstWhere((s) => s.name == 'İbn-i Sina');
    final ulugBey = scientists.firstWhere((s) => s.name == 'Uluğ Bey');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bilim İnsanları'),
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          // Responsive sizing
          final centerSize = (h * 0.52).clamp(200.0, 420.0);
          final rectW = (w * 0.2).clamp(180.0, 320.0);
          final rectH = (h * 0.42).clamp(200.0, 380.0);
          final edgeMargin = (w * 0.04).clamp(24.0, 80.0);
          final topMargin = (h * 0.06).clamp(16.0, 80.0);
          final bottomMargin = (h * 0.06).clamp(16.0, 80.0);

          return Stack(
            alignment: Alignment.center,
            children: [
              // Cahit Arf (Merkez - Dairesel)
              Align(
                alignment: Alignment.center,
                child: _buildCenterCard(context, cahitArf, centerSize),
              ),

              // Harezmi (Sol Üst)
              Positioned(
                top: topMargin,
                left: edgeMargin,
                child: _buildRectCard(context, harezmi, rectW, rectH),
              ),

              // Ali Kuşçu (Sağ Üst)
              Positioned(
                top: topMargin,
                right: edgeMargin,
                child: _buildRectCard(context, aliKuscu, rectW, rectH),
              ),

              // İbn-i Sina (Sol Alt)
              Positioned(
                bottom: bottomMargin,
                left: edgeMargin,
                child: _buildRectCard(context, ibnSina, rectW, rectH),
              ),

              // Uluğ Bey (Sağ Alt)
              Positioned(
                bottom: bottomMargin,
                right: edgeMargin,
                child: _buildRectCard(context, ulugBey, rectW, rectH),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRectCard(
    BuildContext context,
    Scientist scientist,
    double w,
    double h,
  ) {
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
        borderRadius: BorderRadius.circular(16),
        splashColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.2),
        highlightColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.08),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: w,
          height: h,
          decoration: BoxDecoration(
            color:
                Theme.of(context).cardTheme.color ??
                Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color:
                    Theme.of(context).cardTheme.shadowColor ?? Colors.black12,
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.12),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.15),
                      image: _getImageDecoration(scientist.imagePath),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  scientist.name,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  scientist.title.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCenterCard(
    BuildContext context,
    Scientist scientist,
    double size,
  ) {
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
        splashColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: size,
              height: size,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    Theme.of(context).cardTheme.color ??
                    Theme.of(context).cardColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: _getImageDecoration(scientist.imagePath),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              decoration: BoxDecoration(
                color:
                    Theme.of(context).cardTheme.color?.withValues(alpha: 0.9) ??
                    Theme.of(context).cardColor.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.25),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    scientist.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    scientist.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
