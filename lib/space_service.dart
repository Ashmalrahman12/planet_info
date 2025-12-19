import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/spaceObject.dart';

class SpaceService {
  final CollectionReference spaceRef =
      FirebaseFirestore.instance.collection('spaceObjects');

  // 🔹 STREAM BY CATEGORY
  Stream<List<SpaceObject>> getObjectsByCategory(String category) {
    return spaceRef
        .where('category', isEqualTo: category)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => SpaceObject.fromFirestore(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  // 🔹 FIND PLANET BY NAME (FIXED)
  Future<SpaceObject?> findPlanetByName(String name) async {
    final res = await getObjectsByCategory("planets").first;

    try {
      return res.firstWhere(
        (p) => p.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }
}
