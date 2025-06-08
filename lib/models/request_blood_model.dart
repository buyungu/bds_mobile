class RequestBloodModel {
  final int id;
  final int hospitalId;
  final String bloodType;
  final int quantity;
  final String urgency;
  final String status;

  RequestBloodModel({
    required this.id,
    required this.hospitalId,
    required this.bloodType,
    required this.quantity,
    required this.urgency,
    required this.status,
  });

  factory RequestBloodModel.fromJson(Map<String, dynamic> json) {
    return RequestBloodModel(
      id: json['id'],
      hospitalId: json['hospital_id'],
      bloodType: json['blood_type'],
      quantity: json['quantity'],
      urgency: json['urgency'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hospital_id'] = this.hospitalId;
    data['blood_type'] = this.bloodType;
    data['quantity'] = this.quantity;
    data['urgency'] = this.urgency;
    return data;
  }
}
