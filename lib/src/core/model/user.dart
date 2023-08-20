/// User Info entity
class MizormorUserInfo {
  MizormorUserInfo({
    required this.userId,
    required this.surname,
    required this.otherNames,
    required this.email,
    required this.phoneNumber,
    this.profileImageUrl,
    this.idType,
    this.idImageUrl,
    this.idNumber,
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
        idNumber: json['id_card_number'] as String?,
        idImageUrl: json['id_card_image_url'] as String?,
      );
  MizormorUserInfo copyWith({
    String? userId,
    String? surname,
    String? otherNames,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
    String? idType,
    String? idImageUrl,
    String? idNumber,
    bool? verified,
  }) {
    return MizormorUserInfo(
      userId: userId ?? this.userId,
      surname: surname ?? this.surname,
      otherNames: otherNames ?? this.otherNames,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      idType: idType ?? this.idType,
      idImageUrl: idImageUrl ?? this.idImageUrl,
      idNumber: idNumber ?? this.idNumber,
      verified: verified ?? this.verified,
    );
  }

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
  final String? idImageUrl;

  /// user id card image url
  final String? idNumber;

  /// user id card image url
  final String? idType;

  Map<String, dynamic> toJson() => {
        'other_names': otherNames,
        'surname': surname,
        'email': email,
        'phone_number': phoneNumber,
        'verified': verified,
        'profile_image_url': profileImageUrl,
        'id_number': idNumber,
        'id_type': idType,
        'id_image': idImageUrl,
      };
}
