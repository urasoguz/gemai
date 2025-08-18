class User {
  final int? id;
  final String? email;
  final String? name;
  final String? loginMode;
  final String? deviceId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isPremium;
  final DateTime? premiumExpiryDate;
  final int? remainingToken;

  User({
    this.id,
    this.email,
    this.loginMode,
    this.deviceId,
    this.createdAt,
    this.updatedAt,
    this.isPremium,
    this.premiumExpiryDate,
    this.remainingToken,
    this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],
    name: json["name"],
    loginMode: json["login_mode"],
    deviceId: json["device_id"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    isPremium: json["is_premium"] == 1 || json["is_premium"] == true,
    premiumExpiryDate:
        json["premium_expiry_date"] == null
            ? null
            : DateTime.parse(json["premium_expiry_date"]),
    remainingToken: json["remaining_token"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "name": name,
    "login_mode": loginMode,
    "device_id": deviceId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "is_premium": isPremium,
    "premium_expiry_date": premiumExpiryDate?.toIso8601String(),
    "remaining_token": remainingToken,
  };
}
