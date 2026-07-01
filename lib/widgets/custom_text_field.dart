import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final bool readOnly;
  const CustomTextField({
    super.key,
    required this.icon,
    required this.label,
    required this.controller,
    this.isPassword = false, 
    this.readOnly=false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320.w,
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        readOnly: readOnly,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Colors.white, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}