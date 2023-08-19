import 'dart:async';

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
import '../../../core/states/auth_switcher/provider.dart';
import '../../../core/states/authentication/state_notifier.dart';
import '../../widgets/authentication_textfield/authentication_textfield.dart';
import '../../widgets/rich_text_widget/rich_text.dart';

/// Sign in view
class SignInView extends ConsumerStatefulWidget {
  /// sign in view constructor
  const SignInView({super.key});

  @override
  ConsumerState createState() => _SignInViewState();
}

class _SignInViewState extends ConsumerState<SignInView> with InputValidationMixin {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> emailNotifier = ValueNotifier(true);
  ValueNotifier<bool> formNotifier = ValueNotifier(false);
  bool obscurePassword = true;
  void validateForm() {
    isEmailValid(email: emailController.text) && validPassword(passwordController.text)
        ? formNotifier.value = true
        : formNotifier.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ref.listen(authenticationProvider, (previous, state) {
      if (state is AuthenticationLoading) {
        AuthenticationLoadingScreen.instance().show(context: context, text: 'Signing in ...');
      } else {
        AuthenticationLoadingScreen.instance().hide();
      }
      if (state is AuthenticationFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error ?? 'Failed to login '),
            behavior: SnackBarBehavior.floating,
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });
    return Scaffold(
        body: CustomScrollView(slivers: [
      SliverAppBar(
        centerTitle: true,
        title: Text(
          'MiZormor',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.primaryColor,
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        sliver: SliverFillRemaining(
          fillOverscroll: true,
          hasScrollBody: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome back',
                style: theme.textTheme.titleMedium,
              ).paddingOnly(top: 42),
              Text(
                'First, let’s make sure you’re you',
                style: theme.textTheme.bodyLarge,
              ).paddingOnly(bottom: 24),
              AuthenticationTextField(
                labelText: 'Email',
                controller: emailController,
                validator: emailNotifier,
                hintText: 'Eg. doejohn@mail.com',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(emailInputPattern)),
                ],
                onChanged: (String value) {
                  validateForm();
                  if (isEmailValid(email: emailController.text)) {
                    emailNotifier.value = isEmailValid(email: emailController.text);
                  } else {
                    Future.delayed(const Duration(seconds: 3), () {
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
                labelText: 'Password',
                controller: passwordController,
                validator: passwordNotifier,
                obscureText: obscurePassword,
                hintText: 'Eg. ********',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                  icon: Icon(obscurePassword ? Iconsax.eye_slash : Iconsax.eye),
                ),
                onChanged: (String value) {
                  validateForm();

                  if (validPassword(passwordController.text)) {
                    passwordNotifier.value = validPassword(passwordController.text);
                  } else {
                    Future.delayed(const Duration(seconds: 3), () {
                      passwordNotifier.value = validPassword(passwordController.text);
                    });
                  }
                },
                textInputAction: TextInputAction.done,
                errorText: 'Enter a valid password',
                theme: theme,
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Icon(Iconsax.lock),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Forgot password?'),
              ).centerRightAlign(),
              ValueListenableBuilder(
                  valueListenable: formNotifier,
                  builder: (context, formIsValid, _) {
                    return FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: formIsValid ? null : theme.primaryColor.withOpacity(0.25)),
                      onPressed: formIsValid
                          ? () async {
                              await ref.read(authenticationProvider.notifier).emailSignIn(
                                    email: emailController.text,
                                    password: passwordController.text,
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
                      child: const Text('Sign in'),
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
                label: const Text('Login with Google'),
              ).paddingOnly(bottom: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: theme.primaryColor),
                ),
                onPressed: () async {
                  await ref.read(authenticationProvider.notifier).appleSignIn();
                },
                icon: SvgPicture.asset('assets/images/apple-logo.svg', height: 18),
                label: const Text('Sign in with Apple'),
              ).paddingOnly(bottom: 48),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: RichTextWidget(
                  texts: [
                    const BaseText(text: 'New here? '),
                    BaseText.custom(
                      text: 'Register',
                      onTapped: () => ref.watch(authSwitcherProvider.notifier).update(
                            (state) => false,
                          ),
                    ),
                  ],
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    ])).dismissFocus();
  }
}
