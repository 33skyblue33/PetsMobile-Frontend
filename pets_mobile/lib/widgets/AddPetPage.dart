import 'package:flutter/material.dart';
import 'package:pets_mobile/api/petService.dart';
import 'package:pets_mobile/api/models/petRequest.dart';

class AddPetPage extends StatefulWidget {
  final String token;
  const AddPetPage({Key? key, required this.token}) : super(key: key);

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _colorController = TextEditingController();
  final _ageController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _breedIdController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final petRequest = PetRequest(
        name: _nameController.text,
        color: _colorController.text,
        age: int.parse(_ageController.text),
        imageUrl: _imageUrlController.text,
        description: _descriptionController.text,
        breedId: int.parse(_breedIdController.text),
      );

      try {
        await createPet(petRequest, widget.token);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pet created successfully!'), backgroundColor: Colors.green),
          );
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create pet: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    _ageController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    _breedIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a New Pet')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: 16),
                TextFormField(controller: _colorController, decoration: const InputDecoration(labelText: 'Color', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: 16),
                TextFormField(controller: _ageController, decoration: const InputDecoration(labelText: 'Age', border: OutlineInputBorder()), keyboardType: TextInputType.number, validator: (v) => (v!.isEmpty || int.tryParse(v) == null) ? 'Enter valid number' : null),
                const SizedBox(height: 16),
                TextFormField(controller: _imageUrlController, decoration: const InputDecoration(labelText: 'Image URL', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: 16),
                TextFormField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()), maxLines: 3, validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: 16),
                TextFormField(controller: _breedIdController, decoration: const InputDecoration(labelText: 'Breed ID', border: OutlineInputBorder()), keyboardType: TextInputType.number, validator: (v) => (v!.isEmpty || int.tryParse(v) == null) ? 'Enter valid number' : null),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: _isLoading ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Add Pet', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}