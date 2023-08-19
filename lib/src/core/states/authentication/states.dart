part of 'state_notifier.dart';

/// abstraction of authentication states
abstract class AuthenticationStates extends Equatable {}

/// initial state of authentication
class AuthenticationInitial extends AuthenticationStates {
  @override
  List<Object?> get props => [];
}

/// loading state of authentication
class AuthenticationLoading extends AuthenticationStates {
  @override
  List<Object?> get props => [];
}

/// success state of authentication
class AuthenticationSuccess extends AuthenticationStates {
  ///
  // AuthenticationSuccess({required this.user});
  // final ZormorUser user ;
  @override
  List<Object?> get props => [];
}

/// failure state of authentication
class AuthenticationFailure extends AuthenticationStates {
  ///
  AuthenticationFailure({required this.error});

  ///
  final String? error;
  @override
  List<Object?> get props => [error];
}

///
class AuthenticationForgotPasswordFailure extends AuthenticationStates {
  AuthenticationForgotPasswordFailure({this.error});
  final String? error;
  @override
  List<Object?> get props => [error];
}

///
class AuthenticationLogoutSuccess extends AuthenticationStates {
  @override
  List<Object?> get props => [];
}

///
class AuthenticationForgotPasswordSuccess extends AuthenticationStates {
  @override
  List<Object?> get props => [];
}
