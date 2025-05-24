import 'user_model.dart';
import 'blood_request_model.dart';

class Donation {
  final String id;
  final User donor;
  final BloodRequest request;
  final DateTime donatedAt;

  Donation({
    required this.id,
    required this.donor,
    required this.request,
    required this.donatedAt,
  });
}
