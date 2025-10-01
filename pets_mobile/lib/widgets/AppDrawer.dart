import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pets_mobile/api/authService.dart';
import 'package:pets_mobile/widgets/LoginPage.dart';
import 'package:pets_mobile/widgets/RegisterPage.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(title: const Text('Menu'), automaticallyImplyLeading: false),
          const Divider(),
          Consumer<AuthService>(
            builder: (context, auth, _) {
              if (auth.isLoggedIn) {
                return ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.of(context).pop();
                    auth.logout();
                  },
                );
              } else {
                return Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.login),
                      title: const Text('Login'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginPage()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.person_add),
                      title: const Text('Register'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterPage()));
                      },
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}