import 'package:alumni_network/data/provider/auth_provider.dart';
import 'package:alumni_network/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
 ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
  Future<void>logOutAsync()async{
try{
  await ref.read(tokenStorageProvider).deleteToken();
  if(!mounted)return;
  ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Succeessfully Logout"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false, 
    );
}catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: logOutAsync, child: Text("Logout"))
      ),
    );
  }
}