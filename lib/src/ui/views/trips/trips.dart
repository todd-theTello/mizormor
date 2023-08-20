import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mizormor/src/core/states/trips/states_notifiers.dart';
import 'package:mizormor/utils/extensions/alignment.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../utils/extensions/dismiss_keyboard.dart';
import '../../../../utils/extensions/padding.dart';
// import '../../../core/states/trips/states_notifiers.dart';
import '../../widgets/rich_text_widget/rich_text.dart';
import '../bus/search.dart';
import 'trip_details.dart';

List<String> tripsAsString = [];

/// User trips history page
class TripsView extends ConsumerStatefulWidget {
  /// trips view constructor
  const TripsView({super.key});

  @override
  ConsumerState createState() => _TripsViewState();
}

class _TripsViewState extends ConsumerState<TripsView> {
  final PageController pendingPageController = PageController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tripState = ref.watch(userTripStateProvider);
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        await ref.read(userTripStateProvider.notifier).getUserTrips();
      },
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            centerTitle: false,
            titleSpacing: 24,
            title: Text('My trips'),
          ),
          if (tripState is UserTripSuccess)
            if (tripState.trips.isEmpty)
              SliverFillRemaining(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/no-data-1.svg',
                      height: 300,
                    ),
                    Text(
                      'No trips yet',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge,
                    ).paddingOnly(bottom: 8),
                    Text(
                      'All your trips will appear here',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ).paddingOnly(bottom: 16),
                    FilledButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SearchBusView(),
                          ),
                        );
                      },
                      child: const Text('View Available Trips'),
                    ).paddingOnly(bottom: 96)
                  ],
                ),
              ).sliverPaddingSymmetric(horizontal: 24, vertical: 22)
            else if (tripState.trips
                .any((element) => element.tripStatus == 'NOT STARTED' || element.tripStatus == 'ONGOING'))
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Pending Trips',
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        if (tripState.trips.length > 3)
                          TextButton(
                            onPressed: () {},
                            child: const Text('View more'),
                          )
                      ],
                    ).paddingOnly(left: 24, bottom: 16),
                    SizedBox(
                      height: 32 * 5,
                      child: PageView.builder(
                          controller: pendingPageController,
                          itemCount: tripState.trips.where((element) => element.tripStatus == 'NOT STARTED').length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                unawaited(
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => TripDetailView(trip: tripState.trips[index]),
                                  )),
                                );
                              },
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
                            ).paddingSymmetric(horizontal: 12);
                          }),
                    ),
                    SmoothPageIndicator(
                      controller: pendingPageController,
                      count: tripState.trips.length >= 3 ? 3 : tripState.trips.length,
                      effect: JumpingDotEffect(activeDotColor: theme.primaryColor),
                    ).centerAlign()
                  ],
                ),
              ).sliverPaddingOnly(bottom: 32),
          SliverToBoxAdapter(
            child: Text(
              'Completed Trips',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ).paddingOnly(left: 24, bottom: 16),
          ),
          if (tripState is UserTripSuccess) ...[
            if (tripState.trips.any((element) => element.tripStatus == 'COMPLETED'))
              SliverList.separated(
                itemCount: tripState.trips.where((element) => element.tripStatus == 'COMPLETED').length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async {
                      unawaited(
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => TripDetailView(trip: tripState.trips[index]),
                        )),
                      );
                    },
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: theme.colorScheme.primary.withOpacity(0.30),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    leading: Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: theme.colorScheme.error.withOpacity(0.8),
                      ),
                    ),
                    title: Text('Trip to ${tripState.trips[index].destination}'),
                    subtitle: Text(
                      DateFormat.yMMMMEEEEd().format(
                        tripState.trips[index].departureTime,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 16);
                },
              ).sliverPaddingSymmetric(horizontal: 24)
            else
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/no-data-1.svg',
                      height: 200,
                    ),
                    Text(
                      'No completed trips',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge,
                    ).paddingOnly(bottom: 8),
                    Text(
                      'You have not completed any trips yet',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ).paddingOnly(bottom: 16),
                  ],
                ),
              )
          ]
        ],
      ).dismissFocus(),
    );
  }
}
