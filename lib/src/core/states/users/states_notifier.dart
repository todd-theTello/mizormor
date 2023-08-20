import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/user.dart';
import '../../repository/repositories.dart';

part 'provider.dart';
part 'states.dart';

/// user states notifier
class UserStateNotifier extends StateNotifier<UserStates> {
  /// initial user state
  UserStateNotifier() : super(UserInitial());
  final _userRepository = UserRepository();

  /// fetch user info from the backend
  Future<void> getUserInfo() async {
    state = UserLoading();
    try {
      final userResponse = await _userRepository.fetchUserInfo();
      if (userResponse.status) {
        state = UserSuccess(user: userResponse.data!);
      } else {
        state = UserFailure(error: userResponse.message);
      }
    } catch (error) {
      state = UserFailure(error: error.toString());
    }
  }

  Future<void> updateUser({required MizormorUserInfo user, XFile? profileImage, XFile? idCardImage}) async {
    state = UserLoading();
    try {
      final userResponse = await _userRepository.updateUser(
        user: user,
        profileImage: profileImage,
        idCardImage: idCardImage,
      );
      if (userResponse.status) {
        state = UserSuccess(user: userResponse.data!);
      } else {
        state = UserFailure(error: userResponse.message);
      }
    } catch (error) {
      state = UserFailure(error: error.toString());
    }
  }
}
