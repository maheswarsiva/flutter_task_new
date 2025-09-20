// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../presentation/providers/auth_provider.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

 Future<bool> requestStoragePermission() async {
  if (await Permission.manageExternalStorage.request().isGranted) {
    debugPrint("All files access granted");
    return true;
  } else if (await Permission.manageExternalStorage.isPermanentlyDenied) {
    await openAppSettings();
    return false;
  } else {
    return false;
  }
}

@override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
    requestStoragePermission();
  });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
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
                          final ok = await auth.signIn(email, password);
                          if (ok) {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(auth.error ?? 'Login failed')));
                          }
                        }
                      },
                      child: Text('Sign In'),
                    ),
              TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SignupScreen())), child: Text('Create account')),
            ],
          ),
        ),
      ),
    );
  }
}