import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

//create class for category images screen
class CategoryImagesScreen extends StatefulWidget {
  // create constructor for category images screen
  final String categoryTitle;
  final Map<String, List<String>> categoryImages;

  const CategoryImagesScreen({
    required this.categoryTitle,
    required this.categoryImages,
  });

  //create state for category images screen
  @override
  _CategoryImagesScreenState createState() => _CategoryImagesScreenState();
}

// create state for category images screen
class _CategoryImagesScreenState extends State<CategoryImagesScreen> {
  String selectedSubCategory = "";

  @override
  void initState() {
    super.initState();
    // Set the first sub-category as the default selected one
    selectedSubCategory = widget.categoryImages.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD7C6BD),
        title: Text(
          widget.categoryTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: Container(
        // background color
        color: const Color(0xFFFEFFFE),
        child: Stack(
          children: [
            Positioned.fill(
              // background image
              child: Image.asset(
                "assets/explore inner background.png",
                fit: BoxFit.cover,
              ),
            ),
            Column( // main column for the category images screen with sub-categories and images
              crossAxisAlignment: CrossAxisAlignment.start, // Align the text to the left
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Add padding to the text
                  child: SingleChildScrollView( // Add a SingleChildScrollView to scroll horizontally
                    scrollDirection: Axis.horizontal, // Scroll horizontally
                    child: Row( // Row to display the sub-categories
                      children: widget.categoryImages.keys.map((subCategory) { // Map the sub-categories to buttons
                        return TextButton(
                          onPressed: () {
                            setState(() {
                              selectedSubCategory = subCategory;
                            });
                          },
                          child: Text(
                            subCategory,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: selectedSubCategory == subCategory ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Expanded( // Wrap the MasonryGridView with Expanded to make it fill the available space
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      itemCount: widget.categoryImages[selectedSubCategory]?.length ?? 0, // Get the number of images for the selected sub-category
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            widget.categoryImages[selectedSubCategory]![index], // Get the image path for the selected sub-category
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
