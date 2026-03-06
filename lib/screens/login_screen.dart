import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'settings_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = true;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _initAuth();
  }

  Future<void> _initAuth() async {
    await _authService.init();
    final rememberMe = await _authService.getRememberMe();
    if (rememberMe) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SettingsScreen()),
        );
        return;
      }
    }
    setState(() {
      _rememberMe = rememberMe;
      _isLoading = false;
    });
  }

  void _login() async {
    final password = _passwordController.text;
    if (_authService.verifyPassword(password)) {
      await _authService.setRememberMe(_rememberMe);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SettingsScreen()),
        );
      }
    } else {
      setState(() {
        _errorText = 'Hatalı parola!';
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar Girişi')),
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color:
                Theme.of(context).cardTheme.color ??
                Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock, size: 64),
              const SizedBox(height: 24),
              const Text(
                'Ayar Yönetimi için Parola Girin',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _passwordController,
                obscureText: true,
                onSubmitted: (_) => _login(),
                decoration: InputDecoration(
                  labelText: 'Parola',
                  errorText: _errorText,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.key),
                ),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Oturumu Hatırla (Remember me)'),
                value: _rememberMe,
                onChanged: (val) {
                  setState(() {
                    _rememberMe = val ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text(
                    'Giriş Yap',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
