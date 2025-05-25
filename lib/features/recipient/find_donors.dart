import 'package:bds/app/theme/app_colors.dart';
import 'package:bds/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import '../../core/widgets/hero_section.dart';
// import '../../app/theme/app_text_styles.dart';

class FindDonors extends StatefulWidget {
  const FindDonors({super.key});

  @override
  State<FindDonors> createState() => _FindDonorsState();
}

class _FindDonorsState extends State<FindDonors> {
  String? selectedBloodGroup;

  final List<Map<String, dynamic>> donors = [
    {
      'name': 'John Doe',
      'bloodType': 'A+',
      'availability': true,
      'location': 'New York',
      'lastDonationDate': '2023-10-01',
    'contact': '+255 712 345 678' // replaced email with Tanzanian phone number
    },
    {
      'name': 'Jane Smith',
      'bloodType': 'B-',
      'availability': false,
      'location': 'Los Angeles',
      'lastDonationDate': '2023-09-15',
    'contact': '+255 713 456 789'
    },
    {
      'name': 'Alice Johnson',
      'bloodType': 'O+',
      'availability': true,
      'location': 'Chicago',
      'lastDonationDate': '2023-08-20',
    'contact': '+255 714 567 890'
    },
    {
      'name': 'Bob Brown',
      'bloodType': 'AB-',
      'availability': true,
      'location': 'Houston',
      'lastDonationDate': '2023-07-10',
    'contact': '+255 715 678 901'
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

  String? selectedLocation;
  final List<String> locations = [
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
  ];

  List<Map<String, dynamic>> get filteredDonors {
    return donors.where((donor) {
      final matchesBloodType = selectedBloodGroup == null || donor['bloodType'] == selectedBloodGroup;
      final matchesLocation = selectedLocation == null || donor['location'] == selectedLocation;
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
                                       
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedLocation,
                      decoration: InputDecoration(
                        labelText: 'Select Location',
                        prefixIcon: Icon(Icons.location_on,
                          color: AppColors.primaryRed,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.primaryRed)
                        ),
                      ),
                      items: locations.map((location) {
                        return DropdownMenuItem(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedLocation = value;
                        });
                      },
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
    );
  }
}

 

extension _FindDonorsStateDonorCard on _FindDonorsState {
  Widget _buildDonorCard(Map<String, dynamic> donor) {
    return Card(
      elevation: 4,
      color: Colors.white, 
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
            ),
            SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip(
                  icon: Icons.location_on,
                  text: donor['bloodType'] ?? 'Unknown',
                ),
                _buildInfoChip(
                  icon: Icons.location_on,
                  text: donor['location'] ?? 'Unknown',
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Last Donation: ${donor['lastDonationDate'] ?? 'N/A'}',
              style: AppTextStyles.body.copyWith(
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: donor['availability'] ? (){
                      showDialog(
                        context: context, 
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text('Contact Donor',
                              style: AppTextStyles.subheading,
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Contact Number: ',
                                style: AppTextStyles.bodyBold,
                                ),
                                SizedBox(height: 8,),
                                Text(
                                  donor['contact'],
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.primaryRed
                                  ),
                                ),
                                SizedBox(height: 16,),
                                Text(
                                  'Do you want to call this donor?',
                                  style: AppTextStyles.body,
                                )
                              ],
                            ),
                            // Text('Call ${donor['name']} at ${donor['contact']}?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }, 
                                child: Text('Cancel'),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primaryRed,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }, 
                                child: Text('Call'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  textStyle: AppTextStyles.action,
                                ),
                              ),
                              ),
                            ],
                          );
                        });
                    } : null,
                     child: Text('Contact Donor'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius:BorderRadius.circular(12),
                        ),
                      ),
                     ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryRed, size: 16),
          SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.body,
          ),
        ],
      ),
    );
  }
}
