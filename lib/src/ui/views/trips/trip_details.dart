import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../utils/extensions/padding.dart';
import '../../widgets/table_row_element.dart';

///
class TripDetailsView extends ConsumerStatefulWidget {
  ///
  const TripDetailsView({super.key});

  @override
  ConsumerState createState() => _TripDetailsViewState();
}

class _TripDetailsViewState extends ConsumerState<TripDetailsView> {
  @override
  Widget build(BuildContext context) {
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
              'Here is an overview of the trip from Accra to Takoradi.',
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
                    Image.asset('assets/images/img_1.png').paddingOnly(bottom: 24),
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
                        leading: 'Ticket',
                        trailing: 'TKAR123NOV2623',
                      ),
                      buildTableRow(
                        context: context,
                        leading: 'Bus number',
                        trailing: 'GT - 4588 - 23',
                      ),
                      buildTableRow(
                        context: context,
                        leading: 'Departure date',
                        trailing: DateFormat.yMMMMd().format(
                          DateTime.now().add(
                            const Duration(days: 167),
                          ),
                        ),
                      ),
                      buildTableRow(
                        context: context,
                        leading: 'Departure time',
                        trailing: const TimeOfDay(hour: 11, minute: 00).format(context),
                      ),
                    ]).paddingOnly(bottom: 72),
                    Text(
                      'Ticket cost',
                      style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
                    ).paddingOnly(bottom: 8),
                    Text(
                      NumberFormat.currency(symbol: 'GH₵ ').format(399),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ]),
                ),
                Positioned(
                  bottom: 120,
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
                          (index) => Container(color: theme.colorScheme.primary.withOpacity(0.2), height: 1, width: 5)),
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
