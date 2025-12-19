import 'package:flutter/material.dart';
import 'package:planet_info/ai_voice/gemini.dart';
import 'package:planet_info/home_pages/in_pages/search_result_page.dart';
import 'package:planet_info/space_service.dart';

class SpaceSearch extends StatefulWidget {
  SpaceSearch({super.key});

  @override
  State<SpaceSearch> createState() => _SpaceSearchState();
}

class _SpaceSearchState extends State<SpaceSearch> {
  final TextEditingController _ctrl = TextEditingController();

  

  bool _loading = false;

  Future<void> _onSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() => _loading = true);

    final answer = await handleSearch(query);
    final planet = await SpaceService().findPlanetByName(query);

    if (!mounted) return;

    setState(() => _loading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultPage(
          query: query,
          answer: answer,
          planet: planet,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
     textInputAction: TextInputAction.search, 
          onSubmitted: _onSearch,          
     style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Search planets, space, NASA...",hintStyle: TextStyle(color: Colors.white),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        prefixIcon: const Icon(Icons.search),
           fillColor: Colors.white,
    
          suffixIcon: _loading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
             
      ),

     
    );
  }
}

