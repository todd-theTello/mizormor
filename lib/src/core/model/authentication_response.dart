/// Authentication response entity
class AuthenticationResponse {
  /// creates an instance of authentication response
  AuthenticationResponse({required this.accessToken, required this.refreshToken});

  /// converts authentication response form json to an authentication response instance
  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) => AuthenticationResponse(
        accessToken: json['access_token'] as String?,
        refreshToken: json['refresh_token'] as String?,
      );

  /// Access token
  final String? refreshToken;

  /// User data
  final String? accessToken;
}
