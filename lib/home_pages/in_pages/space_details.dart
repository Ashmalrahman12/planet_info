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
                     Text(space.name ,style: const TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.bold)),
     
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
                      _info('Type', space.type),
                        if (space.category == 'planets')
      _info('Distance', space.distanceFromSun ?? '—'),
     if (space.category == 'moons')
      _info('Parent', space.parent ?? '—'),
      if (space.category == 'stars')
      _info('Distance', space.distance ?? '—'),
                      _info('Light Time', space.orbitalPeriod?? '—'),
                    ],
                  ),
     
                  const SizedBox(height: 16),
     
             
                  const TabBar(
                    isScrollable: true,
                    indicatorColor: Colors.white,
                    unselectedLabelColor: Colors.white,
                   labelColor: Colors.deepPurple,
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
  switch (space.category) {
    case 'planets':
      return _planetNumbers(space);

    case 'moons':
      return _moonNumbers(space);

    case 'stars':
      return _starNumbers(space);

    case 'universe':
    case 'solar':
      return _systemNumbers(space);

    default:
      return const Center(
        child: Text('No numerical data available',
            style: TextStyle(color: Colors.white70)),
      );
  }
}
static Widget _planetNumbers(SpaceObject space) {
  final data = {
    'Planet Type': space.planetType,
    'Distance from Sun': space.distanceFromSun,
    'Radius': space.radius,
    'Mass': space.mass,
    'Gravity': space.gravity,
    'Temperature': space.surfaceTemperature,
    'Rotation Period': space.rotationPeriod,
    'Moon Count':space.moonsCount,
  };

  return _numbersList(data);
}
static Widget _moonNumbers(SpaceObject space) {
  final data = {
    'Parent Planet': space.parent,
    'Distance from Parent': space.distanceFromParent,
    'Orbital Period': space.orbitalPeriod,
    'Radius': space.radius,
  };

  return _numbersList(data);
}
static Widget _starNumbers(SpaceObject space) {
  final data = {
    'Distance from Earth': space.distance,
    'Radius': space.radius,
    'Surface Temperature': space.surfaceTemperature,
  };

  return _numbersList(data);
}
static Widget _systemNumbers(SpaceObject space) {
  return const Padding(
    padding: EdgeInsets.all(16),
    child: Text(
      'This system is best understood through its structure and evolution rather than numerical measurements.',
      style: TextStyle(color: Colors.white70, fontSize: 16),
    ),
  );
}

static Widget _numbersList(Map<String, Object?> data) {
  return ListView(
    children: data.entries.map((e) {
      return ListTile(
        title: Text(e.key, style: const TextStyle(color: Colors.white,fontSize: 20)),
        trailing: Text(
          e.value?.toString() ?? '—',
          style: const TextStyle(color: Colors.white70,fontSize: 20),
        ),
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
