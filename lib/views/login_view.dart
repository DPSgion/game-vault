import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFF0F172A);
    const Color accentColor = Color(0xFF00E5FF);

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sports_esports, size: 80, color: accentColor),
              const SizedBox(height: 20),
              const Text(
                'GAME VAULT',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Identify yourself, Player One.',
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
              const SizedBox(height: 60),
              
              ElevatedButton.icon(
                onPressed: () async {
                  final user = await AuthService().signInWithGoogle();
                  if (user == null && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đăng nhập thất bại hoặc đã bị hủy.'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.login, color: bgColor),
                label: const Text(
                  'Continue with Google',
                  style: TextStyle(
                    color: bgColor, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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