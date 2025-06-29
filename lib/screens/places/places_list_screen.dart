import 'package:five_place_app/screens/places/place_detail_screen.dart';
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
        _addCurrentLocationMarker(position);
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

  void _addCurrentLocationMarker(Position position) {
    _markers.add(
      Marker(
        markerId: MarkerId('current_location'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: 'Ваше местоположение'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
  }

  Future<void> _loadPlaces() async {
    if (_currentPosition == null) return;

    print('[DEBUG] Загружаем места...');
    final loadedPlaces = await PlacesApiService.getNearbyPlaces(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );

    print('[DEBUG] Загружено мест: ${loadedPlaces.length}');

    setState(() {
      places = loadedPlaces;
      isLoading = false;
    });

    _addPlaceMarkers(loadedPlaces);
    setState(() {});
  }

  void _addPlaceMarkers(List<Place> places) {
    Set<Marker> newMarkers = {};

    final currentLocationMarker = _markers
        .where((marker) => marker.markerId.value == 'current_location')
        .firstOrNull;
    if (currentLocationMarker != null) {
      newMarkers.add(currentLocationMarker);
    }

    for (Place place in places) {
      print('[DEBUG] Добавляем маркер для места: ${place.name} (${place.lat}, ${place.lng})');
      newMarkers.add(
        Marker(
          markerId: MarkerId('place_${place.id}'),
          position: LatLng(place.lat, place.lng),
          infoWindow: InfoWindow(
            title: place.name,
            snippet: place.desc,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          onTap: () {
            _onMarkerTapped(place);
          },
        ),
      );
    }

    _markers = newMarkers;
    print('[DEBUG] Всего маркеров: ${_markers.length}');
  }

  void _onMarkerTapped(Place place) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Выбрано место: ${place.name}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: GoogleMapWidget(
            mapController: _mapController,
            currentPosition: _currentPosition,
            markers: _markers,
            onMapCreated: (controller) {
              setState(() {
                _mapController = controller;
              });

              if (_currentPosition != null) {
                controller.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                    14,
                  ),
                );
              }
            },
          ),
        ),
        _buildPlacesSliverList(),
      ],
    );
  }

  Widget _buildPlacesSliverList() {
    if (isLoading) {
      return SliverToBoxAdapter(
        child: Container(
          height: 200,
          color: AppTheme.backgroundColor,
          child: Center(
            child: CircularProgressIndicator(
              color: AppTheme.primaryColor,
            ),
          ),
        ),
      );
    }

    if (places.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          height: 200,
          color: AppTheme.backgroundColor,
          child: Center(
            child: Text(
              'Места не найдены',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: PlaceCard(
              place: places[index],
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlaceDetailScreen(place: places[index]),
                  ),
                );
              },
            ),
          );
        },
        childCount: places.length,
      ),
    );
  }
}
