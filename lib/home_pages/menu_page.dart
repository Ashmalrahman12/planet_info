import 'package:flutter/material.dart';
import 'package:planet_info/home_pages/home_page.dart';

import 'package:planet_info/news_pages/nasa_api.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
   int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
 
  body: ListView(
    
    padding: EdgeInsets.zero,
    children: [
      const DrawerHeader(
        decoration: BoxDecoration(color: Colors.blue),
        child: Text('Planet_info'),
      ),
      ListTile(
        title: const Text('Home'),
          selected: _selectedIndex == 0,
        onTap: () {
           Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => HomePage(),
    ),
  );
        },
      ),
      ListTile(
        title: const Text('News'),
        onTap: () {
            Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => NasaApi(),
    ),
  );
        },
      ),
    ],
  ),
);
    
  }
}