part of 'repositories.dart';

class AuthenticationRepository {
  Future<BaseResponse<String>> signInWithEmail({required String email, required String password}) async {
    try {
      final auth = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (auth.user != null) {
        return BaseResponse.success(auth.user!.uid);
      } else {
        return BaseResponse.error(message: 'Sign in failed');
      }
    } on FirebaseException catch (err) {
      return BaseResponse.error(message: err.message);
    } catch (err) {
      return BaseResponse.error(message: err.toString());
    }
  }

  Future<BaseResponse<String>> registerWithEmail({required RegistrationRequestData data}) async {
    try {
      final auth = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data.email,
        password: data.password,
      );
      if (auth.user != null) {
        FirebaseFirestore.instance.collection('users').doc(auth.user!.uid).set(
              data.toJson()..addAll({'user_id': auth.user?.uid}),
            );
        return BaseResponse.success(auth.user!.uid);
      } else {
        return BaseResponse.error(message: 'Registration failed');
      }
    } on FirebaseException catch (err) {
      return BaseResponse.error(message: err.message);
    } catch (err) {
      return BaseResponse.error(message: err.toString());
    }
  }

  Future<BaseResponse<String>> googleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );
    final signInAccount = await googleSignIn.signIn();
    if (signInAccount == null) {
      return BaseResponse.error(message: 'Google sign in not completed');
    }
    final googleAuth = await signInAccount.authentication;
    final oauthCredentials = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    try {
      final user = await FirebaseAuth.instance.signInWithCredential(
        oauthCredentials,
      );
      if (user.user != null) {
        final firestoreInstance = FirebaseFirestore.instance.collection('users').where(
              'user_id',
              isEqualTo: user.user!.uid,
            );
        final firebaseUser = await firestoreInstance.get();
        // firebaseUser.docs.first.reference.update(data)

        if (firebaseUser.docs.isEmpty) {
          FirebaseFirestore.instance.collection('users').doc(user.user!.uid).set({
            'user_id': user.user!.uid,
            'email': user.user!.email,
            'surname': user.user?.displayName?.split(' ').last,
            'other_names': user.user?.displayName?.split(' ').first,
            'phone_number': user.user?.phoneNumber,
            'profile_image_url': user.user?.photoURL,
            'verified': false,
          });
        }
        return BaseResponse.success(user.user!.uid);
      } else {
        return BaseResponse.error(message: 'Sign in failed');
      }
    } on FirebaseException catch (err) {
      return BaseResponse.error(message: err.message);
    } catch (err) {
      return BaseResponse.error(message: err.toString());
    }
  }

  Future<BaseResponse<String>> signInWithApple() async {
    final appleAuthProvider = AppleAuthProvider().addScope('email').addScope('fullName');

    try {
      final user = await FirebaseAuth.instance.signInWithProvider(appleAuthProvider);
      if (user.user != null) {
        final firestoreInstance =
            FirebaseFirestore.instance.collection('users').where('user_id', isEqualTo: user.user!.uid);
        final firebaseUser = await firestoreInstance.get();
        // firebaseUser.docs.first.reference.update(data)
        if (firebaseUser.docs.isEmpty) {
          FirebaseFirestore.instance.collection('users').doc(user.user!.uid).set({
            'user_id': user.user!.uid,
            'email': user.user!.email,
            'surname': user.user?.displayName?.split(' ').last,
            'other_names': user.user?.displayName?.split(' ').first,
            'phone_number': user.user?.phoneNumber,
            'profile_image_url': user.user?.photoURL,
            'verified': false,
          });
        }
        return BaseResponse.success(user.user!.uid);
      } else {
        return BaseResponse.error(message: 'Sign in failed');
      }
    } on FirebaseException catch (err) {
      return BaseResponse.error(message: err.message);
    } catch (err) {
      return BaseResponse.error(message: err.toString());
    }
  }

  Future<BaseResponse<String>> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      return BaseResponse.success('User signed out successfully');
    } on FirebaseException catch (err) {
      return BaseResponse.error(message: err.message ?? "Couldn't sign out user");
    } catch (err) {
      return BaseResponse.error(message: "Couldn't sign out user");
    }
  }

  Future<BaseResponse<String>> forgotPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return BaseResponse.success('User signed out successfully');
    } on FirebaseException catch (err) {
      return BaseResponse.error(message: err.message ?? "Couldn't send email");
    } catch (err) {
      return BaseResponse.error(message: "Couldn't send email");
    }
  }
}
