import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:planet_info/home_pages/menu_page.dart';

class NasaApi extends StatefulWidget {
  const NasaApi({super.key});

  @override
  State<NasaApi> createState() => _NasaApiState();
}

class _NasaApiState extends State<NasaApi> {
  String imageUrl = '';
  String title = '';
  String description = '';

@override
void initState() {
  super.initState();
  // Get today's date in the correct format
  String todayDate = "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
  fetchAstronomyImage(todayDate);
}
Future<void> fetchAstronomyImage(String date) async {
  final response = await http.get(
    Uri.parse('https://api.nasa.gov/planetary/apod?api_key=Tdp0gRd1WCQME88NsOU57wApcg85IMencaDR0Z0f&date=$date'),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    setState(() {
      imageUrl = data['url'];
      title = data['title'];
      description = data['explanation'];
    });
  } else {
    print('Failed to load image');
  }
}
Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1995, 6, 16), // APOD start date
    lastDate: DateTime.now(),
  );
  if (picked != null) {
    String formattedDate = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    fetchAstronomyImage(formattedDate);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         extendBodyBehindAppBar: true,
     appBar: AppBar(
         automaticallyImplyLeading: false,
         leading: IconButton( onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MenuPage(),
      ),
    );}, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
  title: Text("NASA Astronomy Image",style: TextStyle(color: Colors.white),),
  backgroundColor: Colors.blueGrey.withOpacity(0.3),
  actions: [
    IconButton(
      icon: Icon(Icons.calendar_today,color: Colors.white,),
      onPressed: () => _selectDate(context),
    ),
  ],
),

     body: Container(
      height: double.infinity,
  decoration: const BoxDecoration(
    image: DecorationImage(
      image: AssetImage("assets/background_image.jpg"),
      fit: BoxFit.cover,
    ),
  ),
  child: imageUrl.isEmpty
      ? Center(child: CircularProgressIndicator())
      : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    Icon(Icons.error_outline),
                height: 300,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  description,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
),
    );
  }
}