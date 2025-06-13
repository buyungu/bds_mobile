class RegisterBoby {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String bloodType;
  final Location location;

  RegisterBoby({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.bloodType,
    required this.location,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
        "blood_type": bloodType,
        "location": location.toJson(),
      };
}

class Location {
  final double lat;
  final double lng;
  final String address;
  final String name;
  final String url;
  final String district;
  final String region;
  final String country;

  Location({
    required this.lat,
    required this.lng,
    required this.address,
    required this.name,
    required this.url,
    required this.district,
    required this.region,
    required this.country,
  });

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
        "address": address,
        "name": name,
        "url": url,
        "district": district,
        "region": region,
        "country": country,
      };
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
