import 'package:flutter/material.dart';
import 'package:planet_info/model/spaceObject.dart';

class SpaceCard extends StatelessWidget {
  final SpaceObject obj;

  const SpaceCard({required this.obj});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          Expanded(
            child: Center(
              child: CircleAvatar(
                radius: 600,
               backgroundColor: Colors.transparent,
      backgroundImage: obj.imagePath != null
          ? AssetImage(obj.imagePath!)
          : null,
      child: obj.imagePath == null
          ? const Icon(Icons.public, size: 60)
          : null,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // NAME
          Text(
            obj.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,color:Colors.white
            ),
          ),

          const SizedBox(height: 4),

          // SHORT DESCRIPTION
          Text(
            obj.shortDesc,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12,color: Colors.white),
          ),
        ],
      ),
    );
  }
}
