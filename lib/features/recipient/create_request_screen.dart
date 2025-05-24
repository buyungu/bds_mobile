import 'package:flutter/material.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/blood_type_chip.dart';
import '../../core/widgets/hero_section.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _hospitalController = TextEditingController();
  final _locationController = TextEditingController();
  final _noteController = TextEditingController();
  final _quantityController = TextEditingController();

  String selectedBloodType = 'A+';
  String selectedUrgency = 'Normal';

  final List<String> bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final List<String> urgencyLevels = ['Normal', 'High', 'Critical'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeroSection(
                title: 'Request Blood',
                subtitle: 'Submit a new blood request',
              ),
              const SizedBox(height: 24),

              const Text('Select Blood Type', style: AppTextStyles.subheading),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: bloodTypes.map((type) {
                  return BloodTypeChip(
                    type: type,
                    isSelected: selectedBloodType == type,
                    onTap: () => setState(() => selectedBloodType = type),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),
              const Text('Urgency', style: AppTextStyles.subheading),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                children: urgencyLevels.map((level) {
                  final isSelected = selectedUrgency == level;
                  return ChoiceChip(
                    label: Text(level),
                    selected: isSelected,
                    onSelected: (_) => setState(() => selectedUrgency = level),
                    selectedColor: AppColors.primaryRed,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),
              _buildTextField(controller: _hospitalController, hint: 'Hospital Name'),
              const SizedBox(height: 16),
              _buildTextField(controller: _locationController, hint: 'Location'),
              const SizedBox(height: 16),
              _buildTextField(controller: _quantityController, hint: 'Quantity (in pints)', keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              _buildTextField(controller: _noteController, hint: 'Additional Notes (optional)', maxLines: 4),

              const SizedBox(height: 24),
              CustomButton(
                label: 'Submit Request',
                onPressed: () {
                  // TODO: Handle submission logic
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
