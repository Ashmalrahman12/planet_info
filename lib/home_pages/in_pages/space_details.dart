import 'package:flutter/material.dart';
import 'package:planet_info/model/spaceObject.dart';

class SpaceDetails extends StatelessWidget {
  final SpaceObject space;
  const SpaceDetails({super.key,required this.space });

 

  @override
  Widget build(BuildContext context) {
   return 
   DefaultTabController(
     length: 5,
     child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
     
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
             onPressed: () {
         Navigator.pop(context); 
        },
          ),
         actions: [IconButton( onPressed: () {
         Navigator.pop(context); 
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
                     Text(space.name),
     
                    const SizedBox(height: 12),
                 Expanded(
              child: Center(
                child: CircleAvatar(
                  radius: 600,
                 backgroundColor: Colors.transparent,
        backgroundImage: space.imagePath != null
            ? AssetImage(space.imagePath!)
            : null,
        child: space.imagePath == null
            ? const Icon(Icons.public, size: 60)
            : null,
                ),
              ),
            ),
             const SizedBox(height: 12),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _info('Planet Type', space.type),
                      _info('Distance', space.distanceFromParent?? '—'),
                      _info('Light Time', space.orbitalPeriod?? '—'),
                    ],
                  ),
     
                  const SizedBox(height: 16),
     
             
                  const TabBar(
                    isScrollable: true,
                    indicatorColor: Colors.white,
                    tabs: [
                      Tab(text: 'Overview'),
                      Tab(text: 'In Depth'),
                      Tab(text: 'By the Numbers'),
                      Tab(text: 'Galleries'),
                      Tab(text: 'Exploration'),
                    ],
                  ),
     
                
                  Expanded(
                    child: TabBarView(
                      children: [
                        _textTab(space.overviewDesc),
                        _textTab(space.inDepth ?? 'No in-depth data available.'),
                        _numbersTab(space),
                        _galleryTab(space),
                        _explorationTab(space),
                      ],
                    ),
                  ),
                ],
              ),))
          ])
          ),
   );
      
    
  }
  
static Widget _info(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  static Widget _textTab(String text) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Text(text,
          style: const TextStyle(color: Colors.white, fontSize: 16)),
    );
  }

   static Widget _numbersTab(SpaceObject space) {
    final data = {
      'Radius': space.radius ?? '—',
      'Mass': space.mass ?? '—',
      'Temperature': space.surfaceTemperature,
      'Distance from Sun': space.distanceFromParent,
    };
     return ListView(
      children: data.entries.map((e) {
        return ListTile(
          title: Text(e.key, style: const TextStyle(color: Colors.white)),
          trailing: Text(e.value ?? '—',
    style: const TextStyle(color: Colors.white70)),

        );
      }).toList(),
    );
   }
  static Widget _galleryTab(SpaceObject space) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: space.gallery.length,
      itemBuilder: (_, i) {
        return Image.asset(space.gallery[i], fit: BoxFit.cover);
        
      }
     

    );
  }

  static Widget _explorationTab(SpaceObject space) {
    return ListView.builder(
      itemCount: space.explore.length,
      itemBuilder: (_, i) {
        return ListTile(
          leading: const Icon(Icons.rocket_launch, color: Colors.white),
          title: Text(space.explore[i],
              style: const TextStyle(color: Colors.white)),
        );
      },
    );
  }
}
