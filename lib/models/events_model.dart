class Event {
  late List<EventModel> _events;
  List<EventModel> get events => _events;

  Event({required events}){
    this._events = events;
  }

  Event.fromJson(Map<String, dynamic> json) {
    if (json['events'] != null) {
      _events = <EventModel>[];
      json['events'].forEach((v) {
        _events!.add(new EventModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._events != null) {
      data['events'] = this._events!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EventModel {
  int? id;
  String? title;
  String? description;
  Null? email;
  Null? image;
  String? status;
  Location? location;
  String? eventDate;
  int? createdBy;
  String? createdAt;
  String? updatedAt;
  User? user;

  EventModel(
      {this.id,
      this.title,
      this.description,
      this.email,
      this.image,
      this.status,
      this.location,
      this.eventDate,
      this.createdBy,
      this.createdAt,
      this.updatedAt,
      this.user});

  EventModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    email = json['email'];
    image = json['image'];
    status = json['status'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    eventDate = json['event_date'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['email'] = this.email;
    data['image'] = this.image;
    data['status'] = this.status;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['event_date'] = this.eventDate;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
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

class User {
  int? id;
  String? name;
  String? email;
  String? phone;

  User({this.id, this.name, this.email, this.phone});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}