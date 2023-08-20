import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mizormor/src/core/model/user_trip.dart';

import '../../../../utils/extensions/padding.dart';
import '../../widgets/table_row_element.dart';

class TripDetailView extends ConsumerWidget {
  const TripDetailView({required this.trip, super.key});
  final UserTrips trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text('Trip details', style: theme.textTheme.headlineSmall),
          centerTitle: false,
        ),
        SliverList.list(
          children: [
            Text(
              'Here is an overview of the trip from Accra to ${trip.destination}.',
              style: theme.textTheme.bodyLarge,
            ).paddingOnly(bottom: 24),
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0C181C32),
                        blurRadius: 48,
                        offset: Offset(0, 24),
                        spreadRadius: 10,
                      ),
                      BoxShadow(
                        color: Color(0x0C181C32),
                        blurRadius: 48,
                        offset: Offset(0, -24),
                        spreadRadius: 10,
                      )
                    ],
                    color: theme.colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Image.asset(
                      'assets/images/img_1.png',
                      height: 200,
                    ).paddingOnly(bottom: 24),
                    Table(defaultVerticalAlignment: TableCellVerticalAlignment.middle, children: [
                      buildTableRow(
                        context: context,
                        leading: 'Bus station',
                        trailing: '',
                        trailingWidget: Image.asset(
                          'assets/images/img.png',
                          width: 80,
                          height: 40,
                          fit: BoxFit.fitHeight,
                          alignment: Alignment.centerLeft,
                        ).paddingOnly(bottom: 24),
                      ),
                      buildTableRow(
                        context: context,
                        leading: 'Status',
                        trailing: trip.tripStatus,
                      ),
                      buildTableRow(
                        context: context,
                        leading: 'Ticket',
                        trailing: trip.ticketId,
                      ),
                      buildTableRow(
                        context: context,
                        leading: 'Bus number',
                        trailing: trip.bus,
                      ),
                      buildTableRow(
                        context: context,
                        leading: 'Pickup point',
                        trailing: trip.pickupPoint,
                      ),
                      buildTableRow(
                        context: context,
                        leading: 'Departure date',
                        trailing: DateFormat.yMMMMd().format(
                          trip.departureTime,
                        ),
                      ),
                      buildTableRow(
                        context: context,
                        leading: 'Departure time',
                        trailing: TimeOfDay.fromDateTime(trip.departureTime).format(context),
                      ),
                    ]).paddingOnly(bottom: 20),
                    Text(
                      'Ticket cost',
                      style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
                    ).paddingOnly(bottom: 8),
                    Text(
                      NumberFormat.currency(symbol: 'GH₵ ').format(trip.ticketPrice),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ]),
                ),
                Positioned(
                  bottom: 72,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 30,
                        height: 50,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.05),
                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(50)),
                        ),
                      ),
                      ...List.generate(15,
                          (index) => Container(color: theme.colorScheme.primary.withOpacity(0.4), height: 1, width: 5)),
                      Container(
                        width: 30,
                        height: 50,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.05),
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(50),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ).paddingOnly(bottom: 32),
          ],
        ).sliverPaddingLTRB(24, 0, 24, 32),
      ],
    ));
  }
}
