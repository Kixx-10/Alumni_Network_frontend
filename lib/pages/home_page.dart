import 'package:alumni_network/core/network/api_client.dart';
import 'package:alumni_network/data/model/profile/response_profile_model.dart';
import 'package:alumni_network/data/provider/auth_provider.dart';
import 'package:alumni_network/data/provider/response_profile_notifier.dart';
import 'package:alumni_network/data/provider/theme_notifier.dart'; 
import 'package:alumni_network/pages/login_page.dart';
import 'package:alumni_network/pages/message_page.dart'; 
import 'package:alumni_network/pages/network_page.dart';
import 'package:alumni_network/pages/profile_page.dart';
import 'package:alumni_network/tab/home_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomeTab(),
    const NetworkTab(),
    const MessageTab(),
    const ProfileTab(),
  ];

  //  Global & Modern Async Logout Function
  Future<void> logOutAsync() async {
    try {
      await ref.read(tokenStorageProvider).deleteToken(); 
      ref.invalidate(authCheckProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Successfully logged out!"),
          backgroundColor: Colors.green,
        ),);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Logout failed: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  String _resolveAvatarUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.trim().isEmpty) return '';
    if (rawUrl.startsWith('http')) return rawUrl;
    final String baseUrl = 'http://${ApiClient.ipAddress}';
    return '$baseUrl$rawUrl';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;
    final navBarBgColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final activeItemColor = const Color.fromARGB(255, 13, 93, 231);
    final inactiveItemColor = isDarkMode ? Colors.grey[500]! : Colors.grey[400]!;

     final profileAsync = ref.watch(responseProfileProvider);
        final String userName = profileAsync.isLoading 
    ? "" 
    : (profileAsync.value?.fullName ?? "Unknown");
        final String? rawUrl = profileAsync.value?.avatarUrl;
  final String resolvedUrl = (profileAsync.isLoading || rawUrl == null) 
      ? '' 
      : _resolveAvatarUrl(rawUrl);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alumni Network',
          style: TextStyle(color: Color.fromARGB(255, 13, 93, 231), fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white, 
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 13, 93, 231)), 
      ),
      drawer: Drawer(
        child: Column( 
          children: [
            UserAccountsDrawerHeader(
              //decoration: const BoxDecoration(color: Colors.blue),
              accountName: Text(userName, style: TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: const Text("settings & privacy"),
              currentAccountPicture: CircleAvatar(
                         backgroundImage: resolvedUrl.isNotEmpty
      ? NetworkImage(resolvedUrl)
      : const AssetImage('assets/images/profile.jpg') as ImageProvider,
              ),
            ),
            ListTile(
              leading: Icon(
                isDarkMode ? Icons.dark_mode : Icons.dark_mode_outlined,
                color: isDarkMode ? Colors.orangeAccent : Colors.grey,
              ),
              title: const Text('Dark Mode'), 
              trailing: Switch(
                value: isDarkMode, 
                onChanged: (bool val) {
                  ref.read(themeProvider.notifier).toggleTheme(val); 
                },
              ),
            ),
            ListTile(
              title: const Text('Change Password'), 
              trailing: Icon(Icons.password),
              onTap: (){},
            ),
            const Spacer(), 
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: () async {
                Navigator.pop(context); 
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Logout"),
                    content: const Text("Are you sure you want to logout from your account?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); 
                          logOutAsync(); 
                        },
                        child: const Text("Logout", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 15.h),
          ],
        ),
      ),
      
      body: SafeArea(
        child: IndexedStack(index: _currentIndex, children: _pages),
      ),
      
      bottomNavigationBar: SafeArea(
        child: Container(
       
          height: MediaQuery.of(context).orientation == Orientation.landscape ? 70.h : 65.h,
          margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 12.h, top: 4.h),
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            color: navBarBgColor, 
            borderRadius: BorderRadius.circular(24.r), 
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Colors.black54 : Colors.black.withValues(alpha:0.08),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _makeTabItem(Icons.home_rounded, Icons.home_outlined, "Home", 0, activeItemColor, inactiveItemColor),
              _makeTabItem(Icons.people_alt_rounded, Icons.people_outline_rounded, "Network", 1, activeItemColor, inactiveItemColor),
              _makeTabItem(Icons.chat_bubble_rounded, Icons.chat_bubble_outline_rounded, "Message", 2, activeItemColor, inactiveItemColor),
              _makeTabItem(Icons.person_rounded, Icons.person_outline_rounded, "Profile", 3, activeItemColor, inactiveItemColor),
            ],
          ),
        ),
      ),
    );
  }
  Widget _makeTabItem(IconData activeIcon, IconData inactiveIcon, String label, int index, Color activeColor, Color inactiveColor) {
    bool isActive = _currentIndex == index;
    
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: activeColor.withValues(alpha: 0.1),
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            setState(() {
              _currentIndex = index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: isActive ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isActive ? activeIcon : inactiveIcon,
                    color: isActive ? activeColor : inactiveColor,
                    size: 24.sp,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive ? activeColor : inactiveColor,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}