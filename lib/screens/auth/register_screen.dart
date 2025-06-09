import 'package:bds/controllers/auth_controller.dart';
import 'package:bds/controllers/location_controller.dart';
import 'package:bds/models/register_boby_model.dart';
import 'package:bds/routes/route_helper.dart';
import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_text_styles.dart';
import 'package:bds/widgets/custom_button.dart';
import 'package:bds/widgets/hero_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _bloodTypeController = TextEditingController();

  bool _obscurePassword = true;

  final authController = Get.find<AuthController>();
  final locationController = Get.find<LocationController>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _bloodTypeController.dispose();
    super.dispose();
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    final location = locationController.selectedLocation.value;

    if (location == null) {
      Get.snackbar('Error', 'Please select a location');
      return;
    }

    final registerBody = RegisterBoby(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text.trim(),
      bloodType: _bloodTypeController.text.trim(),
      location: location,
    );

    final result = await authController.register(registerBody);
    if (result.isSuccess) {
      Get.offAllNamed(RouteHelper.getInitial());
    } else {
      Get.snackbar("Registration Failed", result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          const HeroSection(title: 'Register', subtitle: 'Join and help save lives'),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      _buildTextFormField(
                        controller: _nameController,
                        label: "Name",
                        icon: Icons.person,
                        validator: _requiredValidator,
                      ),
                      const SizedBox(height: 20),
                      _buildTextFormField(
                        controller: _emailController,
                        label: "Email",
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: _emailValidator,
                      ),
                      const SizedBox(height: 20),
                      _buildTextFormField(
                        controller: _phoneController,
                        label: "Phone",
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: _requiredValidator,
                      ),
                      const SizedBox(height: 20),
                      _buildTextFormField(
                        controller: _bloodTypeController,
                        label: "Blood Type",
                        icon: Icons.bloodtype,
                        validator: _requiredValidator,
                      ),
                      const SizedBox(height: 20),
                      _buildTextFormField(
                        controller: _passwordController,
                        label: "Password",
                        icon: Icons.lock,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                            color: AppColors.primaryRed,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.length < 3) {
                            return 'Password must be at least 3 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TypeAheadField<Map<String, dynamic>>(
                        suggestionsCallback: (pattern) async {
                          return await Get.find<LocationController>().getPlaceSuggestions(pattern);
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion['description']),
                          );
                        },
                        onSelected: (suggestion) async {
                          await Get.find<LocationController>().selectPlace(suggestion['place_id']);
                        },
                        builder: (context, controller, focusNode) {
                          controller.text = Get.find<LocationController>().locationTextController.text;
                          controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: controller.text.length),
                          );

                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              labelText: 'Location',
                               prefixIcon: Icon(Icons.location_on, color: AppColors.primaryRed),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppColors.primaryRed),
                              ),
                            ),
                            onChanged: (value) {
                              Get.find<LocationController>().locationTextController.text = value;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      GetBuilder<AuthController>(builder: (controller) {
                        return CustomButton(
                          label: controller.isLoading ? 'Registering...' : 'Register',
                          onPressed: _register,
                        );
                      }),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Get.toNamed(RouteHelper.getLogin());
                        },
                        child: Text(
                          'Already have an account? Sign in',
                          style: AppTextStyles.bodyBold.copyWith(
                            color: AppColors.primaryRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    Widget? suffixIcon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryRed),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryRed),
        ),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) return 'This field is required';
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Enter a valid email';
    return null;
  }
}
