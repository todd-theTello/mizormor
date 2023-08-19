import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../utils/extensions/dismiss_keyboard.dart';
import '../../../../utils/extensions/padding.dart';
// import '../../../core/states/trips/states_notifiers.dart';
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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final tripState = ref.watch(tripStateProvider);
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        // await ref.read(tripStateProvider.notifier).fetchTrips();
      },
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            centerTitle: false,
            titleSpacing: 24,
            title: Text('My trips'),
          ),
          // if (tripState is TripSuccess)
          //   if (tripState.trips.isEmpty)
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
          ).sliverPaddingSymmetric(horizontal: 24, vertical: 22),
          // else
          SliverToBoxAdapter(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(
                'Pending Trips',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ).paddingOnly(left: 24, bottom: 16),
              CarouselSlider.builder(
                itemCount: 4,
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
                                  image: const DecorationImage(
                                    image: AssetImage('assets/images/bus.png'),
                                    fit: BoxFit.cover,
                                  ),
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
                                  child: Text(
                                    'Departs on  ${DateFormat.yMMMEd().format(DateTime.now())} \n${TimeOfDay.now().format(context)}',
                                    textAlign: TextAlign.left,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
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
                                  const Icon(Iconsax.location),
                                  Container(
                                    height: 24,
                                    width: 1,
                                    color: Colors.grey,
                                  ).paddingSymmetric(vertical: 4),
                                  const Icon(Iconsax.tag),
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
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                                ),
                                onPressed: () async {
                                  // context.go('/trip-details');
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
                  aspectRatio: 34 / 30,
                  viewportFraction: 0.9,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 6),
                ),
              )
            ]),
          ).sliverPaddingOnly(bottom: 32),
          // if (tripsAsString.isNotEmpty)
          SliverToBoxAdapter(
            child: Text(
              'Completed Trips',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ).paddingOnly(left: 24, bottom: 16),
          ),
          // if (tripsAsString.isNotEmpty)
          SliverList.separated(
            itemCount: tripsAsString.length + 5,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () async {
                  unawaited(
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const TripDetailsView(),
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
                title: Text('Trip to Banana ${index + 1}'),
                subtitle: Text(
                  DateFormat.yMMMMEEEEd().format(
                    DateTime(2023, 11, 8),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 16);
            },
          ).sliverPaddingSymmetric(horizontal: 24)
        ],
      ).dismissFocus(),
    );
  }
}
