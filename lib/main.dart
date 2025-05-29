import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './categoryImageScreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: FurnitureScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class FurnitureScreen extends StatefulWidget {
  @override
  _FurnitureScreenState createState() => _FurnitureScreenState();
}

class _FurnitureScreenState extends State<FurnitureScreen> {
  // GitHub configuration
  final String repoOwner = 'your-github-username';
  final String repoName = 'your-repo-name';
  final String branch = 'main';
  final String basePath = 'ar_data';

  // Category data
  final List<Map<String, String>> categories = [
    {"title": "Bohemian", "image": "bohemiancrop.jpg"},
    {"title": "Kids", "image": "kids.jpg"},
    {"title": "Modern", "image": "modern.jpg"},
    {"title": "Classic", "image": "classic.jpg"},
  ];

  Map<String, Map<String, List<String>>> categoryImages = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategoryImages();
  }

  Future<void> _loadCategoryImages() async {
    try {
      for (var category in categories) {
        final categoryName = category['title']!;
        final folderName = _getFolderName(categoryName);
        categoryImages[categoryName] = {};

        final subcategories = ['Beds', 'Sofas', 'Wardrobes'];

        for (var subcategory in subcategories) {
          final images = await _getImagesForSubcategory(folderName, subcategory);
          categoryImages[categoryName]![subcategory] = images;
        }
      }

      setState(() => isLoading = false);
    } catch (e) {
      print('Error loading images: $e');
      setState(() => isLoading = false);
    }
  }

  String _getFolderName(String category) {
    switch (category) {
      case 'Bohemian': return 'boho';
      default: return category.toLowerCase();
    }
  }

  Future<List<String>> _getImagesForSubcategory(String categoryFolder, String subcategory) async {
    final path = '$basePath/explore_images/$categoryFolder/$subcategory';
    final apiUrl = 'https://api.github.com/repos/$repoOwner/$repoName/contents/$path';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> files = json.decode(response.body);
        return files
            .where((file) => file['type'] == 'file')
            .map<String>((file) => _getCdnUrl('$path/${file['name']}'))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error loading $categoryFolder/$subcategory: $e');
      return [];
    }
  }

  String _getCdnUrl(String relativePath) {
    return 'https://cdn.jsdelivr.net/gh/$repoOwner/$repoName@$branch/$relativePath';
  }

  String _getCategoryImageUrl(String imageName) {
    return _getCdnUrl('$basePath/category_images/$imageName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: _getCdnUrl('$basePath/explore_images/background.png'),
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[200]),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Furniture\nin your style",
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Expanded(
                  child: MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryImagesScreen(
                                categoryTitle: categories[index]["title"]!,
                                categoryImages: categoryImages[categories[index]["title"]!] ?? {},
                              ),
                            ),
                          );
                        },
                        child: CategoryCard(
                          title: categories[index]["title"]!,
                          imageUrl: _getCategoryImageUrl(categories[index]["image"]!),
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
  final String imageUrl;

  const CategoryCard({
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                height: 150, // Set a fixed height for placeholder
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[200],
                height: 150,
                child: Icon(Icons.error),
              ),
            ),
            Positioned(
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