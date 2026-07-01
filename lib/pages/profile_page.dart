import 'package:alumni_network/core/network/api_client.dart';
import 'package:alumni_network/data/model/profile/response_profile_model.dart';
import 'package:alumni_network/data/provider/response_profile_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(responseProfileProvider);
    return Scaffold(
      body: profileState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.blueAccent),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.redAccent, size: 48.sp),
              SizedBox(height: 12.h),
              Text(
                error.toString(),
                style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () => ref
                    .read(responseProfileProvider.notifier)
                    .refreshProfile(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (profile) => _ProfileBody(profile: profile),
      ),
    );
  }
}
//  _ProfileBody
class _ProfileBody extends StatelessWidget {
  final ResponseProfileModel profile;
  const _ProfileBody({required this.profile});
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => ProviderScope.containerOf(context)
          .read(responseProfileProvider.notifier)
          .refreshProfile(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            _ProfileHeader(profile: profile),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  if (profile.department != null)
                    _InfoTile(
                      icon: Icons.local_fire_department,
                      label: 'Department',
                      value: profile.department!,
                    ),
                  if (profile.university != null)
                    _InfoTile(
                      icon: Icons.school,
                      label: 'University',
                      value: profile.university!,
                    ),
                  if (profile.profileClass != null)
                    _InfoTile(
                      icon: Icons.class_outlined,
                      label: 'Class',
                      value: profile.profileClass!,
                    ),
                  if (profile.graduationYear != null)
                    _InfoTile(
                      icon: Icons.date_range,
                      label: 'Graduation Year',
                      value: profile.graduationYear.toString(),
                    ),
                  if (profile.company != null)
                    _InfoTile(
                      icon: Icons.house_outlined,
                      label: 'Company',
                      value: profile.company!,
                    ),
                  if (profile.jobTitle != null)
                    _InfoTile(
                      icon: Icons.work,
                      label: 'Job Title',
                      value: profile.jobTitle!,
                    ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//  _ProfileHeader — Avatar image fix 
class _ProfileHeader extends StatelessWidget {
  final ResponseProfileModel profile;

  const _ProfileHeader({required this.profile});

  String _resolveAvatarUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.trim().isEmpty) return '';
    if (rawUrl.startsWith('http')) return rawUrl;
    final String baseUrl = 'http://${ApiClient.ipAddress}';
    return '$baseUrl$rawUrl';
  }
  @override
  Widget build(BuildContext context) {
    final String resolvedUrl = _resolveAvatarUrl(profile.avatarUrl);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: Column(
        children: [
          CircleAvatar(
            radius: 55.r,
            child: ClipOval(
              child: resolvedUrl.isNotEmpty
                  ? Image.network(
                      resolvedUrl,
                      width: 110.r,
                      height: 110.r,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/profile.jpg',
                          width: 110.r,
                          height: 110.r,
                          fit: BoxFit.cover,
                        );
                      },
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(
                           // color: Colors.blueAccent,
                            strokeWidth: 2,
                          ),
                        );
                      },
                    )
                  : Image.asset(
                      'assets/images/profile.jpg',
                      width: 110.r,
                      height: 110.r,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            profile.fullName,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),

        ],
      ),
    );
  }
}
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 20.sp),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11.sp),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}