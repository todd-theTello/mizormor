import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mizormor/utils/extensions/count_down_timer.dart';

import '../../../../utils/extensions/padding.dart';
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
  ValueNotifier<Locations> locationValue = ValueNotifier(Locations.accra);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tripState = ref.watch(tripStateProvider);
    final userState = ref.watch(userStateProvider);

    return CustomScrollView(
      slivers: [
        if (userState is UserSuccess) ...[
          SliverAppBar(
            leadingWidth: MediaQuery.of(context).size.width * 0.7,
            leading: Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hey there',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.tertiary,
                      )),
                  Text('Where to next?', style: theme.textTheme.titleMedium),
                ],
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
                    MaterialPageRoute(
                      builder: (_) => const SearchBusView(),
                    ),
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
                  ).paddingLTRB(24, 22, 24, 40),
                ),
                // if (userState is UserSuccess && !userState.user.verified)
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AccountVerificationView(),
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
                                style: theme.textTheme.bodyLarge,
                              ),
                              Text(
                                'Provide additional information to complete your account verification.',
                                style: theme.textTheme.bodyMedium,
                              ).paddingOnly(bottom: 24),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: theme.colorScheme.secondary,
                                    child: const Icon(
                                      Icons.add,
                                      size: 24,
                                      color: Colors.white,
                                    ),
                                  ).paddingOnly(right: 8),
                                  Text('Add documents', style: theme.textTheme.bodyLarge)
                                ],
                              ),
                            ],
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/images/verify-card.svg',
                        )
                      ],
                    ),
                  ),
                ).paddingLTRB(24, 0, 24, 40),
                Text(
                  'Upcoming trips',
                  style: theme.textTheme.titleLarge,
                ).paddingOnly(left: 24, bottom: 24),
                if (tripState is TripSuccess && tripState.trips.isNotEmpty)
                  CarouselSlider.builder(
                    itemCount: tripState.trips.length,
                    itemBuilder: (context, itemIndex, pageIndex) {
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: theme.colorScheme.primary.withOpacity(0.4),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: theme.primaryColor.withOpacity(0.6),
                                      border: Border.all(
                                        color: theme.colorScheme.primary.withOpacity(0.4),
                                      ),
                                      // image: DecorationImage(
                                      //   image: NetworkImage(tripState.trips[itemIndex].tripImg!),
                                      //   fit: BoxFit.cover,
                                      // ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 16,
                                    right: 16,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white.withOpacity(0.5),
                                        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.4)),
                                      ),
                                      child: Text(
                                        NumberFormat.currency(symbol: 'GH₵ ').format(399),
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 14,
                                    left: 16,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white.withOpacity(0.5),
                                        border: Border.all(
                                          color: theme.colorScheme.primary.withOpacity(0.4),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Departs in   ',
                                            style: theme.textTheme.bodyLarge?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            86399.toFormatHHMMSS,
                                            style: theme.textTheme.bodyLarge?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ).paddingOnly(bottom: 12),
                              Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(IconlyLight.location),
                                      Container(
                                        height: 24,
                                        width: 1,
                                        color: Colors.grey,
                                      ).paddingSymmetric(vertical: 4),
                                      const Icon(IconlyLight.location),
                                    ],
                                  ).paddingOnly(right: 12, left: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Accra',
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontSize: 18,
                                        ),
                                      ).paddingOnly(bottom: 26),
                                      Text(
                                        'Takoradi',
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  FilledButton(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: theme.colorScheme.primaryContainer,
                                      shape: const StadiumBorder(),
                                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                                    ),
                                    onPressed: () async {
                                      unawaited(
                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (_) => const TripDetailsView(),
                                        )),
                                      );
                                    },
                                    child: const Text('View'),
                                  )
                                ],
                              ).paddingOnly(bottom: 12),
                            ],
                          ),
                        ),
                      ).paddingSymmetric(horizontal: 12);
                    },
                    options: CarouselOptions(
                      aspectRatio: 34 / 28,
                      viewportFraction: 0.9,
                      autoPlay: tripState.trips.length > 1,
                      autoPlayInterval: const Duration(seconds: 6),
                    ),
                  )
                else
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
                        child: const Text('View Available Trips'),
                      ).paddingSymmetric(horizontal: 72, vertical: 8),
                    ],
                  ),
                const Gap(64),
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
                    ), /*
                    ValueListenableBuilder(
                        valueListenable: locationValue,
                        builder: (context, travelFrom, _) {
                          return Platform.isAndroid
                              ? DropdownButton(
                                  value: travelFrom,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: theme.primaryColor,
                                  ),
                                  isDense: true,
                                  items: Locations.values
                                      .map((location) => DropdownMenuItem<Locations>(
                                          value: location,
                                          child: Text(
                                            location.locationName(location: location),
                                          )))
                                      .toList(),
                                  onChanged: (newValue) {
                                    locationValue.value = newValue!;
                                  },
                                  underline: const SizedBox.shrink(),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    await showCupertinoModalPopup<Locations>(
                                      context: context,
                                      builder: (_) => LocationBottomSelector(
                                        locationValue: locationValue,
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        travelFrom.locationName(location: travelFrom),
                                        style: theme.textTheme.titleLarge?.copyWith(
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                      const Icon(Icons.arrow_drop_down)
                                    ],
                                  ),
                                );
                        }).paddingOnly(left: 12),
                 */
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
                                      BaseText.custom(text: 'TUDU STC STATION'),
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
                                    'Bolgatanga',
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
