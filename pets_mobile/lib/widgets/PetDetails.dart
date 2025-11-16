import 'package:flutter/material.dart';
import 'package:pets_mobile/api/models/pet.dart';
import 'package:pets_mobile/api/models/rating.dart';
import 'package:pets_mobile/api/models/user.dart';
import 'package:pets_mobile/api/petService.dart';
import 'package:pets_mobile/widgets/EditPetPage.dart';
import 'package:pets_mobile/widgets/AddRatingDialog.dart'; 

class PetDetails extends StatefulWidget {
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

  @override
  State<PetDetails> createState() => _PetDetailsState();
}

class _PetDetailsState extends State<PetDetails> {
  final List<Rating> _ratings = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasMore = true;
  int? _nextPointer;
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _fetchRatings();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      _fetchRatings();
    }
  }

  Future<void> _fetchRatings() async {
    if (_isLoading || !_hasMore) return;
    setState(() => _isLoading = true);

    try {
      final pagedResult = await fetchPetRatings(
        petId: widget.pet.id,
        pointer: _nextPointer,
      );
      setState(() {
        _ratings.addAll(pagedResult.items);
        _hasMore = pagedResult.hasNextPage;
        _nextPointer = pagedResult.nextPointer;
        _isInitialLoad = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load ratings: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _refreshRatings() async {
    setState(() {
      _ratings.clear();
      _nextPointer = null;
      _hasMore = true;
      _isInitialLoad = true;
    });
    await _fetchRatings();
  }

  void _showAddRatingDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AddRatingDialog(
        petId: widget.pet.id,
        token: widget.token,
      ),
    );

    if (result == true) {
      _refreshRatings(); 
      widget.onDataChanged();
    }
  }
  
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to remove this pet listing?'),
        actions: <Widget>[
          TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(ctx).pop()),
          TextButton(
            child: const Text('Yes'),
            onPressed: () async {
              try {
                Navigator.of(ctx).pop();
                await deletePet(widget.pet.id, widget.token);
                Navigator.of(context).pop();
                widget.onDataChanged();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Pet removed successfully!'),
                    backgroundColor: Colors.green));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Failed to remove pet: $e'),
                    backgroundColor: Colors.red));
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
      MaterialPageRoute(
          builder: (context) =>
              EditPetPage(token: widget.token, pet: widget.pet)),
    );
    if (result == true) {
      widget.onDataChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
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
              widget.pet.imageUrl,
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
                Text(widget.pet.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(widget.pet.breedName, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                const SizedBox(height: 16),
                Wrap(spacing: 8.0, runSpacing: 4.0, children: [_buildInfoChip(context, Icons.cake_outlined, '${widget.pet.age} years old'), _buildInfoChip(context, Icons.color_lens_outlined, widget.pet.color)]),
                const Divider(height: 40),
                _buildSectionTitle(context, 'About'),
                const SizedBox(height: 8),
                Text(widget.pet.description, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5)),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Breed Details'),
                const SizedBox(height: 8),
                Text(widget.pet.breedDescription, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),

                const Divider(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionTitle(context, 'Ratings & Reviews'),
                    if (widget.user != null)
                      TextButton.icon(
                        onPressed: () => _showAddRatingDialog(context),
                        icon: const Icon(Icons.add_comment_outlined),
                        label: const Text('Add Review'),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildRatingsList(),
                const SizedBox(height: 32),
                if (widget.user?.role == 'Employee') _buildEmployeeActions(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

   Widget _buildRatingsList() {
    if (_isInitialLoad) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_ratings.isEmpty) {
      return const Center(child: Text('No ratings yet. Be the first!'));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _ratings.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _ratings.length) {
          return const Center(child: CircularProgressIndicator());
        }
        final rating = _ratings[index];
        return _RatingListItem(rating: rating);
      },
    );
  }

  Widget _buildEmployeeActions(BuildContext context) {
    return Row(
      children: [
        Expanded(child: ElevatedButton.icon(onPressed: () => _navigateToEditPage(context), icon: const Icon(Icons.edit), label: const Text('Edit'), style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), backgroundColor: Colors.blue[700], foregroundColor: Colors.white))),
        const SizedBox(width: 16),
        Expanded(child: ElevatedButton.icon(onPressed: () => _confirmDelete(context), icon: const Icon(Icons.delete_forever), label: const Text('Remove'), style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), backgroundColor: Colors.red[700], foregroundColor: Colors.white))),
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

class _RatingListItem extends StatelessWidget {
  final Rating rating;
  const _RatingListItem({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStarRating(rating.value),
            const SizedBox(height: 8),
            Text(
              rating.comment,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(int value) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < value ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }
}