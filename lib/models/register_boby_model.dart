import 'package:bds/models/location.dart'; // <-- Use the shared Location

class RegisterBody {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String bloodType;
  Location? location;

  RegisterBody({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.bloodType,
    this.location,
  });

  factory RegisterBody.fromJson(Map<String, dynamic> json) {
    return RegisterBody(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      bloodType: json['blood_type'],
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['password'] = password;
    data['blood_type'] = bloodType;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    return data;
  }
}

// Define _selectedBloodType or replace it with a valid variable/value
final String? selectedBloodType = ''; // Replace with actual value or logic

// Example values for demonstration; replace with actual data as needed
final String name = 'John Doe';
final String email = 'john@example.com';
final String phone = '1234567890';
final String password = 'password123';
final Location location = Location(
  lat: 0.0,
  lng: 0.0,
  address: '123 Main St',
  name: 'Home',
  url: 'http://example.com',
  district: 'District',
  region: 'Region',
  country: 'Country',
);

final Map<String, dynamic> body = {
  'name': name,
  'email': email,
  'phone': phone,
  'password': password,
  'location': location.toJson(),
  // Only add blood_type if selected and not empty
  if (selectedBloodType?.isNotEmpty == true)
    'blood_type': selectedBloodType,
};
