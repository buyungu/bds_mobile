import 'package:bds/data/models/donation_model.dart';

import '../models/blood_request_model.dart';
import '../models/user_model.dart';

class MockData {
  static List<BloodRequest> bloodRequests = [
    BloodRequest(
      id: 'req1',
      requester: User(
        id: 'u1',
        name: 'Anna James',
        bloodType: 'O+',
        location: 'Dar es Salaam',
        latitude: -6.7924,
        longitude: 39.2083,
      ),
      hospital: 'Muhimbili Hospital',
      quantity: 2,
      urgency: 'High',
      status: 'Open',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    BloodRequest(
      id: 'req2',
      requester: User(
        id: 'u2',
        name: 'Michael Omari',
        bloodType: 'A-',
        location: 'Arusha',
        latitude: -3.3869,
        longitude: 36.6820,
      ),
      hospital: 'Mount Meru Hospital',
      quantity: 1,
      urgency: 'Medium',
      status: 'Open',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];


   static List<Donation> donations = [
    Donation(
      id: 'don1',
      donor: donors[0],
      request: bloodRequests[0],
      donatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Donation(
      id: 'don2',
      donor: donors[1],
      request: bloodRequests[1],
      donatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];


  static List<User> donors = [
  User(
    id: 'd1',
    name: 'John Doe',
    bloodType: 'O+',
    location: 'Dar es Salaam',
    latitude: -6.7924,
    longitude: 39.2083,
  ),
  User(
    id: 'd2',
    name: 'Jane Smith',
    bloodType: 'A-',
    location: 'Arusha',
    latitude: -3.3869,
    longitude: 36.6820,
  ),
  User(
    id: 'd3',
    name: 'Ali Hassan',
    bloodType: 'B+',
    location: 'Mwanza',
    latitude: -2.5164,
    longitude: 32.9172,
  ),
];

}
