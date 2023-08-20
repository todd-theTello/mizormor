import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class NotificationsView extends ConsumerStatefulWidget {
  const NotificationsView({super.key});

  @override
  ConsumerState createState() => _NotificationsViewState();
}

class _NotificationsViewState extends ConsumerState<NotificationsView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            onTap: null,
            leading: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Iconsax.notification),
            ),
            title: const Text('You have an upcoming trip'),
            subtitle: const Text('Your trip from Accra to Kumasi is starting in an hour'),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 16);
        },
        itemCount: 8,
      ),
    );
  }
}
