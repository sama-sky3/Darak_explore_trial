import 'package:explore/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

//create class for category images screen
class CategoryImagesScreen extends StatefulWidget {
  // create constructor for category images screen
  final Category category;

  const CategoryImagesScreen({
    required this.category
  });

  //create state for category images screen
  @override
  _CategoryImagesScreenState createState() => _CategoryImagesScreenState();
}

// create state for category images screen
class _CategoryImagesScreenState extends State<CategoryImagesScreen> {
  int selectedSubCategoryIdx = 0; // Initialize the selected sub-category index

  @override
  Widget build(BuildContext context) {
    final selectedSubCategory = widget.category.subCategories[selectedSubCategoryIdx];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD7C6BD),
        title: Text(
          // Display the category title
          widget.category.name,
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
                    scrollDirection: Axis.horizontal,
                    child: Row( // Row to display the sub-categories
                      children: widget.category.subCategories.indexed.map((pair) { // Map the sub-categories to buttons
                        final (index, subCategory) = pair;
                        return TextButton(
                          onPressed: () {
                            setState(() {
                              selectedSubCategoryIdx = index;
                            });
                          },
                          child: Text(
                            subCategory.name,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: selectedSubCategoryIdx == index ? FontWeight.bold : FontWeight.normal,
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

                      itemCount: selectedSubCategory.images.length, // Get the number of images for the selected sub-category
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child:
                          ImageCard(
                            imagePath: 'https://raw.githubusercontent.com/NadaHenedy/ar_data/refs/heads/main/explore_images/${widget.category.path}/${selectedSubCategory.path}/${selectedSubCategory.images[index]}',
                            isFavorite: false,
                            onFavoritePressed: () {
                              //TODO
                              // Handle favorite toggle here
                            },
                          )
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


class ImageCard extends StatelessWidget {
  final String imagePath;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;

  const ImageCard({
    required this.imagePath,
    this.isFavorite = false,
    required this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFDAD5D1), // Background color
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            // Image part
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child:    // Image part
              Image.network(
                imagePath, // Use the provided path directly
                fit: BoxFit.cover,
                width: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),

            // Favorite button
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: onFavoritePressed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
