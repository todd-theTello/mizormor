import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mizormor/utils/extensions/alignment.dart';
import 'package:mizormor/utils/extensions/dismiss_keyboard.dart';
import 'package:mizormor/utils/extensions/padding.dart';

import '../../../../utils/mixins/input_validation_mixins.dart';
import 'elements/account_verification.dart';

enum IdType { passport, nationalID }

class AccountVerificationView extends ConsumerStatefulWidget {
  const AccountVerificationView({super.key});

  @override
  ConsumerState createState() => _AccountVerificationViewState();
}

class _AccountVerificationViewState extends ConsumerState<AccountVerificationView> with InputValidationMixin {
  final ValueNotifier<IdType?> idType = ValueNotifier(null);
  final TextEditingController idNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController otherNamesController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final ValueNotifier<bool> phoneNumberNotifier = ValueNotifier(true);
  final ValueNotifier<bool> idNumberNotifier = ValueNotifier(true);
  final ValueNotifier<bool> emailNotifier = ValueNotifier(true);
  final ValueNotifier<bool> surnameNotifier = ValueNotifier(true);
  final ValueNotifier<bool> otherNamesNotifier = ValueNotifier(true);
  final ValueNotifier<XFile?> idImage = ValueNotifier(null);
  final ValueNotifier<XFile?> selfieImage = ValueNotifier(null);

  final ValueNotifier<int> currentIndex = ValueNotifier(1);
  bool obscureText = true;
  ValueNotifier<({bool personalDetails, bool documentsUpload})> formNotifier = ValueNotifier(
    (personalDetails: false, documentsUpload: false),
  );
  void validateForm() {
    if (isEmailValid(email: emailController.text.trim()) &&
        (surnameController.text.trim().length > 1) &&
        (otherNamesController.text.trim().length > 1) &&
        phoneNumberController.text.length == 9 &&
        idType.value != null) {
      formNotifier.value = (personalDetails: true, documentsUpload: formNotifier.value.documentsUpload);
    } else {
      formNotifier.value = (personalDetails: false, documentsUpload: formNotifier.value.documentsUpload);
    }
    if (idImage.value != null && selfieImage.value != null) {
      formNotifier.value = (personalDetails: formNotifier.value.personalDetails, documentsUpload: true);
    } else {
      formNotifier.value = (personalDetails: formNotifier.value.personalDetails, documentsUpload: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: currentIndex,
          builder: (context, page, _) {
            return Column(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      title: const Text('Account verification'),
                      bottom: PreferredSize(
                        preferredSize: const Size(double.infinity, 24),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: LinearProgressIndicator(value: page / 3),
                        ).paddingSymmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                    if (page == 1)
                      buildPersonalDetailsView(
                        context: context,
                        idType: idType,
                        idNumberController: idNumberController,
                        emailController: emailController,
                        surnameController: surnameController,
                        otherNamesController: otherNamesController,
                        phoneNumberController: phoneNumberController,
                        phoneNumberNotifier: phoneNumberNotifier,
                        idNumberNotifier: idNumberNotifier,
                        emailNotifier: emailNotifier,
                        surnameNotifier: surnameNotifier,
                        otherNamesNotifier: otherNamesNotifier,
                        validateForm: validateForm,
                      ).sliverPaddingSymmetric(horizontal: 20)
                    else if (page == 2)
                      buildDocumentUploadView(
                        context: context,
                        selfieImage: selfieImage,
                        idImage: idImage,
                        validateForm: validateForm,
                      ).sliverPaddingSymmetric(horizontal: 20)
                    else
                      buildSummaryView(
                        context: context,
                        selfieImage: selfieImage,
                        idImage: idImage,
                      ).sliverPaddingSymmetric(horizontal: 20)
                  ],
                ).expanded(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: ValueListenableBuilder(
                      valueListenable: formNotifier,
                      builder: (context, button, _) {
                        return Row(
                          children: [
                            Visibility(
                              visible: page != 1,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                ),
                                onPressed: () {
                                  currentIndex.value--;
                                },
                                child: const Icon(Icons.arrow_back),
                              ).paddingOnly(right: 16),
                            ),
                            Visibility(
                              visible: page != 3,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor:
                                      (button.personalDetails && page == 1) || (button.documentsUpload && page == 2)
                                          ? null
                                          : theme.primaryColor.withOpacity(0.25),
                                ),
                                onPressed:
                                    (button.personalDetails && page == 1) || (button.documentsUpload && page == 2)
                                        ? () {
                                            currentIndex.value++;
                                          }
                                        : () {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                backgroundColor: theme.colorScheme.error,
                                                content: const Text('Please fill all fields'),
                                                behavior: SnackBarBehavior.floating,
                                              ),
                                            );
                                          },
                                child: const Text('Next'),
                              ).expanded(),
                            ),
                            Visibility(
                              visible: page == 3,
                              child: FilledButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      content: Text('Thank you for verifying your details'),
                                    ),
                                  );
                                },
                                child: const Text('Confirm'),
                              ).expanded(),
                            ),
                          ],
                        ).paddingOnly(bottom: 24);
                      }),
                )
              ],
            );
          }),
    ).dismissFocus();
  }
}
