import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mizormor/src/ui/views/profile/edit_profile.dart';
import 'package:mizormor/utils/extensions/padding.dart';

import '../../../../utils/overlays/authentication_loading_overlay/loading_screen.dart';
import '../../../../utils/platform/image.dart';
import '../../../core/database/shared_preference.dart';
import '../../../core/states/authentication/state_notifier.dart';
import '../../../core/states/users/states_notifier.dart';

///
class ProfileView extends ConsumerStatefulWidget {
  /// profile view controller
  const ProfileView({super.key});

  @override
  ConsumerState createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).padding;

    ref.listen(authenticationProvider, (previous, state) {
      if (state is AuthenticationLoading) {
        AuthenticationLoadingScreen.instance().show(context: context, text: 'Signing out, please wait!');
      } else {
        AuthenticationLoadingScreen.instance().hide();
      }
    });
    final userState = ref.watch(userStateProvider);
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        await ref.read(userStateProvider.notifier).getUserInfo();
      },
      child: CustomScrollView(
        slivers: [
          if (userState is UserSuccess)
            SliverList.list(children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await showCupertinoModalPopup<String>(
                        context: context,
                        builder: (_) => CupertinoActionSheet(
                          message: const Text('Select picture via'),
                          cancelButton: CupertinoActionSheetAction(
                            /// This parameter indicates the action would perform
                            /// a destructive action such as delete or exit and turns
                            /// the action's text color to red.
                            isDestructiveAction: true,

                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          actions: <CupertinoActionSheetAction>[
                            CupertinoActionSheetAction(
                              /// This parameter indicates the action would be a default
                              /// defualt behavior, turns the action's text to bold text.
                              isDefaultAction: true,
                              onPressed: () async {},
                              child: const Text('Camera'),
                            ),
                            CupertinoActionSheetAction(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await ImagePickerUtil.openGallery();
                              },
                              child: const Text('Gallery'),
                            ),

                            /// This parameter indicates the action would perform
                          ],
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10000),
                        child: userState.user.profileImageUrl != null
                            ? CachedNetworkImage(
                                imageUrl: userState.user.profileImageUrl!,
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => LocalPreference.displayName != ''
                                    ? Text(
                                        userState.user.otherNames?.substring(0, 1) ??
                                            userState.user.surname?.substring(0, 1) ??
                                            '',
                                        style: theme.textTheme.displayLarge,
                                      )
                                    : const Icon(Iconsax.user, size: 40),
                              )
                            : Text(
                                userState.user.otherNames?.substring(0, 1) ??
                                    userState.user.surname?.substring(0, 1) ??
                                    '',
                                style: theme.textTheme.displayLarge,
                              ),
                      ),
                    ),
                  ).paddingOnly(right: 24),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${userState.user.otherNames} ${userState.user.surname}',
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        userState.user.email ?? '',
                        style: theme.textTheme.bodyMedium,
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.only(right: 24),
                            visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const EditProfileView(),
                              ),
                            );
                          },
                          child: Text(
                            'Edit',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              decoration: TextDecoration.underline,
                              decorationThickness: 2,
                            ),
                          ))
                    ],
                  )
                ],
              ).paddingOnly(bottom: 32, top: 24),
              // else
              //   const CircularProgressIndicator.adaptive(),
              Text(
                'Personal details',
                style: theme.textTheme.titleSmall,
              ).paddingOnly(top: 32),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFDFE6E9),
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Account',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text('Manage your account details', style: theme.textTheme.bodyMedium),
                      trailing: const Icon(Iconsax.arrow_right_2),
                    ),
                    ListTile(
                      title: Text(
                        'Preferences',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text('Customize your app  preferences to get the best experience',
                          style: theme.textTheme.bodyMedium),
                      trailing: const Icon(Iconsax.arrow_right_2),
                    ),
                  ],
                ),
              ),
              Text('Settings', style: theme.textTheme.titleSmall),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFDFE6E9),
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Notifications',
                        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(Iconsax.arrow_right_2),
                    ),
                    ListTile(
                      title: Text(
                        'Security',
                        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(Iconsax.arrow_right_2),
                    ),
                    ListTile(
                      title: Text(
                        'Theme',
                        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(Iconsax.arrow_right_2),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFDFE6E9),
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Send feedback',
                        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(Iconsax.arrow_right_2),
                    ),
                    ListTile(
                      title: Text(
                        'Rate the app',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(Iconsax.arrow_right_2),
                    ),
                    ListTile(
                      title: Text(
                        'About',
                        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(Iconsax.arrow_right_2),
                    ),
                    ListTile(
                      title: Text(
                        'Terms and conditions',
                        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(Iconsax.arrow_right_2),
                    ),
                    ListTile(
                      title: Text(
                        'Privacy policy',
                        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(Iconsax.arrow_right_2),
                    ),
                    ListTile(
                      title: Text(
                        'Software licenses',
                        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(Iconsax.arrow_right_2),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.colorScheme.error),
                ),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () async {
                        await ref.read(authenticationProvider.notifier).signOut();
                      },
                      title: Text(
                        'Sign out',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.error,
                        ),
                      ),
                      trailing: Icon(Iconsax.logout, color: theme.colorScheme.error),
                    ),
                  ],
                ),
              ),
            ]).sliverPaddingSymmetric(horizontal: 24, vertical: size.top)
          else if (userState is UserLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            )
          else if (userState is UserFailure)
            const SliverFillRemaining()
        ],
      ),

      // ListView(
      //   padding: EdgeInsets.symmetric(horizontal: 24, vertical: size.top),
      //   children:
      // ),
    );
  }
}
