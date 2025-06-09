import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:bds/models/register_boby_model.dart'; // Assuming this has your Location model

class LocationController extends GetxController {
  final String apiKey = 'AIzaSyD75dUgw57R6h0jaxGcmwOamWBOinq2FXE'; // Set this

  Rx<Location?> selectedLocation = Rx<Location?>(null);
  TextEditingController locationTextController = TextEditingController();

  Future<List<Map<String, dynamic>>> getPlaceSuggestions(String input) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&components=country:tz');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final predictions = json.decode(response.body)['predictions'];
      return List<Map<String, dynamic>>.from(predictions);
    } else {
      return [];
    }
  }


  Future<void> selectPlace(String placeId) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = json.decode(response.body)['result'];

      selectedLocation.value = Location(
        lat: result['geometry']['location']['lat'],
        lng: result['geometry']['location']['lng'],
        address: result['formatted_address'],
        name: result['name'],
        url: result['url'],
        district: _getAddressComponent(result, 'administrative_area_level_2'),
        region: _getAddressComponent(result, 'administrative_area_level_1'),
        country: _getAddressComponent(result, 'country'),
      );

      locationTextController.text = result['formatted_address'];
    }
  }

  String _getAddressComponent(Map result, String type) {
    try {
      return result['address_components']
          .firstWhere((comp) => comp['types'].contains(type))['long_name'];
    } catch (e) {
      return '';
    }
  }
}
