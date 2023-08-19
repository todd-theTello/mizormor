part of 'account_verification.dart';

SliverList buildPersonalDetailsView({
  required BuildContext context,
  required ValueNotifier<IdType?> idType,
  required TextEditingController idNumberController,
  required TextEditingController emailController,
  required TextEditingController surnameController,
  required TextEditingController otherNamesController,
  required TextEditingController phoneNumberController,
  required ValueNotifier<bool> phoneNumberNotifier,
  required ValueNotifier<bool> idNumberNotifier,
  required ValueNotifier<bool> emailNotifier,
  required ValueNotifier<bool> surnameNotifier,
  required ValueNotifier<bool> otherNamesNotifier,
  required VoidCallback validateForm,
}) {
  final theme = Theme.of(context);

  return SliverList.list(children: [
    Text(
      'Personal details',
      style: theme.textTheme.titleLarge,
    ).paddingOnly(top: 24),
    Text(
      'We need a few more details to verify your account',
      style: theme.textTheme.bodyLarge,
    ).paddingOnly(bottom: 24),
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
        FilteringTextInputFormatter.allow(
          RegExp(InputValidationClass.emailInputPattern),
        ),
      ],
      onChanged: (String value) {
        validateForm();
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
        validateForm();
        if (InputValidationClass.isPhoneNumberValid(phoneNumber: phoneNumberController.text)) {
          phoneNumberNotifier.value = InputValidationClass.isPhoneNumberValid(phoneNumber: phoneNumberController.text);
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
    ).paddingOnly(bottom: 16),
    Text(
      'ID Type',
      style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.tertiary),
    ).paddingOnly(bottom: 8),
    ValueListenableBuilder(
        valueListenable: idType,
        builder: (context, id, _) {
          return Row(
            children: [
              Radio.adaptive(
                toggleable: true,
                value: IdType.passport,
                groupValue: id,
                onChanged: (newID) {
                  idType.value = newID;
                  validateForm();
                },
              ).paddingOnly(right: 16),
              Text('Passport', style: theme.textTheme.bodyLarge).paddingOnly(right: 48),
              Radio.adaptive(
                toggleable: true,
                value: IdType.nationalID,
                groupValue: id,
                onChanged: (newID) {
                  idType.value = newID;
                  validateForm();
                },
              ).paddingOnly(right: 8),
              Text('National ID', style: theme.textTheme.bodyLarge),
            ],
          );
        }).paddingOnly(bottom: 16),
    AuthenticationTextField(
      labelText: 'ID number',
      controller: idNumberController,
      validator: idNumberNotifier,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      hintText: 'Enter your ID number here',
      onChanged: (String value) {
        validateForm();
      },
      errorText: 'Enter a valid ID card number',
      theme: theme,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
      ],
    ).paddingOnly(bottom: 16),
  ]);
}
