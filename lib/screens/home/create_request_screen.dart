import 'package:bds/controllers/auth_controller.dart';
import 'package:bds/controllers/hospital_controller.dart';
import 'package:bds/controllers/request_blood_controller.dart';
import 'package:bds/models/request_blood_model.dart';
import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/hero_section.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({Key? key}) : super(key: key);

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  // controllers
  final _quantityCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  // GetX controllers
  final hospitalController = Get.find<HospitalController>();
  final requestBloodController = Get.find<RequestBloodController>();

  // selections
  String? selectedHospitalId;
  String? selectedBloodGroup;
  String? selectedUrgency;

  final bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final urgencies = ['low', 'medium', 'high'];

  @override
  void initState() {
    super.initState();
    hospitalController.getHospitals(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          const HeroSection(
            title: 'Request Blood Donation',
            subtitle: 'Ask for blood donations',
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1) Blood type grid
                    Text("Select blood type you need", style: AppTextStyles.subheading),
                    const SizedBox(height: 16),
                    GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: bloodTypes.length,
                      itemBuilder: (_, i) {
                        final bt = bloodTypes[i];
                        final selected = bt == selectedBloodGroup;
                        return GestureDetector(
                          onTap: () => setState(() => selectedBloodGroup = bt),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: selected ? AppColors.primaryRed : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selected ? AppColors.primaryRed : Colors.grey.shade400,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                bt,
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: selected ? Colors.white : AppColors.textDark,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // 2) Hospital dropdown
                          GetBuilder<HospitalController>(
                            builder: (_) {
                              if (!hospitalController.isLoaded) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              return DropdownButtonFormField<String>(
                                value: selectedHospitalId,
                                decoration: InputDecoration(
                                  labelText: 'Select Hospital',
                                  prefixIcon: Icon(Icons.local_hospital, color: AppColors.primaryRed),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: AppColors.primaryRed),
                                  ),
                                ),
                                items: hospitalController.hospitalList.map((h) {
                                  return DropdownMenuItem(
                                    value: h.id.toString(),
                                    child: Text(h.name ?? 'Unknown Hospital'),                                  
                                  );
                                }).toList(),
                                onChanged: (val) => setState(() => selectedHospitalId = val),
                                validator: (v) => v == null ? 'Please select a hospital' : null,
                              );
                            },
                          ),

                          const SizedBox(height: 16),
                          // 3) Urgency dropdown
                          DropdownButtonFormField<String>(
                            value: selectedUrgency,
                            decoration: InputDecoration(
                              labelText: 'Select Urgency',
                              prefixIcon: Icon(Icons.priority_high, color: AppColors.primaryRed),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppColors.primaryRed),
                              ),
                            ),
                            items: urgencies.map((u) {
                              return DropdownMenuItem(value: u, child: Text(u.capitalizeFirst!));
                            }).toList(),
                            onChanged: (val) => setState(() => selectedUrgency = val),
                            validator: (v) => v == null ? 'Please select urgency' : null,
                          ),

                          const SizedBox(height: 16),
                          // 4) Quantity field
                          TextFormField(
                            controller: _quantityCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Quantity (pints)',
                              prefixIcon: Icon(Icons.format_list_numbered, color: AppColors.primaryRed),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppColors.primaryRed),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Enter quantity';
                              if (int.tryParse(v) == null) return 'Must be a number';
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),
                          // 5) Notes (optional)
                          TextFormField(
                            controller: _notesCtrl,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Notes (optional)',
                              prefixIcon: Icon(Icons.note, color: AppColors.primaryRed),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppColors.primaryRed),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),

      // Submit button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          label: 'Submit Request',
          onPressed: () async {
            if (_formKey.currentState!.validate() && selectedBloodGroup != null) {
              Get.find<AuthController>().updateToken(); 
              final model = RequestBloodModel(
                id: 0,
                hospitalId: int.parse(selectedHospitalId!),
                bloodType: selectedBloodGroup!,
                quantity: int.parse(_quantityCtrl.text),
                urgency: selectedUrgency!,
                status: 'pending',
              );

              bool isSuccess = await requestBloodController.requestBlood(model);
              if (isSuccess) {
                Get.snackbar(
                  'Success',
                  'Blood request submitted successfully.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );

                // Optionally clear form or navigate away
                _formKey.currentState!.reset();
                setState(() {
                  selectedBloodGroup = null;
                  selectedHospitalId = null;
                  selectedUrgency = null;
                });
              } else {
                Get.snackbar(
                  'Error',
                  'Failed to submit blood request.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            } else if (selectedBloodGroup == null) {
              Get.snackbar('Error', 'Please select a blood type');
            }
          },

        ),
      ),
    );
  }
}
