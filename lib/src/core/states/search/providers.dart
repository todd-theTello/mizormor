part of 'state_notifiers.dart';

///
final searchStateProvider = StateNotifierProvider<SearchStateNotifier, SearchStates>(
  (ref) => SearchStateNotifier(),
);
