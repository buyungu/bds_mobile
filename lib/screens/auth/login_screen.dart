import 'package:bds/utils/app_colors.dart';
import 'package:bds/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/hero_section.dart';
// import '../../app/theme/app_text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
    final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          const HeroSection(title: 'Login', subtitle: 'Acces your account'),

          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          
                          SizedBox(height: 20,),
                          _buildTextFormField(
                            controller: _emailController, 
                            label: "email", 
                            icon: Icons.email,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20,),
                          _buildTextFormField(
                            controller: _passwordController, 
                            label: "password", 
                            icon: Icons.lock,
                            suffixIcon: Icons.visibility,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          
                          SizedBox(height: 40,),
                          CustomButton(
                            label: 'Login',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Perform login action
                                Navigator.pushNamed(context, '/home'); // Navigate to Home after login
                              }
                            },
                          ),

                          SizedBox(height: 20,),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register'); // Navigate to Login after registration
                            }, 
                            child: Text(
                              'Don\'t have an account? Sign up',
                              style: AppTextStyles.bodyBold.copyWith(
                                color: AppColors.primaryRed
                              ),
                            ),
                          ),   
                            
                        ],
                      ))
                  ],
                )
              ]
              )
            ),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),

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
