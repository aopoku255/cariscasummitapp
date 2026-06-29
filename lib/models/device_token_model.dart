class DeviceTokenResponse {
  bool success;
  String message;
  DeviceTokenData data;

  DeviceTokenResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DeviceTokenResponse.fromJson(Map<String, dynamic> json) {
    return DeviceTokenResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: DeviceTokenData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class DeviceTokenData {
  int id;
  int userId;
  String deviceToken;
  String deviceName;
  String platform;
  bool isActive;
  String updatedAt;
  String createdAt;

  DeviceTokenData({
    required this.id,
    required this.userId,
    required this.deviceToken,
    required this.deviceName,
    required this.platform,
    required this.isActive,
    required this.updatedAt,
    required this.createdAt,
  });

  factory DeviceTokenData.fromJson(Map<String, dynamic> json) {
    return DeviceTokenData(
      id: json['id'] as int,
      userId: json['userId'] as int,
      deviceToken: json['deviceToken'] as String,
      deviceName: json['deviceName'] as String,
      platform: json['platform'] as String,
      isActive: json['isActive'] as bool,
      updatedAt: json['updatedAt'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'deviceToken': deviceToken,
      'deviceName': deviceName,
      'platform': platform,
      'isActive': isActive,
      'updatedAt': updatedAt,
      'createdAt': createdAt,
    };
  }
}
