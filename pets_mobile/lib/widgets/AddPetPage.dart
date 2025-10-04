import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:pets_mobile/api/breedProvider.dart';
import 'package:pets_mobile/api/models/breed.dart';
import 'package:pets_mobile/api/models/petRequest.dart';
import 'package:pets_mobile/api/petService.dart';

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
  final _descriptionController = TextEditingController();
  
  int? _selectedBreedId;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an image.')));
      return;
    }
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final petRequest = PetRequest(
        name: _nameController.text,
        color: _colorController.text,
        age: int.parse(_ageController.text),
        description: _descriptionController.text,
        breedId: _selectedBreedId!,
      );

      try {
        await createPet(petRequest, _imageFile!, widget.token);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pet created successfully!'), backgroundColor: Colors.green));
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create pet: $e'), backgroundColor: Colors.red));
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
    _descriptionController.dispose();
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
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: _imageFile != null
                        ? ClipRRect(borderRadius: BorderRadius.circular(8.0), child: Image.file(_imageFile!, fit: BoxFit.cover))
                        : const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.camera_alt), Text('Select a photo')]),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: 16),
                TextFormField(controller: _colorController, decoration: const InputDecoration(labelText: 'Color', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: 16),
                TextFormField(controller: _ageController, decoration: const InputDecoration(labelText: 'Age', border: OutlineInputBorder()), keyboardType: TextInputType.number, validator: (v) => (v!.isEmpty || int.tryParse(v) == null) ? 'Enter valid number' : null),
                const SizedBox(height: 16),
                TextFormField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()), maxLines: 3, validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: 16),
                Consumer<BreedProvider>(
                  builder: (context, breedProvider, child) {
                    if (breedProvider.isLoading) return const Center(child: CircularProgressIndicator());
                    if (breedProvider.error != null) return Center(child: Text('Error loading breeds: ${breedProvider.error}'));
                    return DropdownButtonFormField<int>(
                      value: _selectedBreedId,
                      decoration: const InputDecoration(labelText: 'Breed', border: OutlineInputBorder()),
                      items: breedProvider.breeds.map((Breed breed) => DropdownMenuItem<int>(value: breed.id, child: Text(breed.name))).toList(),
                      onChanged: (int? newValue) => setState(() => _selectedBreedId = newValue),
                      validator: (value) => value == null ? 'Please select a breed' : null,
                    );
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Add Pet', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}