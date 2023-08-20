import 'dart:async';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../utils/extensions/alignment.dart';
import '../../../../utils/extensions/dismiss_keyboard.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../core/model/trip_request_data.dart';
import '../../../core/states/search/state_notifiers.dart';
import '../../widgets/table_row_element.dart';
import '../payment/ticket_payment.dart';

/// Search bus page
class SearchBusView extends ConsumerStatefulWidget {
  /// search bus constructor
  const SearchBusView({super.key});

  @override
  ConsumerState createState() => _SearchBusViewState();
}

class _SearchBusViewState extends ConsumerState<SearchBusView> {
  final TextEditingController destinationController = TextEditingController();
  ValueNotifier<DateTime?> departureDate = ValueNotifier(null);
  ValueNotifier<bool?> validForm = ValueNotifier(null);
  void validateForm() {
    validForm.value = departureDate.value != null && destinationController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchState = ref.watch(searchStateProvider);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            centerTitle: false,
            floating: true,
            titleSpacing: 24,
            title: Text('Search'),
          ),
          SliverToBoxAdapter(
            child: ValueListenableBuilder(
                valueListenable: validForm,
                builder: (context, form, _) {
                  return Column(
                    children: [
                      TextField(
                        controller: destinationController,
                        readOnly: true,
                        onChanged: (_) {
                          validateForm();
                        },
                        onTap: () async {
                          destinationController.text = await showModalBottomSheet(
                            showDragHandle: true,
                            context: context,
                            builder: (_) => const LocationSelector(),
                          );
                          if (form!) {
                            ref.read(searchStateProvider.notifier).fetchRequestedTrip(
                                  data: TripRequestData(
                                    destination: destinationController.text,
                                    departureDate: departureDate.value!,
                                  ),
                                );
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: 'Destination',
                          prefixIcon: Icon(Iconsax.tag),
                        ),
                      ),
                      ValueListenableBuilder(
                          valueListenable: departureDate,
                          builder: (context, departure, _) {
                            return TextField(
                              controller: TextEditingController(
                                  text: departure != null ? DateFormat.yMMMEd().format(departure) : null),
                              readOnly: true,
                              onTap: () async {
                                departureDate.value = await showDatePicker(
                                  context: context,
                                  selectableDayPredicate: (_) {
                                    return true;
                                  },
                                  initialDate: departure ?? DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 7)),
                                );
                                validateForm();

                                if (form!) {
                                  ref.read(searchStateProvider.notifier).fetchRequestedTrip(
                                        data: TripRequestData(
                                          destination: destinationController.text,
                                          departureDate: departureDate.value!,
                                        ),
                                      );
                                }
                              },
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Iconsax.calendar),
                                hintText: 'Departure date',
                              ),
                            );
                          }).paddingOnly(top: 16),
                    ],
                  ).paddingSymmetric(horizontal: 24);
                }),
          ),
          if (searchState is SearchSuccess)
            if (searchState.trips.isNotEmpty)
              SliverList.separated(
                  itemCount: searchState.trips.length,
                  itemBuilder: (context, index) {
                    return ExpandableNotifier(
                      child: Expandable(
                          collapsed: ExpandableButton(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: theme.colorScheme.primary,
                                  )),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Trip from', style: theme.textTheme.titleMedium),
                                      const Icon(Iconsax.arrow_down_1)
                                    ],
                                  ),
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
                                      Text(searchState.trips[index].destination, style: theme.textTheme.titleMedium),
                                    ],
                                  ).paddingSymmetric(vertical: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    constraints: const BoxConstraints(maxWidth: 150),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: theme.colorScheme.secondaryContainer,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${searchState.trips[index].passengers.length} / ${searchState.trips[index].seatCapacity} seats taken')
                                            .paddingOnly(bottom: 8),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: LinearProgressIndicator(
                                            value: searchState.trips[index].passengers.length / 72,
                                          ),
                                        ).paddingOnly(bottom: 4),
                                      ],
                                    ),
                                  ).paddingOnly(bottom: 16),
                                  Table(defaultVerticalAlignment: TableCellVerticalAlignment.middle, children: [
                                    buildTableRow(
                                      context: context,
                                      leading: 'Departure date',
                                      trailing: DateFormat.yMMMMd().format(searchState.trips[index].departureTime),
                                    ),
                                    buildTableRow(
                                      context: context,
                                      leading: 'Departure time',
                                      trailing: TimeOfDay.fromDateTime(
                                        searchState.trips[index].departureTime,
                                      ).format(context),
                                    ),
                                  ]),
                                ],
                              ),
                            ),
                          ),
                          expanded: ExpandableButton(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: theme.colorScheme.primary,
                                  )),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Trip from', style: theme.textTheme.titleMedium),
                                      const Icon(Iconsax.arrow_up_2)
                                    ],
                                  ),
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
                                      Text(searchState.trips[index].destination, style: theme.textTheme.titleMedium),
                                    ],
                                  ).paddingSymmetric(vertical: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    constraints: const BoxConstraints(maxWidth: 150),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: theme.colorScheme.secondaryContainer,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${searchState.trips[index].passengers.length} / ${searchState.trips[index].seatCapacity} seats taken')
                                            .paddingOnly(bottom: 8),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: LinearProgressIndicator(
                                            value: searchState.trips[index].passengers.length / 72,
                                          ),
                                        ).paddingOnly(bottom: 4),
                                      ],
                                    ),
                                  ).paddingOnly(bottom: 16),
                                  Table(defaultVerticalAlignment: TableCellVerticalAlignment.middle, children: [
                                    buildTableRow(
                                      context: context,
                                      leading: 'Bus number',
                                      trailing: searchState.trips[index].bus,
                                    ),
                                    buildTableRow(
                                      context: context,
                                      leading: 'Departure date',
                                      trailing: DateFormat.yMMMMd().format(searchState.trips[index].departureTime),
                                    ),
                                    buildTableRow(
                                      context: context,
                                      leading: 'Departure time',
                                      trailing: TimeOfDay.fromDateTime(
                                        searchState.trips[index].departureTime,
                                      ).format(context),
                                    ),
                                  ]),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        NumberFormat.currency(symbol: 'GH¢ ').format(
                                          searchState.trips[index].ticketPrice,
                                        ),
                                        style: theme.textTheme.titleMedium,
                                      ),
                                      FilledButton(
                                        style: FilledButton.styleFrom(
                                          backgroundColor: theme.colorScheme.primaryContainer,
                                          foregroundColor: theme.colorScheme.onSecondaryContainer,
                                          shape: const StadiumBorder(),
                                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                                        ),
                                        onPressed: () async {
                                          unawaited(
                                            Navigator.of(context).push(MaterialPageRoute(
                                              builder: (_) => TicketPaymentView(
                                                tripDetails: searchState.trips[index],
                                              ),
                                            )),
                                          );
                                        },
                                        child: const Text('Book now'),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )),
                    ).paddingSymmetric(horizontal: 20);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 16);
                  }).sliverPaddingOnly(top: 32)
            else
              SliverFillRemaining(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No trips available for selection',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelMedium?.copyWith(fontSize: 22),
                    ).paddingOnly(bottom: 8),
                    Text(
                      'Browse all available trips',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelMedium?.copyWith(fontSize: 18),
                    ).paddingOnly(bottom: 16),
                    FilledButton(
                      onPressed: () async {
                        await ref.read(searchStateProvider.notifier).fetchAllTrip();
                      },
                      child: const Text('Browse all trip'),
                    ).paddingOnly(bottom: 0)
                  ],
                ).paddingSymmetric(horizontal: 24),
              )
          else if (searchState is SearchFailure)
            SliverFillRemaining(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'An error occurred while trying to fetch trips\n Please try again later',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelMedium?.copyWith(fontSize: 18),
                  ).paddingOnly(bottom: 16),
                  FilledButton(
                    onPressed: () {},
                    child: const Text('Try again'),
                  ).paddingOnly(bottom: 0)
                ],
              ).paddingSymmetric(horizontal: 24),
            )
          else if (searchState is SearchLoading)
            const SliverFillRemaining(
              child: CircularProgressIndicator.adaptive(),
            )
        ],
      ),
    ).dismissFocus();
  }
}

class LocationSelector extends StatelessWidget {
  const LocationSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          'Where are you heading?',
          style: theme.textTheme.titleMedium,
        ).paddingOnly(bottom: 24, left: 16).centerLeftAlign(),
        const Divider(height: 0),
        const TextField(
          decoration: InputDecoration(
            hintText: 'Search for location',
            prefixIcon: Icon(Iconsax.search_normal),
          ),
        ).paddingSymmetric(horizontal: 16, vertical: 12),
        ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(destinations[index]),
              onTap: () {
                Navigator.of(context).pop(destinations[index]);
              },
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: destinations.length,
        ).expanded(),
      ],
    );
  }
}

final List<String> destinations = ['Takoradi', 'Kumasi', 'Cape Coast', 'Sunyani'];
