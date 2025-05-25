import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../models/place.dart';
import '../../services/location_service.dart';
import '../../services/places_api_service.dart';
import '../../widgets/place_card.dart';
import '../../widgets/google_map_widget.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';

class PlacesListScreen extends StatefulWidget {
  @override
  _PlacesListScreenState createState() => _PlacesListScreenState();
}

class _PlacesListScreenState extends State<PlacesListScreen> {
  List<Place> places = [];
  bool isLoading = true;
  GoogleMapController? _mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    final position = await LocationService.getCurrentLocation();
    if (position != null) {
      setState(() {
        _currentPosition = position;
        _markers.add(
          Marker(
            markerId: MarkerId('current_location'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: InfoWindow(title: 'Ваше местоположение'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        );
      });

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            14,
          ),
        );
      }

      await _loadPlaces();
    }
  }

  Future<void> _loadPlaces() async {
    if (_currentPosition == null) return;

    final loadedPlaces = await PlacesApiService.getNearbyPlaces(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );

    setState(() {
      places = loadedPlaces;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GoogleMapWidget(
          mapController: _mapController,
          currentPosition: _currentPosition,
          markers: _markers,
          onMapCreated: (controller) {
            setState(() {
              _mapController = controller;
            });
          },
        ),
        _buildPlacesList(),
      ],
    );
  }

  Widget _buildPlacesList() {
    return Expanded(
      child: Container(
        color: AppTheme.backgroundColor,
        child: isLoading
            ? Center(
          child: CircularProgressIndicator(
            color: AppTheme.primaryColor,
          ),
        )
            : places.isEmpty
            ? Center(
          child: Text(
            'Места не найдены',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
            ),
          ),
        )
            : ListView.builder(
          itemCount: places.length,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            return PlaceCard(place: places[index]);
          },
        ),
      ),
    );
  }
}