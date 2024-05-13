import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_app/pages/login_page.dart';
import 'package:supabase_app/providers/auth_provider.dart';
import 'package:supabase_app/services/supabase_service.dart';


class HomePage extends StatelessWidget {
  Future<String?> _getUserRole(String? userId) async {
    if (userId == null) {
      return null;
    }

    try {
      final response = await SupabaseService.client
          .from('user_roles')
          .select('role')
          .eq('user_id', userId)
          .single();

      return response['role'] as String?;
    } catch (error) {
      print('Error fetching user role: $error');
      return null;
    }
  }

  Future<void> _selectAccountType(BuildContext context, String? userId) async {
    if (userId == null) {
      return;
    }

    final selectedRole = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Account Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Store Account'),
              onTap: () => Navigator.pop(context, 'store'),
            ),
            ListTile(
              title: const Text('Welfare User'),
              onTap: () => Navigator.pop(context, 'welfare'),
            ),
          ],
        ),
      ),
    );

    if (selectedRole != null) {
      try {
        await SupabaseService.client
            .from('user_roles')
            .insert({'user_id': userId, 'role': selectedRole});
        // Account type saved successfully
      } catch (error) {
        // Handle the error
        print('Error saving account type: $error');
      }
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await SupabaseService.client.auth.signOut();
      context.read<AuthProvider>().setAuthenticationState(false, null);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (error) {
      print('Error logging out: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthProvider>().userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<String?>(
        future: _getUserRole(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final userRole = snapshot.data;

            if (userRole == null) {
              return Center(
                child: ElevatedButton(
                  onPressed: () => _selectAccountType(context, userId),
                  child: const Text('Select Account Type'),
                ),
              );
            } else {
              return Center(
                child: Text('User Role: $userRole'),
              );
            }
          }
        },
      ),
    );
  }
}