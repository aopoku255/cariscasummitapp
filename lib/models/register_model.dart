class RegisterModel {
  final String status;
  final String message;
  final String email;
  final String? generated; // Make nullable

  RegisterModel({
    required this.status,
    required this.message,
    required this.email,
    this.generated,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      email: json['email'] ?? '',
      generated: json['generated'], // Nullable, no ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'email': email,
      'generated': generated,
    };
  }
}
