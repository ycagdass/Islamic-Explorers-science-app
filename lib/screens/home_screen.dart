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
    final appState = context.watch<AppState>();
    final scientists = appState.scientists;

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
            final isMobile = ResponsiveHelper.isMobile(context);
            final padding = ResponsiveHelper.getPadding(context);

            return SingleChildScrollView(
              padding: padding,
              child: Center(
                child: Wrap(
                  spacing: isMobile ? 24 : 48,
                  runSpacing: isMobile ? 32 : 48,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: scientists
                      .map((s) => _buildCircularCard(context, s))
                      .toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCircularCard(BuildContext context, Scientist scientist) {
    // Dynamic size based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    double size;
    if (ResponsiveHelper.isMobile(context)) {
      size = (screenWidth - 80) / 2; // 2 items per row
      if (size > 180) size = 180;
      if (size < 120) size = 120;
    } else {
      size = (screenWidth - 200) / 3; // 3 items per row roughly
      if (size > 260) size = 260;
      if (size < 180) size = 180;
    }

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
        hoverColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: size,
                height: size,
                padding: EdgeInsets.all(size * 0.05),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).cardTheme.color ??
                      Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.5),
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
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                constraints: BoxConstraints(maxWidth: size * 1.2),
                decoration: BoxDecoration(
                  color:
                      Theme.of(
                        context,
                      ).cardTheme.color?.withValues(alpha: 0.95) ??
                      Theme.of(context).cardColor.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.2),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      scientist.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      scientist.title.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
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
