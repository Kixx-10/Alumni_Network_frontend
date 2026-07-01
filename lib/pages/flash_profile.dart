import 'dart:io';
import 'package:alumni_network/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:alumni_network/data/provider/create_profile_notifier.dart';
import 'package:alumni_network/pages/home_page.dart';

class FlashProfile extends ConsumerStatefulWidget {
  final String registeredName;
  final String userRole;

  const FlashProfile({
    super.key,
    required this.registeredName,
    required this.userRole,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FlashProfileState();
}

class _FlashProfileState extends ConsumerState<FlashProfile> {
  late TextEditingController nameController;
  final TextEditingController universityController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController jobController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.registeredName);
  }

  @override
  void dispose() {
    nameController.dispose();
    universityController.dispose();
    classController.dispose();
    yearController.dispose();
    departmentController.dispose();
    companyController.dispose();
    jobController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image == null) return;
      setState(() {
        _pickedImage = File(image.path);
      });
    } catch (e) {
      debugPrint('Image pick error: $e');
    }
  }

  void _submitProfile() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name cannot be empty')),
      );
      return;
    }
    final int? parsedYear = int.tryParse(yearController.text.trim());

    final success = await ref.read(createProfileProvider.notifier).submitProfile(
      fullName: nameController.text.trim(),
      section: classController.text.trim().isEmpty
          ? null
          : classController.text.trim(),
      university: universityController.text.trim().isEmpty
          ? null
          : universityController.text.trim(),
      graduationYear: parsedYear,
      department: departmentController.text.trim().isEmpty
          ? null
          : departmentController.text.trim(),
      company:
          companyController.text.trim().isEmpty ? null : companyController.text.trim(),
      jobTitle: jobController.text.trim().isEmpty ? null : jobController.text.trim(),
      pickedImage: _pickedImage,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile submitted successfully!')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isStudent = widget.userRole == 'Student';
    final profileState = ref.watch(createProfileProvider);
    final isLoading = profileState.isLoading;

    ref.listen<AsyncValue<void>>(createProfileProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  Center(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(80.r),
                      onTap: isLoading ? null : _pickProfileImage,
                      child: CircleAvatar(
                        radius: 65.r,
                        backgroundColor: Colors.grey[700],
                        backgroundImage: _pickedImage != null
                            ? FileImage(_pickedImage!)
                            : const AssetImage('assets/images/profile.jpg')
                                as ImageProvider,
                      ),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  Text(
                    'Setup your ${widget.userRole} Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    icon: Icons.person,
                    label: 'Name',
                    controller: nameController,
                    readOnly: true,
                  ),
                  SizedBox(height: 15.h),
                  if (isStudent) ...[
                    CustomTextField(
                        icon: Icons.school,
                        label: 'University',
                        controller: universityController),
                    SizedBox(height: 15.h),
                    CustomTextField(
                        icon: Icons.class_outlined,
                        label: 'Class',
                        controller: classController),
                    SizedBox(height: 15.h),
                  ] else ...[
                    CustomTextField(
                      icon: Icons.date_range,
                      label: 'Graduation Year',
                      controller: yearController,

                     // keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 15.h),
                    CustomTextField(
                        icon: Icons.house_outlined,
                        label: 'Company',
                        controller: companyController),
                    SizedBox(height: 15.h),
                    CustomTextField(
                    icon: Icons.local_fire_department,
                    label: 'Department',
                    controller: departmentController,
                  ),
                  SizedBox(height: 15.h),
                    CustomTextField(
                        icon: Icons.work,
                        label: 'Job Title',
                        controller: jobController),
                    SizedBox(height: 15.h),
                  ],
                  SizedBox(height: 30.h),
                  isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : ElevatedButton.icon(
                          onPressed: _submitProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            minimumSize: Size(double.infinity, 50.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 5,
                          ),
                          icon: const Icon(Icons.check_circle,
                              color: Colors.white),
                          label: Text(
                            'Submit Profile',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
