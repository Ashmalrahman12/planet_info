import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:planet_info/config/secrets.dart';
import 'package:planet_info/splash_screen.dart';

import 'package:planet_info/home_pages/home_page.dart';
import 'loging_page/singIn_page.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Preserve splash screen while initializing
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await loadSecrets();
  
  // Remove splash screen after initialization
  FlutterNativeSplash.remove();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(nextScreen: const AuthGate()),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final user = snapshot.data;
        if (user == null) {
          return const SignInPage();
        }
        return HomePage();
      },
    );
  }
}
