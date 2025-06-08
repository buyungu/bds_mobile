class DonationResponse {
  final bool success;
  final String message;
  final DonationData? data;

  DonationResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory DonationResponse.fromJson(Map<String, dynamic> json) {
    return DonationResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? DonationData.fromJson(json['data']) : null,
    );
  }
}

class DonationData {
  final int bloodRequestId;
  final int remainingQuantity;
  final String status;

  DonationData({
    required this.bloodRequestId,
    required this.remainingQuantity,
    required this.status,
  });

  factory DonationData.fromJson(Map<String, dynamic> json) {
    return DonationData(
      bloodRequestId: json['blood_request_id'],
      remainingQuantity: json['remaining_quantity'],
      status: json['status'],
    );
  }
}
