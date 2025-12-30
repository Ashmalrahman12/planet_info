import 'package:flutter/material.dart';
import 'package:planet_info/home_pages/in_pages/search_result_page.dart';
import 'package:planet_info/home_pages/menu_page.dart';
import 'package:planet_info/home_pages/space_list_screen.dart';
import 'package:planet_info/home_pages/space_search.dart';
import 'package:planet_info/home_pages/profile_page.dart';
import 'package:planet_info/loging_page/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SearchResultPage(query: '', answer: '',)),
          );
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.black,
        child: Image.asset(
          'assets/Google_Gemini_Logo.png',
          width: 30.0,
          height: 30.0,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.widgets_outlined, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MenuPage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Confirm sign out'),
                  content: const Text('Are you sure you want to sign out?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Sign out')),
                  ],
                ),
              );
              if (confirm == true) {
                await AuthService.signOut();
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background_image.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 100, 12, 12),
              child: Column(
                children: [
                  SpaceSearch(),
                  const SizedBox(height: 12),
                  const Expanded(
                    child: SpaceListScreen(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

