import 'package:flutter/material.dart';
import 'package:planet_info/config/secrets.dart';
import 'package:planet_info/home_pages/in_pages/search_result_page.dart';
import 'package:planet_info/home_pages/menu_page.dart';
import 'package:planet_info/home_pages/space_list_screen.dart';
import 'package:planet_info/home_pages/space_search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  
@override
void initState() {
  super.initState();
  _initSecrets();
}

Future<void> _initSecrets() async {
  await loadSecrets();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,

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
       actions: [IconButton(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchResultPage(answer: '', query: '',)),
            );
          }, icon: Icon(Icons.android))],
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
                  Expanded(
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

