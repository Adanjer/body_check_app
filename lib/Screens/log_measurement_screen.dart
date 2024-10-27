// log_measurement_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../measurements_provider.dart';
import '../measurement_model.dart';

class LogMeasurementScreen extends StatefulWidget {
  const LogMeasurementScreen({super.key});

  @override
  _LogMeasurementScreenState createState() => _LogMeasurementScreenState();
}

class _LogMeasurementScreenState extends State<LogMeasurementScreen> {
  final weightController = TextEditingController();
  final waistController = TextEditingController();
  final chestController = TextEditingController();
  final heightController = TextEditingController();
  final notesController = TextEditingController(); // Added notes controller

  void saveMeasurement(WidgetRef ref) {
    final weight = double.tryParse(weightController.text);
    final waist = double.tryParse(waistController.text);
    final chest = double.tryParse(chestController.text);
    final height = double.tryParse(heightController.text);
    final notes = notesController.text; // Capture notes input

    if (weight != null && waist != null && chest != null && height != null) {
      final measurement = Measurement(
        date: DateTime.now(),
        weight: weight,
        waist: waist,
        chest: chest,
        height: height,
        notes: notes, // Directly use the notes value
      );

      ref.read(measurementsProvider.notifier).addMeasurement(measurement);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please enter valid numbers in all fields.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Log Measurement")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Enter your latest body measurements below",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            _buildMeasurementInputField(
              label: "Weight (kg)",
              controller: weightController,
              hintText: "Enter your weight",
            ),
            const SizedBox(height: 10),

            _buildMeasurementInputField(
              label: "Waist (cm)",
              controller: waistController,
              hintText: "Enter your waist measurement",
            ),
            const SizedBox(height: 10),

            _buildMeasurementInputField(
              label: "Chest (cm)",
              controller: chestController,
              hintText: "Enter your chest measurement",
            ),
            const SizedBox(height: 10),

            _buildMeasurementInputField(
              label: "Height (cm)",
              controller: heightController,
              hintText: "Enter your height",
            ),
            const SizedBox(height: 10),

            // Save Button
            Consumer(
              builder: (context, ref, child) => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () => saveMeasurement(ref),
                child: const Text("Save Measurement"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable function to build measurement input fields
  Widget _buildMeasurementInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    bool isMultiline = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            keyboardType:
                isMultiline ? TextInputType.multiline : TextInputType.number,
            maxLines: isMultiline ? 3 : 1,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
            ),
          ),
        ),
      ],
    );
  }
}
