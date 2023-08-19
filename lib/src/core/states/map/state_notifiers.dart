import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'provider.dart';
part 'states.dart';

class MapStateNotifier extends StateNotifier<MapStates> {
  MapStateNotifier() : super(MapInitial());
}
