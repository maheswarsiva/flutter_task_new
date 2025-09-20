// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/providers/auth_provider.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (v) => v != null && v.contains('@') ? null : 'Enter valid email',
                onSaved: (v) => email = v!.trim(),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) => v != null && v.length >= 6 ? null : 'Min 6 chars',
                onSaved: (v) => password = v!.trim(),
              ),
              SizedBox(height: 20),
              auth.loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          final ok = await auth.signUp(email, password);
                          if (ok) {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(auth.error ?? 'Signup failed')));
                          }
                        }
                      },
                      child: Text('Create'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}