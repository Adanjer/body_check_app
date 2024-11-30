import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../measurements_provider.dart';
import '../measurement_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final measurements = ref.watch(measurementsProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                const Text(
                  "👋 Welcome to BodyLog! Neo Matrix!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "BodyLog is your personal fitness tracker! Log your body measurements, track your progress, "
                  "and stay motivated to achieve your fitness goals. Whether you’re building muscle, shedding weight, or just maintaining a healthy lifestyle, "
                  "BodyLog helps you stay on top of your journey.",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                const Text(
                  "💡 Tip: Tap the '+' button to add your first measurement. Log regularly to see how far you've come!",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const Divider(
                  height: 30,
                  thickness: 1.5,
                  color: Colors.grey,
                ),

                // Latest Measurements Section
                if (measurements.isEmpty)
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      const Icon(
                        Icons.insights_outlined,
                        color: Colors.blueGrey,
                        size: 100,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "No measurements logged yet.\nTap the '+' button below to add your first one.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 20),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "📊 Latest Measurements",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.teal.shade50, Colors.teal.shade100],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "💪 Weight: ${measurements.last.weight} kg",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "📏 Waist: ${measurements.last.waist} cm",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "🩳 Chest: ${measurements.last.chest} cm",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "📏 Height: ${measurements.last.height} cm",
                              style: const TextStyle(fontSize: 16),
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
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showLogMeasurementSheet(BuildContext context, WidgetRef ref) {
    final weightController = TextEditingController();
    final waistController = TextEditingController();
    final chestController = TextEditingController();
    final heightController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
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
              const Text(
                "Log New Measurement",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 10),
              _buildInputField(
                controller: weightController,
                label: "Weight (kg)",
                hintText: "Enter your weight",
              ),
              const SizedBox(height: 10),
              _buildInputField(
                controller: waistController,
                label: "Waist (cm)",
                hintText: "Enter your waist measurement",
              ),
              const SizedBox(height: 10),
              _buildInputField(
                controller: chestController,
                label: "Chest (cm)",
                hintText: "Enter your chest measurement",
              ),
              const SizedBox(height: 10),
              _buildInputField(
                controller: heightController,
                label: "Height (cm)",
                hintText: "Enter your height",
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
                      waist: waist,
                      chest: chest,
                      height: height,
                    );

                    ref
                        .read(measurementsProvider.notifier)
                        .addMeasurement(measurement);

                    Navigator.pop(context); // Close the bottom sheet
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter valid numbers."),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text("Save"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
