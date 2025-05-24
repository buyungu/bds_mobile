import 'user_model.dart';

class BloodRequest {
  final String id;
  final User requester;
  final String hospital;
  final int quantity;
  final String urgency; // e.g. 'Low', 'Medium', 'High'
  final String status;  // e.g. 'Open', 'Fulfilled', 'Partial'
  final DateTime createdAt;

  BloodRequest({
    required this.id,
    required this.requester,
    required this.hospital,
    required this.quantity,
    required this.urgency,
    required this.status,
    required this.createdAt,
  });

  factory BloodRequest.empty() {
    return BloodRequest(
      id: '',
      requester: User(
        id: '',
        name: '',
        bloodType: '',
        location: '',
        latitude: 0.0,
        longitude: 0.0,
      ),
      hospital: '',
      quantity: 0,
      urgency: '',
      status: '',
      createdAt: DateTime.now(),
    );

}
}
