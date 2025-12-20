class SpaceObject {
  final String id;
  final String name;
  final String type;       
  final String category;   
  final String shortDesc;
  final String overviewDesc;
  final String? parent;    
  final String? radius;
  final String? mass;
  final String? orbitalPeriod;
  final String? distanceFromParent;
  final String? surfaceTemperature;
  final String? imagePath;
  final String? inDepth;
  final int moonsCount;
  final List<String> gallery;
  final List<String> explore;
  final String? distanceFromSun;

  SpaceObject( {
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.shortDesc,
    required this.overviewDesc,
    required this.gallery,
    required this.explore,
    required this.inDepth,
    required this.moonsCount,
    this.distanceFromSun,
    this.parent,
    this.radius,
    this.mass,
    this.orbitalPeriod,
    this.distanceFromParent,
    this.surfaceTemperature,
    this.imagePath,
    
  });

  factory SpaceObject.fromFirestore(String id, Map<String, dynamic> data) {
    return SpaceObject(
      id: id,
      name: data['name'] ?? '',
      type: data['type'] ?? '',
      category: data['category'] ?? '',
      shortDesc: data['shortDesc'] ?? '',
      overviewDesc: data['overviewDesc'] ?? '',
      parent: data['parent'],
      radius: data['radius'],
      mass: data['mass'],
      orbitalPeriod: data['orbitalPeriod'],
      distanceFromParent: data['distanceFromParent'],
      surfaceTemperature: data['surfaceTemperature'],
      imagePath: data['imagePath'],
       moonsCount: (data['moonsCount'] ?? 0) as int,
      inDepth : data['inDepth'] ?? '',
      gallery: List<String>.from(data['gallery'] ?? []),
      explore: List<String>.from(data['explore'] ?? []),
      distanceFromSun:data['distanceFromSun']
    );
  }
}
