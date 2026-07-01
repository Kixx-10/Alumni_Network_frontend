class CreateProfileModel {
  final String fullName;
  final String avatarUrl;
  final String? section;
  final String? university;
  final int? graduationYear;
  final String? company;
  final String? department;
  final String? jobTitle;

  CreateProfileModel({
    required this.fullName,
    required this.avatarUrl,
    this.section,
    this.university,
    this.graduationYear,
    this.company,
    this.department,
    this.jobTitle,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'avatarUrl': avatarUrl,
      // ✅ Backend DTO field name နှင့် တိုက်ဆိုင်အောင် 'class' ဟု သတ်မှတ်
      'class': section,
      'university': university,
      // ✅ int? သို့မဟုတ် null — String မဖြစ်အောင် type ကို ကာကွယ်ထားသည်
      'graduationYear': graduationYear,
      'company': company,
      'department': department,
      'jobTitle': jobTitle,
    };
  }
}
