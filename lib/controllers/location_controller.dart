import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:bds/models/location.dart';

class LocationController extends GetxController {
  // Replace with your valid Google API key.
  final String apiKey = 'Your google API key';

  // Reactive variable holding the selected Location.
  Rx<Location?> selectedLocation = Rx<Location?>(null);

  // Controller to manage the location text input.
  TextEditingController locationTextController = TextEditingController();

  /// Uses the Google Place Autocomplete API to obtain place suggestions.
  Future<List<Map<String, dynamic>>> getPlaceSuggestions(String input) async {
    try {
      final uri = Uri.https(
        'maps.googleapis.com',
        '/maps/api/place/autocomplete/json',
        {
          'input': input,
          'key': apiKey,
          'components': 'country:tz', // Restrict suggestions to Tanzania.
        },
      );

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final predictions = data['predictions'] as List;
          return predictions.cast<Map<String, dynamic>>();
        } else {
          print("Autocomplete Error: ${data['status']} - ${data['error_message']}");
          return [];
        }
      } else {
        print("Request failed with status: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Exception in getPlaceSuggestions: $e");
      return [];
    }
  }

  /// Calls the Google Place Details API to retrieve details for the selected place.
  Future<void> selectPlace(String placeId) async {
    try {
      final uri = Uri.https(
        'maps.googleapis.com',
        '/maps/api/place/details/json',
        {
          'place_id': placeId,
          'key': apiKey,
        },
      );

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final result = data['result'];

          // Extract necessary data while ensuring proper types.
          double lat = (result['geometry']['location']['lat'] as num).toDouble();
          double lng = (result['geometry']['location']['lng'] as num).toDouble();
          String formattedAddress = result['formatted_address'] ?? '';
          String name = result['name'] ?? '';
          // Ensure url is a non-null string.
          String url = result['url'] ?? '';

          String district = _getAddressComponent(result, 'administrative_area_level_2');
          String region = _getAddressComponent(result, 'administrative_area_level_1');
          String country = _getAddressComponent(result, 'country');

          // Create an instance of Location using your provided model.
          selectedLocation.value = Location(
            lat: lat,
            lng: lng,
            address: formattedAddress,
            name: name,
            url: url,
            district: district,
            region: region,
            country: country,
          );

          // Update the text controller for your UI.
          locationTextController.text = formattedAddress;
          update();
          print("Selected location: ${selectedLocation.value?.toJson()}");
        } else {
          print("Place Details Error: ${data['status']} - ${data['error_message']}");
        }
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception in selectPlace: $e");
    }
  }

  /// Helper method to extract a specific address component from the API result.
  String _getAddressComponent(Map result, String type) {
    try {
      final List addressComponents = result['address_components'] as List;
      final component = addressComponents.firstWhere(
        (comp) => (comp['types'] as List).contains(type),
        orElse: () => null,
      );
      if (component != null) {
        return component['long_name'] ?? '';
      } else {
        return '';
      }
    } catch (e) {
      print("Error retrieving $type: $e");
      return '';
    }
  }
}
