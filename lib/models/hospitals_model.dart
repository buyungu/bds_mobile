class HospitalsResponse {
  List<HospitalModel> hospitals;

  HospitalsResponse({required this.hospitals});

  factory HospitalsResponse.fromJson(Map<String, dynamic> json) {
    return HospitalsResponse(
      hospitals: (json['hospitals'] as List<dynamic>?)
              ?.map((v) => HospitalModel.fromJson(v))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hospitals': hospitals.map((v) => v.toJson()).toList(),
    };
  }
}

class HospitalModel {
  int? id;
  String? name;
  String? email;
  Location? location;

  HospitalModel({this.id, this.name, this.email, this.location});

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    return data;
  }
}

class Location {
  double? lat;
  double? lng;
  String? address;
  String? name;
  String? url;
  String? district;
  String? region;
  String? country;

  Location({
    this.lat,
    this.lng,
    this.address,
    this.name,
    this.url,
    this.district,
    this.region,
    this.country,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: (json['lat'] is int) ? (json['lat'] as int).toDouble() : json['lat'],
      lng: (json['lng'] is int) ? (json['lng'] as int).toDouble() : json['lng'],
      address: json['address'],
      name: json['name'],
      url: json['url'],
      district: json['district'],
      region: json['region'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
      'address': address,
      'name': name,
      'url': url,
      'district': district,
      'region': region,
      'country': country,
    };
  }
}