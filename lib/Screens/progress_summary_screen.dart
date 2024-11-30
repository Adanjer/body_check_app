// screens/progress_summary_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../measurements_provider.dart';

class ProgressSummaryScreen extends ConsumerWidget {
  const ProgressSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final measurements = ref.watch(measurementsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Progress Summary")),
      body: measurements.isEmpty
          ? const Center(
              child: Text(
                "No measurements to display.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: measurements.length,
              itemBuilder: (context, index) {
                final measurement = measurements[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade100,
                          Colors.blue.shade300,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Your Measure ${index + 1}",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Delete Measurement"),
                                      content: const Text(
                                          "Are you sure you want to delete this measurement?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            ref
                                                .read(measurementsProvider
                                                    .notifier)
                                                .removeMeasurement(index);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Delete"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildMetric(
                                icon: Icons.calendar_today,
                                label: "Date",
                                value:
                                    "${measurement.date.day}/${measurement.date.month}/${measurement.date.year}"),
                            _buildMetric(
                                icon: Icons.fitness_center,
                                label: "Weight",
                                value: "${measurement.weight} kg"),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildMetric(
                                icon: Icons.accessibility,
                                label: "Waist",
                                value: "${measurement.waist} cm"),
                            _buildMetric(
                                icon: Icons.expand_circle_down_outlined,
                                label: "Chest",
                                value: "${measurement.chest} cm"),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildMetric(
                                icon: Icons.height,
                                label: "Height",
                                value: "${measurement.height} cm"),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildMetric({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}
