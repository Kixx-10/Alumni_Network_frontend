import 'package:alumni_network/pages/messagePage.dart';
import 'package:alumni_network/pages/networkPage.dart';
import 'package:alumni_network/pages/profile_page.dart';
import 'package:alumni_network/tab/home_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
    final List<Widget> _pages=[
    const HomeTab(),
    const NetworkTab(),
    const MessageTab(),
    const ProfileTab()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).orientation==Orientation.landscape?100.h:60.h,
        decoration: BoxDecoration(
          color: Colors.grey,
          //borderRadius: BorderRadius.circular(30)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _makeTabItem(Icons.home_outlined, "Home", 0),
            _makeTabItem(Icons.search_rounded, "Network", 1),
            _makeTabItem(Icons.message_outlined, "Message", 2),
            _makeTabItem(Icons.person_outlined, "Profile", 3),
          ],
        ),
      ),
    );
  }
  Widget _makeTabItem(IconData icon ,String label ,int index){
   bool isActive=_currentIndex==index;
    return InkWell(
      onTap: (){
        setState(() {
          _currentIndex=index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive?const Color.fromARGB(255, 14, 9, 159):Colors.white,
            size: 27.sp,
          ),
          SizedBox(height: 4.h,),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive?const Color.fromARGB(255, 10, 5, 167):Colors.white,
            ),
          )
        ],
      ),
    );
  }
}