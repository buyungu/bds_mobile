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
