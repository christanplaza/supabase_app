import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_app/pages/login_page.dart';
import 'package:supabase_app/providers/auth_provider.dart';
import 'package:supabase_app/services/supabase_service.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context).userId;

    Future<void> _signOut() async {
      try {
        await SupabaseService.client.auth.signOut();
        // Clear the authentication state
        context.read<AuthProvider>().setAuthenticationState(false, '');
        // Navigate back to the LoginPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        print('Signed out successfully!');
      } catch (error) {
        print('Sign-out error: $error');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome, user ID: $userId'),
      ),
    );
  }
}
