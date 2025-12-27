import 'dart:async';
import 'package:flutter/material.dart';
import 'package:planet_info/ai_voice/gemini.dart';
import 'package:planet_info/home_pages/in_pages/search_result_page.dart';
import 'package:planet_info/space_service.dart';

class SpaceSearch extends StatefulWidget {
  const SpaceSearch({super.key});

  @override
  State<SpaceSearch> createState() => _SpaceSearchState();
}

class _SpaceSearchState extends State<SpaceSearch> with SingleTickerProviderStateMixin {
  final TextEditingController _ctrl = TextEditingController();
  bool _loading = false;

  Future<void> _onSearch(String query) async {
    if (query.trim().isEmpty) return;

    
    FocusScope.of(context).unfocus();

    setState(() => _loading = true);

    try {
      final answer = await handleSearch(query);
      final planet = await SpaceService().findPlanetByName(query);

      if (!mounted) return;

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
    } catch (e) {
    
      print("Search error: $e");
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
  
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E).withOpacity(0.8), 
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: TextField(
        controller: _ctrl,
        textInputAction: TextInputAction.search,
        onSubmitted: _onSearch,
        style: const TextStyle(color: Colors.white),
        cursorColor: const Color(0xFF4285F4), 
        decoration: InputDecoration(
          hintText: "Search planets, space, NASA...",
          hintStyle: const TextStyle(color: Colors.white54),
          border: InputBorder.none, 
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          
        
          prefixIcon: const Icon(Icons.search, color: Colors.white54),

        
          suffixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _loading
                ? const GoogleColorLoader() 
                : InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => _onSearch(_ctrl.text),
                    child:Image.asset(
  'assets/Google_Gemini_Logo.png',
  width: 10.0,
  height: 10.0,
), 
                  ),
          ),
        ),
      ),
    );
  }
}

// class GeminiIcon extends StatelessWidget {
//   const GeminiIcon({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ShaderMask(
//       shaderCallback: (bounds) => const LinearGradient(
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//         colors: [
//           Color(0xFF4285F4), 
//           Color(0xFFDB4437), 
//           Color(0xFFF4B400), 
//           Color(0xFF0F9D58), 
//         ],
//       ).createShader(bounds),
//       child: 

//     );
//   }
// }


class GoogleColorLoader extends StatefulWidget {
  const GoogleColorLoader({super.key});

  @override
  State<GoogleColorLoader> createState() => _GoogleColorLoaderState();
}

class _GoogleColorLoaderState extends State<GoogleColorLoader> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
 
  final List<Color> _colors = const [
    Color(0xFF4285F4), Color(0xFFDB4437), Color(0xFFF4B400), Color(0xFF0F9D58)
  ];
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2), vsync: this
    )..repeat();

    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (mounted) setState(() => _index = (_index + 1) % _colors.length);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20, 
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(_colors[_index]),
      ),
    );
  }
}