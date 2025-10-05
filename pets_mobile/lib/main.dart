import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pets_mobile/api/authService.dart';
import 'package:pets_mobile/api/breedProvider.dart';
import 'package:pets_mobile/api/themeProvider.dart';
import 'package:pets_mobile/api/models/pet.dart';
import 'package:pets_mobile/api/petService.dart';
import 'package:pets_mobile/widgets/PetCard.dart';
import 'package:pets_mobile/widgets/PetDetails.dart';
import 'package:pets_mobile/widgets/AddPetPage.dart';
import 'package:pets_mobile/widgets/AppDrawer.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => BreedProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Pets Mobile',
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: Consumer<AuthService>(
        builder: (context, auth, _) {
          if (auth.isLoading) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          return const HomePage(title: 'Pets Mobile');
        },
      ),
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

  void _navigateToAddPetPage(String token) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => AddPetPage(token: token)),
    );
    if (result == true) {
      _refreshPets();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder<List<Pet>>(
        future: _futurePets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
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
                      if (!authService.isLoggedIn) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please log in to view details.')));
                        return;
                      }
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                        builder: (BuildContext context) {
                          return PetDetails(
                            pet: pet,
                            user: authService.user,
                            token: authService.accessToken!,
                            onDataChanged: _refreshPets,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            );
          } else {
            return const Center(child: Text('No pets found.'));
          }
        },
      ),
      floatingActionButton: authService.user?.role == 'Employee'
          ? FloatingActionButton.extended(
              onPressed: () => _navigateToAddPetPage(authService.accessToken!),
              icon: const Icon(Icons.add),
              label: const Text('Add Pet'),
            )
          : null,
    );
  }
}