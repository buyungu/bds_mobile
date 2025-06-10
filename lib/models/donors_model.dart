class Donor {
  List<DonorModel>? donors;

  Donor({this.donors});

  Donor.fromJson(Map<String, dynamic> json) {
    if (json['donors'] != null) {
      donors = <DonorModel>[];
      json['donors'].forEach((v) {
        donors!.add(new DonorModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.donors != null) {
      data['donors'] = this.donors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DonorModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? bloodType;
  Location? location;

  DonorModel({this.id, this.name, this.email,this.phone, this.bloodType, this.location});

  DonorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    bloodType = json['blood_type'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['blood_type'] = this.bloodType;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
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

  Location(
      {this.lat,
      this.lng,
      this.address,
      this.name,
      this.url,
      this.district,
      this.region,
      this.country});

  Location.fromJson(Map<String, dynamic> json) {
    lat = double.tryParse(json['lat'].toString());
    lng = double.tryParse(json['lng'].toString());
    address = json['address'];
    name = json['name'];
    url = json['url'];
    district = json['district'];
    region = json['region'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['address'] = this.address;
    data['name'] = this.name;
    data['url'] = this.url;
    data['district'] = this.district;
    data['region'] = this.region;
    data['country'] = this.country;
    return data;
  }
}