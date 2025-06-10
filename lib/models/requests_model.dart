class Request {
  List<RequestModel>? requests;

  Request({this.requests});

  Request.fromJson(Map<String, dynamic> json) {
    if (json['requests'] != null) {
      requests = <RequestModel>[];
      json['requests'].forEach((v) {
        requests!.add(new RequestModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.requests != null) {
      data['requests'] = this.requests!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RequestModel {
  int? id;
  int? recipientId;
  int? hospitalId;
  String? bloodType;
  int? quantity;
  String? status;
  bool? hasDonated;
  String? urgency;
  String? createdAt;
  String? updatedAt;
  Recipient? recipient;
  Hospital? hospital;
  List<Donors>? donors;


  RequestModel(
      {this.id,
      this.recipientId,
      this.hospitalId,
      this.bloodType,
      this.quantity,
      this.status,
      this.hasDonated,
      this.urgency,
      this.createdAt,
      this.updatedAt,
      this.recipient,
      this.hospital,
      this.donors});

  RequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    recipientId = json['recipient_id'];
    hospitalId = json['hospital_id'];
    bloodType = json['blood_type'];
    quantity = json['quantity'];
    status = json['status'];
    hasDonated = json['has_donated'];
    urgency = json['urgency'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    recipient = json['recipient'] != null
        ? new Recipient.fromJson(json['recipient'])
        : null;
    hospital = json['hospital'] != null
        ? new Hospital.fromJson(json['hospital'])
        : null;
    if (json['donors'] != null) {
      donors = <Donors>[];
      json['donors'].forEach((v) {
        donors!.add(new Donors.fromJson(v));
      });
    }    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['recipient_id'] = this.recipientId;
    data['hospital_id'] = this.hospitalId;
    data['blood_type'] = this.bloodType;
    data['quantity'] = this.quantity;
    data['status'] = this.status;
    data['has_donated'] = this.hasDonated;
    data['urgency'] = this.urgency;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.recipient != null) {
      data['recipient'] = this.recipient!.toJson();
    }
    if (this.hospital != null) {
      data['hospital'] = this.hospital!.toJson();
    }
    if (this.donors != null) {
      data['donors'] = this.donors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Recipient {
  int? id;
  String? name;
  String? email;
  String? avatar;
  String? phone;
  Location? location;

  Recipient(
      {this.id, this.name, this.email, this.avatar, this.phone, this.location});

  Recipient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
    phone = json['phone'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['phone'] = this.phone;
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

class Hospital {
  int? id;
  String? name;
  String? email;
  Location? location;

  Hospital({this.id, this.name, this.email, this.location});

  Hospital.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    return data;
  }
}

class Donors {
  int? id;
  String? name;
  String? email;
  String? avatar;
  String? phone;
  Location? location;
  Pivot? pivot;

  Donors(
      {this.id,
      this.name,
      this.email,
      this.avatar,
      this.phone,
      this.location,
      this.pivot});

  Donors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
    phone = json['phone'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['phone'] = this.phone;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? bloodRequestId;
  int? donorId;
  String? createdAt;
  String? updatedAt;

  Pivot({this.bloodRequestId, this.donorId, this.createdAt, this.updatedAt});

  Pivot.fromJson(Map<String, dynamic> json) {
    bloodRequestId = json['blood_request_id'];
    donorId = json['donor_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['blood_request_id'] = this.bloodRequestId;
    data['donor_id'] = this.donorId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
