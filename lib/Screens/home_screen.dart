import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../measurements_provider.dart';
import '../measurement_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final measurements = ref.watch(measurementsProvider);

    // Extract the latest measurement, if available
    final latestMeasurement =
        measurements.isNotEmpty ? measurements.last : null;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Welcome Section
                const Text(
                  "👋 Welcome to BodyLog! Matrix!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                const Text(
                  "BodyLog is your personal fitness tracker! Log your body measurements, track your progress, "
                  "and stay motivated to achieve your fitness goals.",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "💡 Tip: Tap the '+' button to add your first measurement. Log regularly to see how far you've come!",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const Divider(height: 30, thickness: 1.5, color: Colors.grey),

                // Latest Measurement Section
                if (latestMeasurement == null)
                  Column(
                    children: [
                      const Icon(Icons.insights_outlined,
                          color: Colors.blueGrey, size: 100),
                      const Text(
                        "No measurements logged yet.\nTap the '+' button below to add your first one.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "📊 Latest Measurement",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.teal.shade50, Colors.teal.shade100],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "💪 Weight: ${latestMeasurement.weight} ${latestMeasurement.weightUnit}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "📏 Waist: ${latestMeasurement.waist} ${latestMeasurement.waistUnit}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "🩳 Chest: ${latestMeasurement.chest} ${latestMeasurement.chestUnit}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "📏 Height: ${latestMeasurement.height} ${latestMeasurement.heightUnit}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showLogMeasurementSheet(context, ref),
        backgroundColor: Colors.teal,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showLogMeasurementSheet(BuildContext context, WidgetRef ref) {
    final weightController = TextEditingController();
    final waistController = TextEditingController();
    final chestController = TextEditingController();
    final heightController = TextEditingController();

    String weightUnit = "kg";
    String waistUnit = "cm";
    String chestUnit = "cm";
    String heightUnit = "cm";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildInputFieldWithDropdown(
                    controller: weightController,
                    label: "Weight",
                    hintText: "Enter your weight",
                    units: ["kg", "lbs"],
                    currentUnit: weightUnit,
                    onUnitChanged: (value) =>
                        setState(() => weightUnit = value),
                  ),
                  const SizedBox(height: 10),
                  _buildInputFieldWithDropdown(
                    controller: waistController,
                    label: "Waist",
                    hintText: "Enter your waist measurement",
                    units: ["cm", "in"],
                    currentUnit: waistUnit,
                    onUnitChanged: (value) => setState(() => waistUnit = value),
                  ),
                  const SizedBox(height: 10),
                  _buildInputFieldWithDropdown(
                    controller: chestController,
                    label: "Chest",
                    hintText: "Enter your chest measurement",
                    units: ["cm", "in"],
                    currentUnit: chestUnit,
                    onUnitChanged: (value) => setState(() => chestUnit = value),
                  ),
                  const SizedBox(height: 10),
                  _buildInputFieldWithDropdown(
                    controller: heightController,
                    label: "Height",
                    hintText: "Enter your height",
                    units: ["cm", "m", "ft"],
                    currentUnit: heightUnit,
                    onUnitChanged: (value) =>
                        setState(() => heightUnit = value),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      final weight = double.tryParse(weightController.text);
                      final waist = double.tryParse(waistController.text);
                      final chest = double.tryParse(chestController.text);
                      final height = double.tryParse(heightController.text);

                      if (weight != null &&
                          waist != null &&
                          chest != null &&
                          height != null) {
                        final measurement = Measurement(
                          date: DateTime.now(),
                          weight: weight,
                          weightUnit: weightUnit,
                          waist: waist,
                          waistUnit: waistUnit,
                          chest: chest,
                          chestUnit: chestUnit,
                          height: height,
                          heightUnit: heightUnit,
                        );

                        ref
                            .read(measurementsProvider.notifier)
                            .addMeasurement(measurement);
                        Navigator.pop(context); // Close the bottom sheet
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter valid numbers."),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.save,
                        color: Colors.white), // Icon color changed to white
                    label: const Text(
                      "Save",
                      style: TextStyle(
                          color: Colors.white), // Text color changed to white
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Button background color
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInputFieldWithDropdown({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required List<String> units,
    required String currentUnit,
    required ValueChanged<String> onUnitChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<String>(
                value: currentUnit,
                items: units
                    .map((unit) =>
                        DropdownMenuItem(value: unit, child: Text(unit)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    onUnitChanged(value);
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
