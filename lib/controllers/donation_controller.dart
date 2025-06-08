import 'package:get/get.dart';
import 'package:bds/data/repository/donation_repo.dart';
import 'package:bds/models/donation_response_model.dart';

class DonationController extends GetxController {
  final DonationRepo donationRepo ;

  DonationController({
    required this.donationRepo,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<DonationResponse> donate(int bloodRequestId) async {
    _isLoading = true;
    update();

    late DonationResponse donationResponse;

    try {
      Response response = await donationRepo.donate(bloodRequestId);

      if (response.statusCode == 200) {
        donationResponse = DonationResponse.fromJson(response.body);
        if (!donationResponse.success) {
          print('${donationResponse.message}');
        } else {
          print('${donationResponse.data}');
        }
      } else {
        print("Error: ${response.statusText}");
        donationResponse = DonationResponse(success: false, message: 'Server error', data: null);
      }
    } catch (e) {
      print("Exception: $e");
      donationResponse = DonationResponse(success: false, message: 'Exception occurred', data: null);
    }

    _isLoading = false;
    update();
    return donationResponse;
  }
}