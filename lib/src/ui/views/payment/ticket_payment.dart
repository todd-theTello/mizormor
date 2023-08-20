import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mizormor/src/core/states/trips/states_notifiers.dart';
import 'package:mizormor/utils/extensions/alignment.dart';
import 'package:mizormor/utils/extensions/dismiss_keyboard.dart';
import 'package:mizormor/utils/overlays/authentication_loading_overlay/loading_screen.dart';

import '../../../../utils/extensions/padding.dart';
import '../../../../utils/mixins/input_validation_mixins.dart';
import '../../../core/model/trips.dart';
import '../../../core/states/users/states_notifier.dart';
import '../../widgets/authentication_textfield/authentication_textfield.dart';

///
enum PaymentMethod {
  ///
  vodafoneCash,

  ///
  mtnMoMo,

  ///
  airtelTigoMoney,
}

///
class TicketPaymentView extends ConsumerStatefulWidget {
  ///
  const TicketPaymentView({required this.tripDetails, super.key});
  final Trips tripDetails;

  @override
  ConsumerState createState() => _TicketPaymentViewState();
}

class _TicketPaymentViewState extends ConsumerState<TicketPaymentView> with InputValidationMixin {
  ValueNotifier<PaymentMethod?> paymentMethod = ValueNotifier(null);
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController pickupPointController = TextEditingController();
  final ValueNotifier<bool> phoneNumberNotifier = ValueNotifier(true);
  ValueNotifier<bool> formNotifier = ValueNotifier(false);
  void validateForm() {
    isPhoneNumberValid(phoneNumber: phoneNumberController.text.trim()) &&
            paymentMethod.value != null &&
            pickupPointController.text.isNotEmpty
        ? formNotifier.value = true
        : formNotifier.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(userStateProvider);
    ref.listen(tripPaymentStateProvider, (previous, state) async {
      if (state is TripLoading) {
        AuthenticationLoadingScreen.instance().show(context: context, text: 'Making payment');
      } else {
        AuthenticationLoadingScreen.instance().hide();
      }
      if (state is TripPaymentSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('You have successfully booked a trip'),
          ),
        );
        Navigator.of(context).pop();
        await ref.read(userStateProvider.notifier).getUserInfo();
        await ref.read(userTripStateProvider.notifier).getUserTrips();
      } else if (state is TripFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: theme.colorScheme.error,
            content: Text(state.error),
          ),
        );
      }
    });
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(),
          ValueListenableBuilder(
              valueListenable: paymentMethod,
              builder: (context, paymentValue, _) {
                return SliverList.list(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                                  'Select a pickup point and  your mobile money number  below to complete your purchase')
                              .paddingOnly(bottom: 24),
                          Text(
                            'Pickup point',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.tertiary,
                            ),
                          ).paddingOnly(bottom: 4),
                          TextField(
                            readOnly: true,
                            controller: pickupPointController,
                            onTap: () async {
                              pickupPointController.text = await showModalBottomSheet(
                                showDragHandle: true,
                                isScrollControlled: true,
                                constraints: const BoxConstraints(maxHeight: 500, minHeight: 300),
                                context: context,
                                builder: (_) => PickupPointsSelector(
                                  locations: widget.tripDetails.pickupPoint,
                                ),
                              );
                              validateForm();
                            },
                            decoration: const InputDecoration(
                              hintText: 'Select your pickup point',
                              contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            ),
                          ).paddingOnly(bottom: 16),
                          AuthenticationTextField(
                            labelText: 'Phone number',
                            controller: phoneNumberController,
                            keyboardType: TextInputType.phone,
                            validator: phoneNumberNotifier,
                            onChanged: (String value) {
                              validateForm();
                              Future.delayed(const Duration(seconds: 2), () {
                                phoneNumberNotifier.value = isPhoneNumberValid(phoneNumber: value);
                              });
                              validateForm();
                            },
                            textInputAction: TextInputAction.done,
                            errorText: 'Enter a valid phone number',
                            theme: theme,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              child: Text('+233', style: theme.textTheme.bodyLarge),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(9),
                            ],
                          ),
                        ],
                      ),
                    ).paddingOnly(bottom: 32, top: 24),
                    Text('Select your network', style: theme.textTheme.bodyLarge),
                    RadioListTile(
                      toggleable: true,
                      value: PaymentMethod.vodafoneCash,
                      groupValue: paymentValue,
                      onChanged: (PaymentMethod? method) {
                        paymentMethod.value = method;
                        validateForm();
                      },
                      title: const Text('Vodafone Cash'),
                      secondary: SizedBox(
                        height: 35,
                        width: 35,
                        child: Image.asset('assets/images/vodafone-cash.png'),
                      ),
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                    RadioListTile(
                      toggleable: true,
                      value: PaymentMethod.mtnMoMo,
                      groupValue: paymentValue,
                      onChanged: (PaymentMethod? method) {
                        paymentMethod.value = method;
                        validateForm();
                      },
                      title: const Text('MTN Mobile Money'),
                      secondary: SizedBox(
                        height: 35,
                        width: 35,
                        child: Image.asset('assets/images/mtn-momo.png'),
                      ),
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                    RadioListTile(
                      toggleable: true,
                      value: PaymentMethod.airtelTigoMoney,
                      groupValue: paymentValue,
                      onChanged: (PaymentMethod? method) {
                        paymentMethod.value = method;
                        validateForm();
                      },
                      title: const Text('AirtelTigo Money'),
                      secondary: SizedBox(
                        height: 35,
                        width: 35,
                        child: Image.asset('assets/images/airteltigo-money.png'),
                      ),
                      controlAffinity: ListTileControlAffinity.trailing,
                    ).paddingOnly(bottom: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: theme.textTheme.titleMedium),
                        Text(
                          NumberFormat.currency(symbol: 'GH₵ ').format(widget.tripDetails.ticketPrice),
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: ValueListenableBuilder(
                          valueListenable: formNotifier,
                          builder: (context, formValue, _) {
                            return FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: formValue ? null : theme.colorScheme.primary.withOpacity(0.2),
                              ),
                              onPressed: formValue
                                  ? () async {
                                      if (user is UserSuccess) {
                                        await ref.read(tripPaymentStateProvider.notifier).makeTripPayment(
                                              trip: widget.tripDetails,
                                              pickupPoint: pickupPointController.text,
                                              user: user.user,
                                            );
                                      }
                                    }
                                  : () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: theme.colorScheme.error,
                                          behavior: SnackBarBehavior.floating,
                                          content: const Text('Please perform all required actions'),
                                        ),
                                      );
                                    },
                              child: const Text('MAKE PAYMENT'),
                            );
                          }),
                    )
                  ],
                ).sliverPaddingSymmetric(horizontal: 24);
              }),
        ],
      ),
    ).dismissFocus();
  }
}

class PickupPointsSelector extends StatelessWidget {
  const PickupPointsSelector({required this.locations, super.key});
  final List<String> locations;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Select your preferred pickup point').paddingOnly(bottom: 24),
        const Divider(height: 0),
        ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(locations[index]),
              onTap: () {
                Navigator.of(context).pop(locations[index]);
              },
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: locations.length,
        ).expanded(),
      ],
    );
  }
}

final List<String> pickupPoints = ['Kasoa bus stop', 'Weija bus stop', 'Mallam Market bus stop', 'Station'];
