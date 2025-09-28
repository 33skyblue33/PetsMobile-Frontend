import 'package:flutter/material.dart';
import 'package:pets_mobile/api/models/pet.dart';   
import 'package:pets_mobile/api/petService.dart';
import 'package:pets_mobile/widgets/PetCard.dart';    

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pets Mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Pets Mobile'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Pet>>? _futurePets;

  @override
  void initState() {
    super.initState();
    _futurePets = fetchPets();
  }

  Future<void> _refreshPets() async {
    setState(() {
      _futurePets = fetchPets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Pet>>(
        future: _futurePets, 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          else if (snapshot.hasData) {
            final pets = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _refreshPets,
              child: ListView.builder(
                itemCount: pets.length,
                itemBuilder: (context, index) {
                  final pet = pets[index];
                  return PetCard(
                    pet: pet,
                    onTap: () {
                      print('Tapped on ${pet.name}');
                    },
                  );
                },
              ),
            );
          }
          else {
            return const Center(child: Text('No pets found.'));
          }
        },
      ),
    );
  }
}