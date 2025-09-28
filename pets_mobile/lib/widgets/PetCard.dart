import 'package:flutter/material.dart';
import '../api/models/pet.dart'; 

class PetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback? onTap; // A callback function to handle taps

  const PetCard({
    Key? key,
    required this.pet,
    this.onTap, // Make the onTap optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      // This clips the child widgets (like the image) to the card's rounded corners.
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 5,
      // Add margin to create space between cards in a list
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        onTap: onTap, // Execute the callback when the card is tapped
        child: Column(
          // Ensures children are aligned to the start (left) and stretch to fill width
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // --- IMAGE SECTION ---
            Image.network(
              pet.imageUrl,
              height: 200, // Fixed height for a consistent look in a list
              fit: BoxFit.cover, // Ensures the image covers the space without distortion
              
              // Show a loading spinner while the image is loading
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child; // Image is loaded, show it
                return Container(
                  height: 200,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              
              // Show a placeholder icon if the image fails to load
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.pets, // Or Icons.broken_image
                    color: Colors.grey[400],
                    size: 48,
                  ),
                );
              },
            ),

            // --- TEXT SECTION ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    // Example of displaying more info in a subtitle
                    '${pet.breedName} • ${pet.age} years old',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}