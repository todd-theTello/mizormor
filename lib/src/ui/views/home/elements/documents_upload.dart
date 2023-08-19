part of 'account_verification.dart';

SliverList buildDocumentUploadView({
  required BuildContext context,
  required ValueNotifier<XFile?> selfieImage,
  required ValueNotifier<XFile?> idImage,
  required VoidCallback validateForm,
}) {
  final theme = Theme.of(context);

  return SliverList.list(children: [
    Text(
      'Document upload',
      style: theme.textTheme.titleLarge,
    ).paddingOnly(top: 24),
    Text(
      'We need a few more details to verify your account',
      style: theme.textTheme.bodyLarge,
    ).paddingOnly(bottom: 16),
    Text(
      'ID image',
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.tertiary,
        fontWeight: FontWeight.w600,
      ),
    ).paddingOnly(bottom: 4),
    GestureDetector(
      onTap: () async {
        idImage.value = await ImagePickerUtil.openGallery().then(
          (value) => ImagePickerUtil.cropImage(imagePath: value!.path).then((value) => XFile(
                value!.path,
              )),
        );

        validateForm();
      },
      child: ValueListenableBuilder(
          valueListenable: idImage,
          builder: (context, imageFile, _) {
            return Column(
              children: [
                DottedBorder(
                  color: const Color(0xFFD0D7DE),
                  dashPattern: const [8, 6],
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (imageFile != null)
                        Image.file(File(imageFile.path), height: 200, fit: BoxFit.fill)
                      else
                        Column(
                          children: [
                            Text(
                              'Upload a picture of the photo side of your ID',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleSmall,
                            ).paddingSymmetric(horizontal: 48),
                            Text(
                              'File types: images (.png, .jpg)',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.labelSmall,
                            ),
                          ],
                        ),
                    ],
                  ),
                ).paddingOnly(bottom: 16),
              ],
            );
          }),
    ).paddingOnly(bottom: 16),
    Text(
      'Selfie ',
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.tertiary,
        fontWeight: FontWeight.w600,
      ),
    ).paddingOnly(bottom: 4),
    GestureDetector(
      onTap: () async {
        selfieImage.value = await ImagePickerUtil.openGallery().then(
          (value) => ImagePickerUtil.cropImage(imagePath: value!.path).then((value) => XFile(
                value!.path,
              )),
        );
        validateForm();
      },
      child: ValueListenableBuilder(
          valueListenable: selfieImage,
          builder: (context, imageFile, _) {
            return Column(
              children: [
                DottedBorder(
                  color: const Color(0xFFD0D7DE),
                  dashPattern: const [8, 6],
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (imageFile != null)
                        Image.file(File(imageFile.path), height: 200, fit: BoxFit.fill)
                      else
                        Column(
                          children: [
                            Text(
                              'Upload a picture of yourself with the ID image',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleSmall,
                            ).paddingSymmetric(horizontal: 48),
                            Text(
                              'File types: images (.png, .jpg)',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.labelSmall,
                            ),
                          ],
                        ),
                    ],
                  ),
                ).paddingOnly(bottom: 16),
              ],
            );
          }),
    ).paddingOnly(bottom: 24),
  ]);
}
