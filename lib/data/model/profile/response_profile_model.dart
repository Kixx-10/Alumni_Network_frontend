class ResponseProfileModel {
  final String profileId;
  final String userId;
  final String fullName;
  final String? avatarUrl;
  final String? profileClass; 
  final int? graduationYear;
  final String? department;
  final String? university;
  final String? company;
  final String? jobTitle;
  final DateTime createdDate;
  final DateTime? updatedDate;

  const ResponseProfileModel({
    required this.profileId,
    required this.userId,
    required this.fullName,
    this.avatarUrl,
    this.profileClass,
    this.graduationYear,
    this.department,
    this.university,
    this.company,
    this.jobTitle,
    required this.createdDate,
    this.updatedDate,
  });

  // ── JSON → Model
  factory ResponseProfileModel.fromJson(Map<String, dynamic> json) {
    return ResponseProfileModel(
      profileId:      json['profileId']     as String? ?? '',
      userId:         json['userId']        as String? ?? '',
      fullName:       json['fullName']      as String? ?? '',
      avatarUrl:      json['avatarUrl']     as String?,
      profileClass:   json['class']         as String?, 
      graduationYear: json['graduationYear'] as int?,
      department:     json['department']    as String?,
      university:     json['university']    as String?,
      company:        json['company']       as String?,
      jobTitle:       json['jobTitle']      as String?,
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'] as String)
          : DateTime.now(),
      updatedDate: json['updatedDate'] != null
          ? DateTime.parse(json['updatedDate'] as String)
          : null,
    );
  }

  // ── Model → JSON ────────────────────────────────────────────
  Map<String, dynamic> toJson() {
    return {
      'profileId':      profileId,
      'userId':         userId,
      'fullName':       fullName,
      'avatarUrl':      avatarUrl,
      'class':          profileClass,
      'graduationYear': graduationYear,
      'department':     department,
      'university':     university,
      'company':        company,
      'jobTitle':       jobTitle,
      'createdDate':    createdDate.toIso8601String(),
      'updatedDate':    updatedDate?.toIso8601String(),
    };
  }

  // Riverpod state update 
  ResponseProfileModel copyWith({
    String? profileId,
    String? userId,
    String? fullName,
    String? avatarUrl,
    String? profileClass,
    int? graduationYear,
    String? department,
    String? university,
    String? company,
    String? jobTitle,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return ResponseProfileModel(
      profileId:      profileId      ?? this.profileId,
      userId:         userId         ?? this.userId,
      fullName:       fullName       ?? this.fullName,
      avatarUrl:      avatarUrl      ?? this.avatarUrl,
      profileClass:   profileClass   ?? this.profileClass,
      graduationYear: graduationYear ?? this.graduationYear,
      department:     department     ?? this.department,
      university:     university     ?? this.university,
      company:        company        ?? this.company,
      jobTitle:       jobTitle       ?? this.jobTitle,
      createdDate:    createdDate    ?? this.createdDate,
      updatedDate:    updatedDate    ?? this.updatedDate,
    );
  }
}
