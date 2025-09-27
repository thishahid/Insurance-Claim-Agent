import 'package:flutter/material.dart';
import 'package:insurance_claim_agent/config/theme.dart';
import 'package:insurance_claim_agent/config/api_config.dart';
import 'package:insurance_claim_agent/screens/api_key_screen.dart';
import 'package:insurance_claim_agent/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkApiKeyAndNavigate();
  }

  Future<void> _checkApiKeyAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2)); // Splash duration

    final hasApiKey = await ApiConfig.hasApiKey();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              hasApiKey ? const HomeScreen() : const ApiKeyScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo or icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.oliveGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.security, color: Colors.white, size: 64),
            ),
            const SizedBox(height: 24),
            const Text(
              'Insurance Claim Assistant',
              style: TextStyle(
                color: AppTheme.textLight,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'AI-powered claim status and FAQ support',
              style: TextStyle(color: AppTheme.textDark, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
