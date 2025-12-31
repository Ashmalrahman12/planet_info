import 'package:flutter/material.dart';

import 'auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _email = TextEditingController();
  bool _loading = false;

  void _showMessage(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _sendReset() async {
    setState(() => _loading = true);
    try {
      await AuthService.sendPasswordResetEmail(_email.text.trim());
      _showMessage('Password reset email sent');
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      _showMessage(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/background_image.jpg', fit: BoxFit.cover, errorBuilder: (ctx, e, s) => Container(color: Colors.black87)),
          ),
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final height = constraints.maxHeight;
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: height),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: Card(
                          color: Colors.white.withOpacity(0.12),
                          elevation: 6,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Reset Password', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _email,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(labelText: 'Email', labelStyle: TextStyle(color: Colors.white70)),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _loading ? null : _sendReset,
                                    child: _loading ? const SizedBox(height:24,width:24,child:CircularProgressIndicator(strokeWidth:2)) : const Text('Send reset email', style: TextStyle(color: Colors.black87)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
