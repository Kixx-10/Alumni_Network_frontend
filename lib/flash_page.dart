// lib/flashPage.dart
import 'package:alumni_network/data/provider/auth_provider.dart';
import 'package:alumni_network/pages/home_page.dart';
import 'package:alumni_network/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlashPage extends ConsumerStatefulWidget {
  const FlashPage({super.key});

  @override
  ConsumerState<FlashPage> createState() => _FlashPageState();
}

class _FlashPageState extends ConsumerState<FlashPage> {
  
  Future<void> _checkAuthentication() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final bool isLoggedIn = await ref.read(authCheckProvider.future);

    if (context.mounted) {
      if (isLoggedIn) {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // if no token send login
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 194, 237, 242),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage("assets/images/logo.png"),
              width: 100.w,
              height: 120.h,
            ),
            SizedBox(height: 50.h),
            const CircularProgressIndicator(
              backgroundColor: Color.fromARGB(255, 138, 177, 219),
              color: Color.fromARGB(255, 101, 100, 100),
            ),
            SizedBox(height: 100.h),
            const Text(
              "Alumni Network",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}