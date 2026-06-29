class LoginModel {
  final String status;
  final String message;
  final UserData data;
  final String token;

  LoginModel(
      {required this.status,
      required this.message,
      required this.data,
      required this.token});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: UserData.fromJson(json['data'] ?? {}),
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data.toJson(),
        'token': token,
      };
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
  final String password;
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
    required this.password,
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
      password: json['password'] ?? '',
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'prefix': prefix,
        'attendaceType': attendaceType,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'organization': organization,
        'suffix': suffix,
        'continent': continent,
        'mobile_number': mobileNumber,
        'country': country,
        'city': city,
        'state': state,
        'sector': sector,
        'position': position,
        'gender': gender,
        'password': password,
        'certificate': certificate,
        'previousEvent': previousEvent,
        'emailOptOut': emailOptOut,
        'photoRelease': photoRelease,
        'category': category,
        'paymentLink': paymentLink,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}
