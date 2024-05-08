import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_app/pages/home_page.dart';
import 'package:supabase_app/pages/signup_page.dart';
import 'package:supabase_app/providers/auth_provider.dart';
import 'package:supabase_app/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  Future<void> _signIn() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    try {
      final res = await SupabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.user != null) {
        // Set the authentication state
        context.read<AuthProvider>().setAuthenticationState(true, res.user!.id);

        // Navigate to the HomePage and remove the LoginPage from the navigation stack
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );

        print('USER INFORMATION: ${res.user!.toJson()}');
      }
    } on AuthException catch (error) {
      // Handle AuthException error
      print('Sign-in error: ${error.message}');
    } catch (error) {
      // Handle other errors
      print('Sign-in error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login to Last Two Hours'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _signIn,
              child: const Text('Sign In'),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: _navigateToSignUp,
              child: const Text('No account yet? Click here to sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
