part of 'account_verification.dart';

SliverList buildSummaryView({
  required BuildContext context,
  required ValueNotifier<XFile?> selfieImage,
  required ValueNotifier<XFile?> idImage,
}) {
  final theme = Theme.of(context);
  return SliverList.list(children: [
    Text(
      'Summary',
      style: theme.textTheme.titleLarge,
    ).paddingOnly(top: 24),
    Text(
      'Kindly crosscheck and verify the details below',
      style: theme.textTheme.bodyLarge,
    ).paddingOnly(bottom: 16),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.dividerColor,
            blurRadius: 48,
            offset: const Offset(8, 24),
            spreadRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Personal details',
            style: theme.textTheme.titleMedium,
          ).paddingOnly(bottom: 24),
          Text(
            'Full name',
            style: theme.textTheme.titleSmall,
          ).paddingOnly(bottom: 8),
          Text(
            'Todd Nelson',
            style: theme.textTheme.bodySmall,
          ).paddingOnly(bottom: 16),
          Text(
            'Email',
            style: theme.textTheme.titleSmall,
          ).paddingOnly(bottom: 8),
          Text(
            'tello_nii@outlook.com',
            style: theme.textTheme.bodySmall,
          ).paddingOnly(bottom: 16),
          Text(
            'Phone number',
            style: theme.textTheme.titleSmall,
          ).paddingOnly(bottom: 8),
          Text(
            '+233507058090',
            style: theme.textTheme.bodySmall,
          ).paddingOnly(bottom: 16),
          Text(
            'ID type',
            style: theme.textTheme.titleSmall,
          ).paddingOnly(bottom: 8),
          Text(
            'Passport',
            style: theme.textTheme.bodySmall,
          ).paddingOnly(bottom: 16),
          Text(
            'ID number',
            style: theme.textTheme.titleSmall,
          ).paddingOnly(bottom: 8),
          Text(
            'GHA2988458',
            style: theme.textTheme.bodySmall,
          ).paddingOnly(bottom: 16),
        ],
      ),
    ).paddingOnly(bottom: 24),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.dividerColor,
            blurRadius: 48,
            offset: const Offset(8, 24),
            spreadRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Document uploads',
            style: theme.textTheme.titleMedium,
          ).paddingOnly(bottom: 24),
          Text(
            'ID image',
            style: theme.textTheme.titleSmall,
          ).paddingOnly(bottom: 4),
          ValueListenableBuilder(
              valueListenable: idImage,
              builder: (context, imageFile, _) {
                return Column(
                  children: [
                    DottedBorder(
                      color: const Color(0xFFD0D7DE),
                      dashPattern: const [8, 6],
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(8),
                      child: Image.file(
                        File(imageFile!.path),
                        height: 200,
                        fit: BoxFit.fill,
                        width: double.infinity,
                      ),
                    ).paddingOnly(bottom: 16),
                  ],
                );
              }).paddingOnly(bottom: 16),
          Text(
            'Selfie ',
            style: theme.textTheme.titleSmall,
          ).paddingOnly(bottom: 4),
          ValueListenableBuilder(
              valueListenable: selfieImage,
              builder: (context, imageFile, _) {
                return DottedBorder(
                  color: const Color(0xFFD0D7DE),
                  dashPattern: const [8, 6],
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.file(
                        File(imageFile!.path),
                        height: 200,
                        fit: BoxFit.fill,
                        width: double.infinity,
                      )
                    ],
                  ),
                ).paddingOnly(bottom: 16);
              })
        ],
      ),
    ).paddingOnly(bottom: 32),
  ]);
}
