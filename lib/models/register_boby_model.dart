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
