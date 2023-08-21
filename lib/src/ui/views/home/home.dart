import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mizormor/utils/extensions/alignment.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../utils/extensions/padding.dart';
import '../../../core/database/shared_preference.dart';
import '../../../core/states/trips/states_notifiers.dart';
import '../../../core/states/users/states_notifier.dart';
import '../../widgets/rich_text_widget/rich_text.dart';
import '../bus/search.dart';
import '../trips/trip_details.dart';
import 'account_verification.dart';
import 'notifications.dart';

/// Dashboard page on the bottom bar
class HomeView extends ConsumerStatefulWidget {
  /// dashboard view constructor
  const HomeView({super.key});

  @override
  ConsumerState createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<HomeView> {
  final PageController pendingPageController = PageController(viewportFraction: 0.8);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tripState = ref.watch(userTripStateProvider);
    final userState = ref.watch(userStateProvider);

    return CustomScrollView(
      slivers: [
        if (userState is UserSuccess) ...[
          SliverAppBar(
            leadingWidth: MediaQuery.of(context).size.width * 0.7,
            leading: Padding(
              padding: const EdgeInsets.only(left: 24),
              child: GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.blue,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10000),
                        child: userState.user.profileImageUrl != null
                            ? CachedNetworkImage(
                                imageUrl: userState.user.profileImageUrl!,
                                errorWidget: (context, url, error) => LocalPreference.displayName != ''
                                    ? Text(
                                        userState.user.otherNames?.substring(0, 1) ??
                                            userState.user.surname?.substring(0, 1) ??
                                            '',
                                        style: theme.textTheme.displaySmall,
                                      )
                                    : const Icon(Iconsax.user, size: 40),
                              )
                            : Text(
                                userState.user.otherNames?.substring(0, 1) ??
                                    userState.user.surname?.substring(0, 1) ??
                                    '',
                                style: theme.textTheme.displaySmall,
                              ),
                      ),
                    ).paddingOnly(right: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello ${userState.user.otherNames}',
                          style: theme.textTheme.titleMedium,
                        ),
                        Text(
                          'Where to next?',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const NotificationsView(),
                    ),
                  );
                },
                icon: const Badge(
                  smallSize: 12,
                  label: Text('12'),
                  child: Icon(Iconsax.notification),
                ),
              )
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SearchBusView()),
                  ),
                  //context.go('/search'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: theme.primaryColorLight),
                    ),
                    child: Row(
                      children: [
                        const Icon(Iconsax.search_normal).paddingOnly(right: 14),
                        const Text('Pick a location'),
                      ],
                    ),
                  ).paddingLTRB(24, 22, 24, 20),
                ),
                if (!userState.user.verified)
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AccountVerificationView(user: userState.user),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Unlock all features',
                                  style: theme.textTheme.titleSmall,
                                ),
                                Text(
                                  'Provide additional information to complete your account verification.',
                                  style: theme.textTheme.bodySmall,
                                ).paddingOnly(bottom: 12),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: theme.colorScheme.secondary,
                                      child: const Icon(Icons.add, color: Colors.white),
                                    ).paddingOnly(right: 8),
                                    Text('Add documents', style: theme.textTheme.bodyMedium)
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          SvgPicture.asset(
                            'assets/images/verify-card.svg',
                          )
                        ],
                      ),
                    ),
                  ).paddingLTRB(24, 0, 24, 20),
                Row(
                  children: [
                    Text(
                      'Upcoming trips',
                      style: theme.textTheme.titleLarge,
                    ),
                    if (tripState is UserTripSuccess && tripState.trips.length > 3)
                      TextButton(
                        onPressed: () {},
                        child: const Text('View more'),
                      ),
                  ],
                ).paddingOnly(left: 24, bottom: 16),
                if (tripState is UserTripSuccess && tripState.trips.isNotEmpty) ...[
                  SizedBox(
                    height: 32 * 5,
                    child: PageView.builder(
                        controller: pendingPageController,
                        itemCount: tripState.trips.length,
                        padEnds: false,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              unawaited(
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => TripDetailView(trip: tripState.trips[index]),
                                )),
                              );
                            },
                            onLongPress: () {},
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: theme.colorScheme.primary.withOpacity(0.4),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text('Trip from', style: theme.textTheme.titleMedium),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Accra', style: theme.textTheme.titleMedium),
                                      Row(
                                        children: [
                                          Container(
                                            height: 1,
                                            color: theme.primaryColor,
                                          ).expanded(),
                                          const Text('to').paddingSymmetric(horizontal: 12),
                                          Container(
                                            height: 1,
                                            color: theme.primaryColor,
                                          ).expanded(),
                                        ],
                                      ).paddingSymmetric(horizontal: 12).expanded(),
                                      Text(tripState.trips[index].destination, style: theme.textTheme.titleMedium),
                                    ],
                                  ).paddingSymmetric(vertical: 12),
                                  RichTextWidget(texts: [
                                    BaseText.custom(text: 'Departs  '),
                                    BaseText.plain(
                                        text: DateFormat.yMMMEd().format(
                                      tripState.trips[index].departureTime,
                                    )),
                                  ]),
                                ],
                              ),
                            ),
                          ).paddingOnly(
                              left: index == 0 ? 24 : 0, right: index == tripState.trips.length - 1 ? 24 : 12);
                        }),
                  ),
                  SmoothPageIndicator(
                    controller: pendingPageController,
                    count: tripState.trips.length >= 3 ? 3 : tripState.trips.length,
                    effect: JumpingDotEffect(activeDotColor: theme.primaryColor),
                  ).centerAlign()
                ] else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SvgPicture.asset(
                        'assets/images/no-data.svg',
                        height: 200,
                      ).paddingOnly(bottom: 20),
                      Text(
                        "You don't have any upcoming trips",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelMedium,
                      ).paddingSymmetric(horizontal: 24),
                      const Gap(20),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {},
                        child: const Text('Book a trip'),
                      ).paddingSymmetric(horizontal: 72, vertical: 8),
                    ],
                  ),
                const Gap(32),
                Row(
                  children: [
                    Text(
                      'Travel from',
                      style: theme.textTheme.titleLarge,
                    ).paddingOnly(left: 24, right: 8),
                    Text(
                      'Accra',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                SizedBox(
                  height: 416,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: MediaQuery.of(context).size.width - 60,
                        margin: EdgeInsets.only(right: index == 4 ? 0 : 16),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: const DecorationImage(
                              image: NetworkImage(
                                'https://images.pexels.com/photos/1414467/pexels-photo-1414467.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
                              ),
                              fit: BoxFit.fill),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                  color: const Color(0xFF2D3436).withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(16)),
                              child: Text('Recommended',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                  )),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2D3436).withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  RichTextWidget(
                                    texts: [
                                      BaseText.plain(text: 'From '),
                                      BaseText.custom(text: 'Circle VIP station'),
                                    ],
                                    styleForAll: theme.textTheme.bodyLarge?.copyWith(
                                      color: Colors.white,
                                    ),
                                    linkStyle: theme.textTheme.bodyLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    'Tuesday, 28 March - Friday, 31 March',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Kumasi',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ] else if (userState is UserLoading)
          const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          )
        else if (userState is UserFailure)
          const SliverFillRemaining()
      ],
    );
  }
}

///
enum Locations {
  ///
  accra,

  ///
  ho,

  ///
  takoradi,

  ///
  kumasi,

  ///
  capeCoast,

  ///
  axim,

  ///
  koforidua,

  ///
  hohoe,

  ///
  tamale,

  ///
  bolgatanga,

  ///
  walewale,

  ///
  obuasi,

  ///
  mankesim,

  ///
  tema,

  ///
  wa,

  ///
  sunyani;

  ///get the location names
  List<String> get locationNames => Locations.values.map((name) {
        return name != Locations.capeCoast ? name.toString().split('.').last.capitalize : 'Cape Coast';
      }).toList();

  /// returns the location name for a specific location
  String locationName({required Locations location}) {
    return location != Locations.capeCoast ? location.toString().split('.').last.capitalize : 'Cape Coast';
  }
}

///
class LocationBottomSelector extends StatelessWidget {
  ///
  const LocationBottomSelector({required ValueNotifier<Locations> locationValue, super.key})
      : _locationValue = locationValue;
  final ValueNotifier<Locations> _locationValue;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CupertinoPicker(
                useMagnifier: true,
                itemExtent: 28,
                magnification: 1.2,
                onSelectedItemChanged: (newValue) {
                  _locationValue.value = Locations.values[newValue];
                },
                children: Locations.values
                    .map((location) => DropdownMenuItem<Locations>(
                          value: location,
                          child: Center(
                            child: Text(
                              location.locationName(location: location),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ))
                    .toList()),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Done')),
        ],
      ),
    );
  }
}
