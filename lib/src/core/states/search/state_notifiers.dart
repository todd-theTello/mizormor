import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mizormor/src/core/model/trip_request_data.dart';

import '../../model/trips.dart';
import '../../repository/repositories.dart';

part 'providers.dart';
part 'states.dart';

///
class SearchStateNotifier extends StateNotifier<SearchStates> {
  ///
  SearchStateNotifier() : super(SearchInitial());
  final SearchRepository _searchRepository = SearchRepository();
  Future<void> fetchRequestedTrip({required TripRequestData data}) async {
    try {
      state = SearchLoading();
      final response = await _searchRepository.getTrips(data: data);
      if (response.status) {
        state = SearchSuccess(trips: response.data!);
      } else {
        state = SearchFailure(
          error: response.message ?? "Couldn't fetch all trips",
        );
      }
    } catch (err) {
      state = SearchFailure(error: err.toString());
    }
  }

  Future<void> fetchAllTrip() async {
    try {
      state = SearchLoading();
      final response = await _searchRepository.getAllTrips();
      if (response.status) {
        state = SearchSuccess(trips: response.data!);
      } else {
        state = SearchFailure(
          error: response.message ?? "Couldn't fetch all trips",
        );
      }
    } catch (err) {
      state = SearchFailure(error: err.toString());
    }
  }
}
