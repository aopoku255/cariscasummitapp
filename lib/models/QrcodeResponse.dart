class QrCheckinResponseModel {
  final String status;
  final String message;

  QrCheckinResponseModel({
    required this.status,
    required this.message,
  });

  factory QrCheckinResponseModel.fromJson(Map<String, dynamic> json) {
    return QrCheckinResponseModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
