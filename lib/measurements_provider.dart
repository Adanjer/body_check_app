// measurements_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'measurement_model.dart';

class MeasurementsNotifier extends StateNotifier<List<Measurement>> {
  MeasurementsNotifier() : super([]);

  void addMeasurement(Measurement measurement) {
    state = [...state, measurement];
  }

  void removeMeasurement(int index) {
    state = [
      ...state.sublist(0, index),
      ...state.sublist(index + 1),
    ];
  }
}

final measurementsProvider =
    StateNotifierProvider<MeasurementsNotifier, List<Measurement>>((ref) {
  return MeasurementsNotifier();
});
