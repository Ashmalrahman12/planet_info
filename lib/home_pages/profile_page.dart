import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:planet_info/loging_page/auth_service.dart';
import 'package:planet_info/loging_page/singIn_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
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
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Card(
                          color: Colors.white.withOpacity(0.12),
                          elevation: 6,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 48,
                                  backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                                  child: user?.photoURL == null ? const Icon(Icons.person, size: 48) : null,
                                ),
                                const SizedBox(height: 24),
                                Text('Name: ${user?.displayName ?? 'N/A'}', style: const TextStyle(fontSize: 16, color: Colors.white)),
                                const SizedBox(height: 8),
                                Text('Email: ${user?.email ?? 'N/A'}', style: const TextStyle(fontSize: 16, color: Colors.white)),
                                const SizedBox(height: 8),
                                // Text('UID: ${user?.uid ?? 'N/A'}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Confirm sign out'),
                                        content: const Text('Are you sure you want to sign out? You will need to sign in again.'),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                                          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Sign out')),
                                        ],
                                      ),
                                    );
                                    if (!mounted) return;
                                    if (confirm == true) {
                                      await AuthService.signOut();
                                      if (!mounted) return;
                                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const SignInPage()), (r) => false);
                                    }
                                  },
                                  icon: const Icon(Icons.logout),
                                  label: const Text('Sign out'),
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
