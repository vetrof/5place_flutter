import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../utils/constants.dart';

class GoogleMapWidget extends StatelessWidget {
  final GoogleMapController? mapController;
  final Position? currentPosition;
  final Set<Marker> markers;
  final Function(GoogleMapController) onMapCreated;

  const GoogleMapWidget({
    Key? key,
    required this.mapController,
    required this.currentPosition,
    required this.markers,
    required this.onMapCreated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GoogleMap(
          onMapCreated: onMapCreated,
          initialCameraPosition: CameraPosition(
            target: currentPosition != null
                ? LatLng(currentPosition!.latitude, currentPosition!.longitude)
                : LatLng(AppConstants.defaultLat, AppConstants.defaultLng),
            zoom: 12,
          ),
          markers: markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          compassEnabled: true,
          mapToolbarEnabled: false,
        ),
      ),
    );
  }
}