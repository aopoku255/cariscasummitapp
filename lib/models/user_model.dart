class UserInfoModel {
  final String status;
  final String message;
  final UserData data;

  UserInfoModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: UserData.fromJson(json['data']),
    );
  }
}

class UserData {
  final int id;
  final String prefix;
  final String attendaceType;
  final String firstName;
  final String lastName;
  final String email;
  final String organization;
  final String suffix;
  final String continent;
  final String mobileNumber;
  final String country;
  final String city;
  final String state;
  final String sector;
  final String position;
  final String gender;
  final String certificate;
  final String previousEvent;
  final String emailOptOut;
  final String photoRelease;
  final String category;
  final String paymentLink;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserData({
    required this.id,
    required this.prefix,
    required this.attendaceType,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.organization,
    required this.suffix,
    required this.continent,
    required this.mobileNumber,
    required this.country,
    required this.city,
    required this.state,
    required this.sector,
    required this.position,
    required this.gender,
    required this.certificate,
    required this.previousEvent,
    required this.emailOptOut,
    required this.photoRelease,
    required this.category,
    required this.paymentLink,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      prefix: json['prefix'] ?? '',
      attendaceType: json['attendaceType'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      organization: json['organization'] ?? '',
      suffix: json['suffix'] ?? '',
      continent: json['continent'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      sector: json['sector'] ?? '',
      position: json['position'] ?? '',
      gender: json['gender'] ?? '',
      certificate: json['certificate'] ?? '',
      previousEvent: json['previousEvent'] ?? '',
      emailOptOut: json['emailOptOut'] ?? '',
      photoRelease: json['photoRelease'] ?? '',
      category: json['category'] ?? '',
      paymentLink: json['paymentLink'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }
}
