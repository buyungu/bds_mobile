import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/widgets/hero_section.dart';
// import '../../app/theme/app_text_styles.dart';
// import '../../app/theme/app_colors.dart';
import '../../data/models/user_model.dart';
import '../../data/mock/mock_data.dart';

class NearbyDonorsScreen extends StatefulWidget {
  const NearbyDonorsScreen({super.key});

  @override
  State<NearbyDonorsScreen> createState() => _NearbyDonorsScreenState();
}

class _NearbyDonorsScreenState extends State<NearbyDonorsScreen> {
  GoogleMapController? _mapController;

  static const LatLng _initialPosition = LatLng(-6.7924, 39.2083); // Dar es Salaam

  late final List<User> nearbyDonors;
  final Set<Marker> _donorMarkers = {};

  @override
  void initState() {
    super.initState();
    nearbyDonors = MockData.donors;
    _setDonorMarkers();
  }

  void _setDonorMarkers() {
    final markers = nearbyDonors.map((donor) {
      return Marker(
        markerId: MarkerId(donor.id),
        position: LatLng(donor.latitude, donor.longitude),
        infoWindow: InfoWindow(title: donor.name, snippet: donor.bloodType),
      );
    }).toSet();

    setState(() {
      _donorMarkers.addAll(markers);
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HeroSection(
            title: 'Nearby Donors',
            subtitle: 'Explore available donors near your location',
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: _initialPosition,
                zoom: 12,
              ),
              markers: _donorMarkers,
              onMapCreated: (controller) {
                _mapController = controller;
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}
