import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'measurement_model.dart';

class MeasurementsNotifier extends StateNotifier<List<Measurement>> {
  MeasurementsNotifier() : super([]);

  void addMeasurement(Measurement measurement) {
    try {
      state = [...state, measurement];
      print('Measurement added: ${measurement.toMap()}');
    } catch (e) {
      print('Error adding measurement: $e');
    }
  }

  void removeMeasurement(int index) {
    if (index >= 0 && index < state.length) {
      try {
        state = [
          ...state.sublist(0, index),
          ...state.sublist(index + 1),
        ];
        print('Measurement removed at index $index');
      } catch (e) {
        print('Error removing measurement: $e');
      }
    } else {
      print('Invalid index: $index');
    }
  }
}

final measurementsProvider =
    StateNotifierProvider<MeasurementsNotifier, List<Measurement>>((ref) {
  return MeasurementsNotifier();
});
