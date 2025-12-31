import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'auth_service.dart';
import 'sign_up_page.dart';
import 'forgot_password_page.dart';

class SignInPage extends StatefulWidget {
	const SignInPage({Key? key}) : super(key: key);

	@override
	State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
	final TextEditingController _email = TextEditingController();
	final TextEditingController _password = TextEditingController();
	bool _loading = false;

	void _showMessage(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

	Future<void> _signInEmail() async {
		setState(() => _loading = true);
		try {
			await AuthService.signInWithEmail(_email.text.trim(), _password.text);
		} catch (e) {
			_showMessage(e.toString());
		} finally {
			if (mounted) setState(() => _loading = false);
		}
	}

	Future<void> _signInGoogle() async {
		setState(() => _loading = true);
		try {
			final res = await AuthService.signInWithGoogle();
			if (res == null) _showMessage('Google sign-in cancelled');
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
						child: Image.asset(
							'assets/background_image.jpg',
							fit: BoxFit.cover,
							errorBuilder: (ctx, err, st) => Container(color: Colors.black87),
						),
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
																Text(
																	'Sign In',
																	style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
																),
																const SizedBox(height: 12),
																TextField(
																	controller: _email,
																	style: const TextStyle(color: Colors.white),
																	decoration: const InputDecoration(labelText: 'Email', labelStyle: TextStyle(color: Colors.white70)),
																	keyboardType: TextInputType.emailAddress,
																),
																const SizedBox(height: 12),
																TextField(
																	controller: _password,
																	style: const TextStyle(color: Colors.white),
																	decoration: const InputDecoration(labelText: 'Password', labelStyle: TextStyle(color: Colors.white70)),
																	obscureText: true,
																),
																const SizedBox(height: 16),
																SizedBox(
																	width: double.infinity,
																	child: ElevatedButton(
																		onPressed: _loading ? null : _signInEmail,
																		child: _loading
																			? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2))
																			: const Text('Sign in with Email', style: TextStyle(color: Colors.black87)),
																	),
																),
																Row(
																	mainAxisAlignment: MainAxisAlignment.spaceBetween,
																	children: [
																		TextButton(
																			onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpPage())),
																			child: const Text('Create account', style: TextStyle(color: Colors.white)),
																		),
																		TextButton(
																			onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordPage())),
																			child: const Text('Forgot password?', style: TextStyle(color: Colors.white)),
																		),
																	],
																),
																const Divider(),
																SignInButton(
																	Buttons.Google,
																	onPressed: _loading ? null : _signInGoogle,
																),
																const SizedBox(height: 8),
																const Text('You can sign in with your email/password or any Google account.', style: TextStyle(color: Colors.white70)),
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
