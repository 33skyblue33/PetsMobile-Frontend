import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pets_mobile/api/authService.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final Map<String, String> _formData = {};
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);
    try {
      await Provider.of<AuthService>(context, listen: false).register(
        _formData['name']!,
        _formData['surname']!,
        int.parse(_formData['age']!),
        _formData['email']!,
        _formData['password']!,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful! Please log in.'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      }
    } catch (error) {
       if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${error.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  
  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(decoration: const InputDecoration(labelText: 'Name'), validator: (v) => v!.isEmpty ? 'Required' : null, onSaved: (v) => _formData['name'] = v!),
                  const SizedBox(height: 12),
                  TextFormField(decoration: const InputDecoration(labelText: 'Surname'), validator: (v) => v!.isEmpty ? 'Required' : null, onSaved: (v) => _formData['surname'] = v!),
                  const SizedBox(height: 12),
                  TextFormField(decoration: const InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null, onSaved: (v) => _formData['age'] = v!),
                  const SizedBox(height: 12),
                  TextFormField(decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress, validator: (v) => v!.isEmpty ? 'Required' : null, onSaved: (v) => _formData['email'] = v!),
                  const SizedBox(height: 12),
                  TextFormField(decoration: const InputDecoration(labelText: 'Password'), controller: _passwordController, obscureText: true, validator: (v) => v!.length < 6 ? 'Min 6 characters' : null, onSaved: (v) => _formData['password'] = v!),
                  const SizedBox(height: 12),
                  TextFormField(decoration: const InputDecoration(labelText: 'Confirm Password'), obscureText: true, validator: (v) => v != _passwordController.text ? 'Passwords do not match' : null),
                  const SizedBox(height: 20),
                  if (_isLoading) const CircularProgressIndicator() else ElevatedButton(onPressed: _submit, child: const Text('Register')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}