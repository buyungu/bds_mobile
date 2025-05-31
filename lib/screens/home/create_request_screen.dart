import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/hero_section.dart';
// import '../../app/theme/app_text_styles.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  String? selectedBloodGroup;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final List<String> bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          const HeroSection(title: 'Request Blood Donation ', subtitle: 'Ask for blood Dontions'),

          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select blood type you need",
                      style: AppTextStyles.subheading,
                    ),
                    SizedBox(height: 16,),
                    GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: bloodTypes.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedBloodGroup = bloodTypes[index];
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: selectedBloodGroup == bloodTypes[index]
                                  ? AppColors.primaryRed
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selectedBloodGroup == bloodTypes[index]
                                    ? AppColors.primaryRed
                                    : Colors.grey.shade400,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                bloodTypes[index],
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: selectedBloodGroup == bloodTypes[index]
                                      ? Colors.white
                                      : AppColors.textDark,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20,),
                          _buildTextFormField(
                            controller: _hospitalController,
                            label: "Hospital Name",
                            icon: Icons.local_hospital,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the hospital name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          _buildTextFormField(
                            controller: _locationController,
                            label: "location",
                            icon: Icons.location_on,
                            suffixIcon: Icons.my_location,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your location';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20,),
                          _buildTextFormField(
                            controller: _notesController,
                            label: "Notes",
                            icon: Icons.note,
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter any additional notes';
                              }
                              return null;
                            },
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          label: 'Submit Request',
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Handle form submission
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Donation request submitted successfully!')),
              );
            }
          },
        ),
      ),
    );
  }
}

Widget _buildTextFormField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  IconData? suffixIcon,
  int maxLines = 1,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    maxLines: maxLines,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.primaryRed,),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:BorderSide(color: Colors.grey.shade400)
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primaryRed)
      ),
      suffixIcon: 
        suffixIcon != null
          ? IconButton(
              onPressed: () {
                // Some codes
              }, 
              icon: Icon(suffixIcon, color: AppColors.primaryRed)
            )
          : null,
    ),
    validator: validator,
  );
}

