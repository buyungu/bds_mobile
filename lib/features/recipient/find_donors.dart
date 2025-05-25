import 'package:bds/app/theme/app_colors.dart';
import 'package:bds/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/hero_section.dart';
// import '../../app/theme/app_text_styles.dart';

class FindDonors extends StatefulWidget {
  const FindDonors({super.key});

  @override
  State<FindDonors> createState() => _FindDonorsState();
}

class _FindDonorsState extends State<FindDonors> {
  String? selectedBloodGroup;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _locationController = TextEditingController();

  final List<Map<String, dynamic>> donors = [
    {
      'name': 'John Doe',
      'bloodType': 'A+',
      'availability': true,
      'location': 'New York',
      'lastDonationDate': '2023-10-01',
      'email': 'johndoe@gmail.com'
    },
    {
      'name': 'Jane Smith',
      'bloodType': 'B-',
      'availability': false,
      'location': 'Los Angeles',
      'lastDonationDate': '2023-09-15',
      'email': 'jane@gmail.com'
    },
    {
      'name': 'Alice Johnson',
      'bloodType': 'O+',
      'availability': true,
      'location': 'Chicago',
      'lastDonationDate': '2023-08-20',
      'email': 'alice@gmail.com'
    },
    {
      'name': 'Bob Brown',
      'bloodType': 'AB-',
      'availability': true,
      'location': 'Houston',
      'lastDonationDate': '2023-07-10',
      'email': 'bob@gmail.com'
    },
  ];

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
  List<Map<String, dynamic>> get filteredDonors {
    return donors.where((donor) {
      final matchesBloodType = selectedBloodGroup == null || donor['bloodType'] == selectedBloodGroup;
      final matchesLocation = _locationController.text.isEmpty ||
          (donor['location'] as String).toLowerCase().contains(_locationController.text.toLowerCase());
      return matchesBloodType && matchesLocation;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          const HeroSection(title: 'Find Donors', subtitle: 'Search for blood donors in your area'),

          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Filter by Blood Type",
                      style: AppTextStyles.subheading,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: bloodTypes.map((type) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              checkmarkColor: 
                                selectedBloodGroup == type 
                                  ? Colors.white 
                                  : Colors.black,
                              label: Text(type), 
                              selected: selectedBloodGroup == type,
                              onSelected: (selected) {
                                setState(() {
                                  selectedBloodGroup = 
                                    selected ? type : null;
                                });
                              },
                              selectedColor: AppColors.primaryRed,
                              labelStyle: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                color: selectedBloodGroup == type
                                    ? Colors.white
                                    : AppColors.textDark,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                   
                    SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          
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
                                 
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    filteredDonors.isEmpty
                        ? Center(
                            child: Column( 
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'No donors found',
                                  style: AppTextStyles.body.copyWith(
                                    color: Colors.grey[600], 
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Try adjusting your filters or location.',
                                  style: AppTextStyles.body.copyWith(
                                    color: Colors.grey[600], 
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),  
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: filteredDonors.length,
                            itemBuilder: (context, index) {
                              return _buildDonorCard(filteredDonors[index]);
                            },
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
              icon: Icon(suffixIcon, color: AppColors.primaryRed),
            )
          : null,
    ),
    validator: validator,
  );
}

extension _FindDonorsStateDonorCard on _FindDonorsState {
  Widget _buildDonorCard(Map<String, dynamic> donor) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  donor['name'] ?? 'Unknown',
                  style: AppTextStyles.subheading.copyWith(fontSize: 18),
                ),
                Text(
                  donor['bloodType'] ?? 'N/A',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryRed,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: donor['availability'] == true
                        ? AppColors.primaryRed
                        : Colors.grey[400],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    donor['availability'] == true ? 'Available' : 'Unavailable',
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
