import 'package:flutter/material.dart';
import 'package:pets_mobile/api/models/pet.dart';
import 'package:pets_mobile/api/models/user.dart';
import 'package:pets_mobile/api/petService.dart';
import 'package:pets_mobile/widgets/EditPetPage.dart';

class PetDetails extends StatelessWidget {
  final Pet pet;
  final User? user;
  final String token;
  final VoidCallback onDataChanged;

  const PetDetails({
    Key? key,
    required this.pet,
    required this.user,
    required this.token,
    required this.onDataChanged,
  }) : super(key: key);

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to remove this pet listing?'),
        actions: <Widget>[
          TextButton(child: const Text('No'), onPressed: () => Navigator.of(ctx).pop()),
          TextButton(
            child: const Text('Yes'),
            onPressed: () async {
              try {
                Navigator.of(ctx).pop();
                await deletePet(pet.id, token);
                Navigator.of(context).pop();
                onDataChanged();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pet removed successfully!'), backgroundColor: Colors.green));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to remove pet: $e'), backgroundColor: Colors.red));
              }
            },
          )
        ],
      ),
    );
  }

  void _navigateToEditPage(BuildContext context) async {
    Navigator.of(context).pop();
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => EditPetPage(token: token, pet: pet)),
    );
    if (result == true) {
      onDataChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4,
            width: 40,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              pet.imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, st) => Container(
                height: 250,
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                child: Icon(Icons.pets, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 48),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pet.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  pet.breedName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [
                    _buildInfoChip(context, Icons.cake_outlined, '${pet.age} years old'),
                    _buildInfoChip(context, Icons.color_lens_outlined, pet.color),
                  ],
                ),
                const Divider(height: 40),
                _buildSectionTitle(context, 'About'),
                const SizedBox(height: 8),
                Text(
                  pet.description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Breed Details'),
                const SizedBox(height: 8),
                Text(
                  pet.breedDescription,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                if (user?.role == 'Employee')
                  _buildEmployeeActions(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _navigateToEditPage(context),
            icon: const Icon(Icons.edit),
            label: const Text('Edit'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _confirmDelete(context),
            icon: const Icon(Icons.delete_forever),
            label: const Text('Remove'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: Colors.red[700],
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
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

  Widget _buildInfoChip(BuildContext context, IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
      label: Text(text),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
      side: BorderSide.none,
    );
  }
}