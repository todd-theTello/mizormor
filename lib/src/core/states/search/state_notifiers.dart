import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/trips.dart';

part 'providers.dart';
part 'states.dart';

///
class SearchStateNotifier extends StateNotifier<SearchStates> {
  ///
  SearchStateNotifier() : super(SearchInitial());
  // final SearchRepository _searchRepository = SearchRepository();
}
