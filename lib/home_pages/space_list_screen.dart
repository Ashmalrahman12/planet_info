import 'package:flutter/material.dart';
import 'package:planet_info/home_pages/spaceCard.dart';
import 'package:planet_info/model/spaceObject.dart';
import 'package:planet_info/space_service.dart';

class SpaceListScreen extends StatefulWidget {
  const SpaceListScreen({super.key});

  @override
  State<SpaceListScreen> createState() => _SpaceListScreenState();
}

class _SpaceListScreenState extends State<SpaceListScreen> {
  final SpaceService service = SpaceService();

  final List<String> tabs = ["planets", "moons", "stars", "universe", "solar"];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
    
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: tabs.length,
            itemBuilder: (context, index) {
              final selected = index == selectedIndex;
              return GestureDetector(
                onTap: () => setState(() => selectedIndex = index),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.blue.withOpacity(0.8)
                        : Colors.white.withOpacity(0.25), // ✅ transparent
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tabs[index].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

    
        Expanded(
          child: StreamBuilder<List<SpaceObject>>(
            stream: service.getObjectsByCategory(tabs[selectedIndex]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("No data found",
                      style: TextStyle(color: Colors.white)),
                );
              }

              final items = snapshot.data!;

       
              if (tabs[selectedIndex] == "solar") {
                final solar = items.first;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Image.asset(solar.imagePath!, height: 200),
                      const SizedBox(height: 12),
                      Text(
                        solar.name,
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        solar.overviewDesc,
                        style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.white70),
                      ),
                    ],
                  ),
                );
              }

    
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.72,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return SpaceCard(obj: items[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
