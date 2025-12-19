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

  SpaceObject({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.shortDesc,
    required this.overviewDesc,
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
    );
  }
}
