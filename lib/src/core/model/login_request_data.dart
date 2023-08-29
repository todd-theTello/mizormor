/// Login request data
class LoginRequestData {
  /// Login request data constructor
  const LoginRequestData({required this.email, required this.password});

  ///
  final String email;

  ///
  final String password;

  ///
  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

/// Registration request data
class RegistrationRequestData extends LoginRequestData {
  /// Registration request data constructor
  const RegistrationRequestData({
    required super.email,
    required super.password,
    required this.phoneNumber,
    required this.surname,
    required this.otherNames,
  });

  ///
  final String surname;

  ///
  final String phoneNumber;

  ///
  final String otherNames;

  ///

  ///
  @override
  Map<String, dynamic> toJson() => {
        'role': 'USER',
        'email': email,
        'phone_number': phoneNumber,
        'surname': surname,
        'other_names': otherNames,
        'verified': false,
      };
}
