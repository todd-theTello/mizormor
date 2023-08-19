/// User Info entity
class MizormorUserInfo {
  MizormorUserInfo({
    required this.userId,
    required this.surname,
    required this.otherNames,
    required this.email,
    required this.phoneNumber,
    this.profileImageUrl,
    this.idCardImageUrl,
    this.idCardNumber,
    bool? verified,
  }) : verified = verified ?? false;

  /// converts authentication response form json to an authentication response instance
  factory MizormorUserInfo.fromJson(Map<String, dynamic> json) => MizormorUserInfo(
        userId: json['user_id'] as String?,
        surname: json['surname'] as String?,
        otherNames: json['other_names'] as String?,
        email: json['email'] as String?,
        phoneNumber: json['phone_number'] as String?,
        verified: (json['verified'] as bool?) ?? false,
        profileImageUrl: json['profile_image_url'] as String?,
        idCardNumber: json['id_card_number'] as String?,
        idCardImageUrl: json['id_card_image_url'] as String?,
      );

  /// user id
  final String? userId;

  /// user name
  final String? otherNames;

  /// user name
  final String? surname;

  /// user's email
  final String? email;

  /// user's email
  final String? phoneNumber;

  /// user verification status
  final bool verified;

  /// Users profile image url
  final String? profileImageUrl;

  /// user id card image url
  final String? idCardImageUrl;

  /// user id card image url
  final String? idCardNumber;

  Map<String, dynamic> toJson() => {
        'surname': surname,
        'email': email,
        'phone_number': phoneNumber,
        'verified': verified,
        'profile_image_url': profileImageUrl,
        'id_card_number': idCardNumber,
        'id_card_image': idCardImageUrl,
      };
}
