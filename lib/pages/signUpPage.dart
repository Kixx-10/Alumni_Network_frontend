import 'package:alumni_network/pages/flash_profile.dart';
import 'package:alumni_network/pages/home_page.dart';
import 'package:alumni_network/widgets/custom_text_field.dart';
import 'package:alumni_network/widgets/custom_elevated_button.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alumni_network/data/model/registration/signup_model.dart';
import 'package:alumni_network/data/provider/signup_notifier.dart';
import 'package:alumni_network/data/provider/auth_provider.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  String? _selectedRole = "Alumni";
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyLoggedIn();
  }
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _checkIfAlreadyLoggedIn() async {
    final bool isLoggedIn = await ref.read(authCheckProvider.future);
    if (isLoggedIn && context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    }
  }

  void _btnRegister() {
    if (nameController.text.trim().isEmpty || emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }
    
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password and confirmPassword do not match")),
      );
      return;
    }
    final signUpData = SignUpModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      role: _selectedRole == "Alumni" ? 1 : 0,
    );
    // မူလအတိုင်း signupProvider ကို သုံး၍ လှမ်းခေါ်ထားပါသည်
    ref.read(signupProvider.notifier).signUp(signUpData);
  }

  @override
  Widget build(BuildContext context) {
    // 🟢 Token နှင့် Provider ကို စနစ်တကျ စောင့်ကြည့်၍ စာမျက်နှာ ကူးပြောင်းပေးမည့် Modern Safe Way
    ref.listen<AsyncValue<void>>(signupProvider, (previous, next) {
      next.whenOrNull(
        data: (_) async {
          // 🔑 စာမျက်နှာ မကူးခင် နောက်ကွယ်မှာ Token အောင်မြင်စွာ သိမ်းဆည်းပြီးသွားပြီဖြစ်ကြောင်း အရင်စစ်ဆေးသည်
          final token = await ref.read(tokenStorageProvider).getToken();
          
          if (token != null && token.isNotEmpty && context.mounted) {
            Navigator.pushAndRemoveUntil(
              context, 
              MaterialPageRoute(builder: (context) => FlashProfile(
                registeredName: nameController.text.trim(),
                userRole: _selectedRole ?? "Alumni"
              )),
              (route) => false, 
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration successfully")),
            );
          }
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        },
      );
    });

    final signupState = ref.watch(signupProvider);
    final isLoading = signupState.isLoading;

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.black,
            toolbarHeight: 0.1.h,
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/cover.jpg"), // 🟢 မင်းရဲ့ မူလ Background Image ဒီဇိုင်း
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20.h),
                        _makeTitle(),
                        SizedBox(height: 20.h),
                        
                        CustomTextField(icon: Icons.person, label: "Full Name", controller: nameController),
                        SizedBox(height: 20.h),
                        CustomTextField(icon: Icons.email, label: "Email", controller: emailController),
                        SizedBox(height: 20.h),
                        CustomTextField(icon: Icons.lock, label: "Password", controller: passwordController, isPassword: true), // 🟢 မူလအတိုင်း isPassword
                        SizedBox(height: 20.h),
                        CustomTextField(icon: Icons.confirmation_num, label: "Confirm Password", controller: confirmPasswordController, isPassword: true), // 🟢 မူလအတိုင်း isPassword
                        SizedBox(height: 20.h),
                        // Radio Buttons
                        SizedBox(
                          width: 320.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _makeRadioButton("Alumni", "Alumni"),
                              SizedBox(width: 20.w),
                              _makeRadioButton("Student", "Student"),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.h),
                        isLoading 
                            ? const CircularProgressIndicator(color: Colors.white)
                            : CustomElevatedButton(
                                text: "Register",
                                onPressed: _btnRegister,
                              ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _makeTitle() {
    return Text(
      "Sign Up an account",
      style: TextStyle(color: Colors.white, fontSize: 25.sp, fontWeight: FontWeight.bold),
    );
  }

  Widget _makeRadioButton(String title, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          // ignore: deprecated_member_use
          groupValue: _selectedRole,
          activeColor: Colors.blueAccent,
          // ignore: deprecated_member_use
          onChanged: (String? newValue) {
            setState(() {
              _selectedRole = newValue;
            });
          },
        ),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }
}