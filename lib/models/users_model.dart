
class UsersInfoModel {
  final String status;
  final String message;
  final List<UsersData> data;

  UsersInfoModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UsersInfoModel.fromJson(Map<String, dynamic> json) {
    return UsersInfoModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>)
          .map((e) => UsersData.fromJson(e))
          .toList(),
    );
  }
}


class UsersData {
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
  final List<CheckinModel> checkins;

  UsersData({
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
    required this.checkins,
  });

  factory UsersData.fromJson(Map<String, dynamic> json) {
    return UsersData(
      id: json['id'],
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
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      checkins: json['checkins'] != null
          ? (json['checkins'] as List)
          .map((e) => CheckinModel.fromJson(e))
          .toList()
          : [],
    );
  }

}


class CheckinModel {
  final int id;
  final int userId;
  final String checkinType;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  CheckinModel({
    required this.id,
    required this.userId,
    required this.checkinType,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CheckinModel.fromJson(Map<String, dynamic> json) {
    return CheckinModel(
      id: json['id'],
      userId: json['userId'],
      checkinType: json['checkinType'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),

    );
  }
}
