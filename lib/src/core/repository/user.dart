part of 'repositories.dart';

class UserRepository {
  Future<BaseResponse<MizormorUserInfo>> fetchUserInfo() async {
    try {
      final firebaseUser = await FirebaseFirestore.instance
          .collection('users')
          .where(
            'user_id',
            isEqualTo: LocalPreference.userID,
          )
          .get();

      final user = MizormorUserInfo.fromJson(firebaseUser.docs.first.data());
      return BaseResponse.success(user);
    } on FirebaseException catch (err) {
      return BaseResponse.error(message: err.message);
    } catch (err) {
      return BaseResponse.error(message: err.toString());
    }
  }

  Future<BaseResponse<MizormorUserInfo>> updateUser({
    required MizormorUserInfo user,
    XFile? profileImage,
    XFile? idCardImage,
  }) async {
    try {
      FirebaseFirestore.instance.collection('users').doc(LocalPreference.userID).update(
            user.toJson(),
          );
      if (profileImage != null) {
        await uploadImage(file: profileImage, reference: 'profile_image_url');
      }
      if (idCardImage != null) {
        await uploadImage(file: idCardImage, reference: 'id_image');
      }
      final firebaseUser = await FirebaseFirestore.instance
          .collection('users')
          .where('user_id', isEqualTo: LocalPreference.userID)
          .get();
      final updatedUser = MizormorUserInfo.fromJson(firebaseUser.docs.first.data());
      return BaseResponse.success(updatedUser);
    } on FirebaseException catch (err) {
      return BaseResponse.error(message: err.message);
    } catch (err) {
      return BaseResponse.error(message: err.toString());
    }
  }

  Future<void> uploadImage({required XFile file, required String reference}) async {
    final fileUpload = await FirebaseStorage.instance
        .ref()
        .child('users')
        .child('/$reference/${LocalPreference.userID}.${file.path.split('.').last}')
        .putFile(File(file.path));
    if (fileUpload.state == TaskState.success) {
      final imageDownloadUrl = await fileUpload.ref.getDownloadURL();
      FirebaseFirestore.instance.collection('users').doc(LocalPreference.userID).update(
        {reference: imageDownloadUrl},
      );
    }
  }
}
