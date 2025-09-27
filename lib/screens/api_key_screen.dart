import 'package:flutter/material.dart';
import 'package:insurance_claim_agent/config/api_config.dart';
import 'package:insurance_claim_agent/config/theme.dart';
import 'package:insurance_claim_agent/screens/home_screen.dart';

class ApiKeyScreen extends StatefulWidget {
  const ApiKeyScreen({super.key});

  @override
  State<ApiKeyScreen> createState() => _ApiKeyScreenState();
}

class _ApiKeyScreenState extends State<ApiKeyScreen> {
  final TextEditingController _apiKeyController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _saveApiKey() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final apiKey = _apiKeyController.text.trim();

    if (apiKey.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Please enter your API key';
      });
      return;
    }

    try {
      await ApiConfig.saveApiKey(apiKey);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to save API key: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Configuration'),
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
      ),
      backgroundColor: AppTheme.darkBackground,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.vpn_key, color: AppTheme.oliveGreen, size: 80),
            const SizedBox(height: 24),
            const Text(
              'Enter Your Gemini API Key',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'To use this app, you need a Google Gemini API key. You can get one from the Google AI Studio.',
              style: TextStyle(fontSize: 16, color: AppTheme.textDark),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                labelText: 'API Key',
                hintText: 'Enter your Gemini API key',
                prefixIcon: Icon(Icons.key, color: AppTheme.oliveGreen),
              ),
              obscureText: true,
              style: const TextStyle(color: AppTheme.textLight),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveApiKey,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Save API Key'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Open link to get API key
                // In a real app, use url_launcher package
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Visit https://makersuite.google.com/app/apikey to get your API key',
                    ),
                    backgroundColor: AppTheme.oliveGreen,
                  ),
                );
              },
              child: const Text(
                'Get API Key',
                style: TextStyle(color: AppTheme.lightOlive),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
