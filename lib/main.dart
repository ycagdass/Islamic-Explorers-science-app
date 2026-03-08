import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'utils/app_theme.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Prevent Google Fonts from blocking startup with network requests.
  // Fonts cached from a previous run are still served; first-run falls back
  // to the system font until the cache is warm (no visible hang).
  GoogleFonts.config.allowRuntimeFetching = false;

  // Allow multiple orientations for responsive design across tablet & phone
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final appState = AppState();
  await appState.init();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider.value(value: appState)],
      child: const ScientistsApp(),
    ),
  );
}

class ScientistsApp extends StatelessWidget {
  const ScientistsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    if (appState.isLoading) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: 'Bilim İnsanları Uygulaması',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}
