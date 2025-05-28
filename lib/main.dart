import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import './categoryImageScreen.dart';

import 'package:firebase_storage/firebase_storage.dart';

void main() {
  runApp(MaterialApp(
    home: FurnitureScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class FurnitureScreen extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {"title": "Bohemian", "image": "assets/bohemiancrop.jpg"},
    {"title": "Kids", "image": "assets/kids.jpg"},
    {"title": "Modern", "image": "assets/modern.jpg"},
    {"title": "Classic", "image": "assets/classic.jpg"},
  ];

  final Map<String, Map<String, List<String>>> categoryImages = {
    "Bohemian": {
      "Beds": [
        "assets/boho_bed_1.png",
        "assets/boho_bed_2.png",
        "assets/boho_bed_3.png"
      ],
      "Sofas": [
       "assets/boho_sofa_1.png",
        "assets/boho_sofa_2.png",
        "assets/boho_sofa_3.png"
      ],
      "waredrops":[
       "assets/boho_waredrobe_1.png",
        "assets/boho_waredrobe_2.png",
        "assets/boho_waredrobe_3.png"
      ]
    },
    "Kids": {
      "Beds": [
        "assets/kids_bed_1.png",
        "assets/kids_bed_2.png",
        "assets/kids_bed_3.png",
      ],
      "Sofas": [
        "assets/kids_sofa_1.png",
        "assets/kids_sofa_2.png",
        "assets/kids_sofa_3.png",
      ],
      "Wardrops": [
        "assets/kids_wardrop_1.png",
        "assets/kids_wardrop_2.png",
        "assets/kids_wardrop_3.png",
      ],
    },
    "Classic": {
      "Beds": [
        "assets/classic_bed_1.png",
        "assets/classic_bed_2.png",
        "assets/classic_bed_3.png",
      ],
      "Sofas": [
        "assets/classic_sofa_1.png",
        "assets/classic_sofa_2.png",
        "assets/classic_sofa_3.png",
      ],
    },
    "Modern": {
      "Beds": [
        "assets/modern_bed_1.png",
        "assets/modern_bed_2.png",
        "assets/modern_bed_3.png",
      ],
      "Sofas": [
        "assets/modern_sofa_1.png",
        "assets/modern_sofa_2.png",
        "assets/modern_sofa_3.png",
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              "assets/explore outer background.png",
              fit: BoxFit.cover,
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40), // Add spacing at the top
                // title text
                const Text(
                  "Furniture\nin your style",
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20), // Add spacing between title and categories

                // Categories
                Expanded(
                  // Wrap the MasonryGridView with Expanded to make it fill the available space
                  child: MasonryGridView.count(
                    crossAxisCount: 2, // Number of columns
                    mainAxisSpacing: 10, // Spacing between rows
                    crossAxisSpacing: 10, // Spacing between columns
                    itemCount: categories.length, // Number of our categories list (bohemian, kids, modern, classic)
                    itemBuilder: (context, index) { // Build our categories cards using our CategoryCard widget
                      return GestureDetector( // Add a GestureDetector to handle taps
                        onTap: () {
                          String selectedCategory = categories[index]["title"]!; // Get the title of the selected category
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryImagesScreen(
                                categoryTitle: selectedCategory,
                                categoryImages: categoryImages[selectedCategory] ?? {},
                              ),
                            ),
                          );
                        },
                        child: CategoryCard(
                          title: categories[index]["title"]!,
                          imagePath: categories[index]["image"]!,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;

  // Constructor for the CategoryCard widget
  const CategoryCard({
    required this.title,
    required this.imagePath
  });

  @override
  Widget build(BuildContext context) {
    return Material( // Wrap the Material widget around the Card widget to add elevation and rounded corners
      elevation: 5,
      borderRadius: BorderRadius.circular(16),
      child: ClipRRect( // Clip the image to the rounded corners
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity, // Make the image fill the available width
            ),
            Positioned( // Positioned widget to place the title text on top of the image
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.white.withOpacity(0.7),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}