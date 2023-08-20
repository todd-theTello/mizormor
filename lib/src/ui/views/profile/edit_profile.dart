import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mizormor/utils/extensions/alignment.dart';
import 'package:mizormor/utils/extensions/dismiss_keyboard.dart';
import 'package:mizormor/utils/extensions/padding.dart';

import '../../../../utils/mixins/input_validation_mixins.dart';
import '../../../../utils/overlays/authentication_loading_overlay/loading_screen.dart';
import '../../../../utils/platform/image.dart';
import '../../../core/states/users/states_notifier.dart';
import '../../widgets/authentication_textfield/authentication_textfield.dart';
import '../../widgets/circle_container.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({super.key});

  @override
  ConsumerState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  late final TextEditingController emailController;
  late final TextEditingController surnameController;
  late final TextEditingController otherNamesController;
  late final TextEditingController phoneNumberController;
  final ValueNotifier<bool> phoneNumberNotifier = ValueNotifier(true);
  final ValueNotifier<bool> emailNotifier = ValueNotifier(true);
  final ValueNotifier<bool> surnameNotifier = ValueNotifier(true);
  final ValueNotifier<bool> otherNamesNotifier = ValueNotifier(true);

  final ValueNotifier<XFile?> profileImage = ValueNotifier(null);
  @override
  void initState() {
    super.initState();
    otherNamesController = TextEditingController();
    surnameController = TextEditingController();
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    otherNamesController.dispose();
    surnameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(userStateProvider);
    if (user is UserSuccess) {
      otherNamesController.text = user.user.otherNames ?? '';
      surnameController.text = user.user.surname ?? '';
      emailController.text = user.user.email ?? '';
      phoneNumberController.text = user.user.phoneNumber?.replaceAll('+233', '') ?? '';
    }
    ref.listen(userStateProvider, (previous, state) {
      if (state is UserLoading) {
        AuthenticationLoadingScreen.instance().show(context: context, text: 'Updating user details...');
      } else if (state is UserSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User details updated successfully'),
          ),
        );
        AuthenticationLoadingScreen.instance().hide();

        Navigator.of(context).pop();
      } else if (state is UserFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: theme.colorScheme.error,
            content: Text(state.error ?? "Couldn't update user details"),
          ),
        );
        AuthenticationLoadingScreen.instance().hide();
      }
    });
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(title: Text('Edit profile')),
          if (user is UserSuccess)
            SliverList.list(children: [
              ValueListenableBuilder(
                  valueListenable: profileImage,
                  builder: (context, image, _) {
                    return GestureDetector(
                      onTap: () async {
                        await showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white.withOpacity(0),
                          builder: (_) => CupertinoActionSheet(
                            actions: [
                              CupertinoActionSheetAction(
                                isDefaultAction: true,
                                onPressed: () async {
                                  profileImage.value = await ImagePickerUtil.openGallery().then((value) async {
                                    if (value != null) {
                                      final croppedImage = await ImagePickerUtil.cropImage(imagePath: value.path);
                                      if (croppedImage != null) {
                                        return XFile(croppedImage.path);
                                      } else {
                                        return value;
                                      }
                                    }
                                    return value;
                                  });
                                },
                                child: const Text('Gallery'),
                              ),
                              CupertinoActionSheetAction(
                                onPressed: () async {
                                  profileImage.value = await ImagePickerUtil.openCamera().then((value) async {
                                    if (value != null) {
                                      final croppedImage = await ImagePickerUtil.cropImage(imagePath: value.path);
                                      if (croppedImage != null) {
                                        return XFile(croppedImage.path);
                                      } else {
                                        return value;
                                      }
                                    }
                                    return value;
                                  });
                                },
                                child: const Text('Camera'),
                              ),
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              isDestructiveAction: true,
                              onPressed: () {},
                              child: const Text('Cancel'),
                            ),
                          ),
                        );
                      },
                      child: image != null
                          ? CircleAvatar(
                              radius: 48,
                              backgroundImage: FileImage(
                                File(image.path),
                              ),
                            )
                          : Stack(
                              children: [
                                if (user.user.profileImageUrl != null)
                                  ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: user.user.profileImageUrl!,
                                    ),
                                  )
                                else
                                  CircleContainer(
                                    color: theme.dividerColor,
                                    padding: const EdgeInsets.all(36),
                                    child: const Icon(Iconsax.camera),
                                  ),
                                Positioned(
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.white,
                                    child: CircleContainer(
                                      color: theme.dividerColor,
                                      padding: const EdgeInsets.all(2),
                                      child: const Icon(Icons.add),
                                    ),
                                  ),
                                )
                              ],
                            ),
                    ).centerAlign().paddingSymmetric(vertical: 40);
                  }).paddingOnly(bottom: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthenticationTextField(
                    labelText: 'Other name(s)',
                    controller: otherNamesController,
                    validator: otherNamesNotifier,
                    hintText: 'Eg. John',
                    keyboardType: TextInputType.streetAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: (String value) {
                      // validateForm();
                      Future.delayed(const Duration(seconds: 3), () {
                        otherNamesNotifier.value = value.length > 1;
                      });
                    },
                    errorText: 'Enter a valid name',
                    theme: theme,
                  ).expanded(),
                  const SizedBox(width: 22),
                  AuthenticationTextField(
                    labelText: 'Surname',
                    controller: surnameController,
                    validator: surnameNotifier,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    hintText: 'Eg. Doe',
                    onChanged: (String value) {
                      // validateForm();

                      Future.delayed(const Duration(seconds: 3), () {
                        surnameNotifier.value = value.length > 1;
                      });
                    },
                    errorText: 'Enter a valid name',
                    theme: theme,
                  ).expanded(),
                ],
              ).paddingOnly(bottom: 16),
              AuthenticationTextField(
                labelText: 'Email',
                controller: emailController,
                validator: emailNotifier,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                hintText: 'Eg. doejohn@mail.com',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(InputValidationClass.emailInputPattern),
                  ),
                ],
                onChanged: (String value) {
                  if (InputValidationClass.isEmailValid(email: emailController.text)) {
                    emailNotifier.value = InputValidationClass.isEmailValid(email: emailController.text);
                  } else {
                    Future.delayed(const Duration(seconds: 5), () {
                      emailNotifier.value = InputValidationClass.isEmailValid(email: emailController.text);
                    });
                  }
                },
                errorText: 'Enter a valid email address',
                theme: theme,
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Icon(Icons.mail_outline_rounded),
                ),
              ).paddingOnly(bottom: 16),
              AuthenticationTextField(
                labelText: 'Phone number',
                controller: phoneNumberController,
                validator: phoneNumberNotifier,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                hintText: 'Eg. 50 333 4444',
                onChanged: (String value) {
                  // validateForm();
                  if (InputValidationClass.isPhoneNumberValid(phoneNumber: phoneNumberController.text)) {
                    phoneNumberNotifier.value =
                        InputValidationClass.isPhoneNumberValid(phoneNumber: phoneNumberController.text);
                  } else {
                    Future.delayed(const Duration(seconds: 4), () {
                      phoneNumberNotifier.value =
                          InputValidationClass.isPhoneNumberValid(phoneNumber: phoneNumberController.text);
                    });
                  }
                },
                errorText: 'Enter a valid phone number',
                theme: theme,
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Text('+233', style: theme.textTheme.bodyLarge),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(9),
                ],
              ).paddingOnly(bottom: 32),
              FilledButton(
                onPressed: () async {
                  await ref.read(userStateProvider.notifier).updateUser(
                        user: user.user.copyWith(
                          otherNames: otherNamesController.text,
                          surname: surnameController.text,
                          email: emailController.text,
                          phoneNumber: '+233${phoneNumberController.text}',
                          userId: user.user.userId,
                        ),
                        profileImage: profileImage.value,
                      );
                },
                child: const Text('Update'),
              ),
            ]).sliverPaddingSymmetric(horizontal: 20),
        ],
      ),
    ).dismissFocus();
  }
}
