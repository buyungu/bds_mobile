class ProfileModel {
  User? user;

  ProfileModel({this.user});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? avatar;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? phone;
  Location? location;
  String? role;
  String? bloodType;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
      this.avatar,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.phone,
      this.location,
      this.role,
      this.bloodType,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    phone = json['phone'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    role = json['role'];
    bloodType = json['blood_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['avatar'] = this.avatar;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['phone'] = this.phone;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['role'] = this.role;
    data['blood_type'] = this.bloodType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
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
    lat = json['lat'];
    lng = json['lng'];
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