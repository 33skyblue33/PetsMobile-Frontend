import 'package:flutter/material.dart';
import '../api/models/pet.dart';

class PetDetails extends StatelessWidget {
  final Pet pet;

  const PetDetails({Key? key, required this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(pet.imageUrl),
                  onBackgroundImageError: (_, __) {},
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    pet.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoChip(Icons.cake_outlined, '${pet.age} years old'),
                _buildInfoChip(Icons.color_lens_outlined, pet.color),
              ],
            ),
            const Divider(height: 40),
            _buildSectionTitle(context, 'Breed'),
            const SizedBox(height: 8),
            Text(
              pet.breedName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              pet.breedDescription,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'About ${pet.name}'),
            const SizedBox(height: 8),
            Text(
              pet.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 20),
      label: Text(text),
    );
  }
}