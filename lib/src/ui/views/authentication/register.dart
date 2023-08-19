import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mizormor/utils/extensions/alignment.dart';
import 'package:mizormor/utils/extensions/padding.dart';

import '../../../../../utils/extensions/dismiss_keyboard.dart';
import '../../../../../utils/mixins/input_validation_mixins.dart';
import '../../../../utils/overlays/authentication_loading_overlay/loading_screen.dart';
import '../../../core/model/login_request_data.dart';
import '../../../core/states/auth_switcher/provider.dart';
import '../../../core/states/authentication/state_notifier.dart';
import '../../widgets/authentication_textfield/authentication_textfield.dart';
import '../../widgets/rich_text_widget/rich_text.dart';

/// Registration view
class RegistrationView extends ConsumerStatefulWidget {
  /// registration view constructor
  const RegistrationView({super.key});

  @override
  ConsumerState createState() => _RegistrationViewState();
}

class _RegistrationViewState extends ConsumerState<RegistrationView> with InputValidationMixin {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController otherNamesController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final ValueNotifier<bool> phoneNumberNotifier = ValueNotifier(true);
  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> emailNotifier = ValueNotifier(true);
  final ValueNotifier<bool> surnameNotifier = ValueNotifier(true);
  final ValueNotifier<bool> otherNamesNotifier = ValueNotifier(true);
  bool obscureText = true;
  ValueNotifier<bool> formNotifier = ValueNotifier(false);
  void validateForm() {
    validPassword(passwordController.text.trim()) &&
            isEmailValid(email: emailController.text.trim()) &&
            (surnameController.text.trim().length > 1) &&
            (otherNamesController.text.trim().length > 1)
        ? formNotifier.value = true
        : formNotifier.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    ref.listen(authenticationProvider, (previous, state) {
      if (state is AuthenticationLoading) {
        AuthenticationLoadingScreen.instance().show(context: context, text: 'Creating account...');
      } else {
        AuthenticationLoadingScreen.instance().hide();
      }
      if (state is AuthenticationFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error ?? 'Failed to register user'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text(
              'MiZormor',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.primaryColor,
              ),
            ),
          ),
          SliverList.list(children: [
            Text(
              'Welcome to MiZormor',
              style: theme.textTheme.titleMedium,
            ).paddingOnly(top: 24),
            Text(
              'Just a few details to get you started',
              style: theme.textTheme.bodyLarge,
            ).paddingOnly(bottom: 32),
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
                    validateForm();
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
                    validateForm();

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
                FilteringTextInputFormatter.allow(RegExp(emailInputPattern)),
              ],
              onChanged: (String value) {
                validateForm();
                if (isEmailValid(email: emailController.text)) {
                  emailNotifier.value = isEmailValid(email: emailController.text);
                } else {
                  Future.delayed(const Duration(seconds: 5), () {
                    emailNotifier.value = isEmailValid(email: emailController.text);
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
                validateForm();
                if (isPhoneNumberValid(phoneNumber: phoneNumberController.text)) {
                  phoneNumberNotifier.value = isPhoneNumberValid(phoneNumber: phoneNumberController.text);
                } else {
                  Future.delayed(const Duration(seconds: 4), () {
                    phoneNumberNotifier.value = isPhoneNumberValid(phoneNumber: phoneNumberController.text);
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
            ).paddingOnly(bottom: 16),
            AuthenticationTextField(
              labelText: 'Password',
              controller: passwordController,
              obscureText: obscureText,
              validator: passwordNotifier,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              hintText: 'Eg. ********',
              onChanged: (String value) {
                validateForm();

                if (validPassword(passwordController.text)) {
                  passwordNotifier.value = validPassword(passwordController.text);
                } else {
                  Future.delayed(const Duration(seconds: 4), () {
                    passwordNotifier.value = validPassword(passwordController.text);
                  });
                }
              },
              errorText: 'Enter a valid password',
              theme: theme,
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Icon(Iconsax.lock),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
                icon: Icon(obscureText ? Iconsax.eye_slash : Iconsax.eye),
              ),
            ).paddingOnly(bottom: 32),
            ValueListenableBuilder(
                valueListenable: formNotifier,
                builder: (context, valid, _) {
                  return FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: valid == true ? null : theme.primaryColor.withOpacity(0.25),
                    ),
                    onPressed: valid == true
                        ? () async {
                            /// Perform registration action
                            await ref.read(authenticationProvider.notifier).emailRegistration(
                                  data: RegistrationRequestData(
                                    email: emailController.text,
                                    phoneNumber: '+233${phoneNumberController.text}',
                                    password: passwordController.text,
                                    surname: surnameController.text,
                                    otherNames: otherNamesController.text,
                                  ),
                                );
                          }
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: theme.colorScheme.error,
                                content: const Text('Please fill all fields'),
                              ),
                            );
                          },
                    child: const Text('REGISTER'),
                  ).paddingOnly(bottom: 24);
                }),
            Row(
              children: [
                const Divider().expanded(),
                const Text('OR').paddingSymmetric(horizontal: 24),
                const Divider().expanded(),
              ],
            ).paddingOnly(bottom: 24),
            OutlinedButton.icon(
              onPressed: () async {
                await ref.read(authenticationProvider.notifier).googleSignIn();
              },
              icon: SvgPicture.asset('assets/images/google-logo.svg', height: 18),
              label: const Text('Signup with Google'),
            ).paddingOnly(bottom: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: theme.primaryColor),
              ),
              onPressed: () async {
                await ref.read(authenticationProvider.notifier).appleSignIn();
              },
              icon: SvgPicture.asset('assets/images/apple-logo.svg', height: 18),
              label: const Text('Sign up with Apple'),
            ).paddingOnly(bottom: 48),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: RichTextWidget(
                texts: [
                  const BaseText(text: 'Already have an account? '),
                  BaseText.custom(
                    text: 'Sign in here',
                    onTapped: () => ref.watch(authSwitcherProvider.notifier).update(
                          (state) => true,
                        ),
                  ),
                ],
                textAlign: TextAlign.center,
              ),
            ),
          ]).sliverPaddingSymmetric(horizontal: 24)
        ],
      ),
    ).dismissFocus();
  }
}
