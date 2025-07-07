// Импорты для работы с различными компонентами приложения
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

/// Экран со списком мест/достопримечательностей
/// Отображает Google Maps с маркерами и прокручиваемый список карточек мест
class PlacesListScreen extends StatefulWidget {
  @override
  _PlacesListScreenState createState() => _PlacesListScreenState();
}

/// Состояние экрана PlacesListScreen
/// StatefulWidget позволяет экрану изменять свое состояние (например, загружать данные)
class _PlacesListScreenState extends State<PlacesListScreen> {
  // Список мест для отображения
  List<Place> places = [];

  // Флаг показывает, идет ли сейчас загрузка данных
  bool isLoading = true;

  // Контроллер Google Maps для управления картой программно
  GoogleMapController? _mapController;

  // Текущая позиция пользователя (широта и долгота)
  Position? _currentPosition;

  // Набор маркеров для отображения на карте
  Set<Marker> _markers = {};

  /// Метод вызывается один раз при создании виджета
  /// Здесь инициализируем начальные данные
  @override
  void initState() {
    super.initState();
    _initializeLocation(); // Запускаем получение местоположения
  }

  /// Получаем текущее местоположение пользователя и загружаем близкие места
  Future<void> _initializeLocation() async {
    // Получаем текущую позицию через сервис локации
    final position = await LocationService.getCurrentLocation();

    if (position != null) {
      // Обновляем состояние с новой позицией
      setState(() {
        _currentPosition = position;
        _addCurrentLocationMarker(position); // Добавляем маркер текущего местоположения
      });

      // Если карта уже создана, перемещаем камеру к текущему местоположению
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            14, // Уровень зума (14 - средний масштаб города)
          ),
        );
      }

      // Загружаем места рядом с текущим местоположением
      await _loadPlaces();
    }
  }

  /// Добавляем синий маркер для текущего местоположения пользователя
  void _addCurrentLocationMarker(Position position) {
    _markers.add(
      Marker(
        markerId: MarkerId('current_location'), // Уникальный ID маркера
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: 'Ваше местоположение'), // Подсказка при нажатии
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), // Синий маркер
      ),
    );
  }

  /// Загружаем список мест рядом с текущим местоположением
  Future<void> _loadPlaces() async {
    // Если нет текущего местоположения, выходим
    if (_currentPosition == null) return;

    print('[DEBUG] Загружаем места...');

    // Вызываем API для получения близких мест
    final loadedPlaces = await PlacesApiService.getNearbyPlaces(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );

    print('[DEBUG] Загружено мест: ${loadedPlaces.length}');

    // Обновляем состояние с загруженными местами
    setState(() {
      places = loadedPlaces;
      isLoading = false; // Убираем индикатор загрузки
    });

    // Добавляем маркеры для всех загруженных мест
    _addPlaceMarkers(loadedPlaces);
    setState(() {}); // Обновляем UI
  }

  /// Добавляем красные маркеры для каждого места на карте
  void _addPlaceMarkers(List<Place> places) {
    Set<Marker> newMarkers = {};

    // Сохраняем маркер текущего местоположения (если есть)
    final currentLocationMarker = _markers
        .where((marker) => marker.markerId.value == 'current_location')
        .firstOrNull;
    if (currentLocationMarker != null) {
      newMarkers.add(currentLocationMarker);
    }

    // Добавляем маркер для каждого места
    for (Place place in places) {
      print('[DEBUG] Добавляем маркер для места: ${place.name} (${place.lat}, ${place.lng})');
      newMarkers.add(
        Marker(
          markerId: MarkerId('place_${place.id}'), // Уникальный ID для каждого места
          position: LatLng(place.lat, place.lng),
          infoWindow: InfoWindow(
            title: place.name,
            snippet: place.desc, // Краткое описание
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed), // Красный маркер
          onTap: () {
            _onMarkerTapped(place); // Обработчик нажатия на маркер
          },
        ),
      );
    }

    // Заменяем старые маркеры новыми
    _markers = newMarkers;
    print('[DEBUG] Всего маркеров: ${_markers.length}');
  }

  /// Обработчик нажатия на маркер места
  /// Показывает уведомление внизу экрана
  void _onMarkerTapped(Place place) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Выбрано место: ${place.name}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Основной метод построения UI экрана
  @override
  Widget build(BuildContext context) {
    // CustomScrollView позволяет создать прокручиваемый экран с разными типами контента
    return CustomScrollView(
      slivers: [
        // SliverToBoxAdapter - обертка для обычных виджетов в CustomScrollView
        SliverToBoxAdapter(
          child: GoogleMapWidget(
            mapController: _mapController,
            currentPosition: _currentPosition,
            markers: _markers,
            // Колбэк вызывается когда Google Map создана
            onMapCreated: (controller) {
              setState(() {
                _mapController = controller; // Сохраняем контроллер для управления картой
              });

              // Если есть текущее местоположение, перемещаем камеру к нему
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
        // Добавляем список мест под карту
        _buildPlacesSliverList(),
      ],
    );
  }

  /// Строит прокручиваемый список мест
  /// Возвращает разные виджеты в зависимости от состояния загрузки
  Widget _buildPlacesSliverList() {
    // Если данные загружаются, показываем индикатор загрузки
    if (isLoading) {
      return SliverToBoxAdapter(
        child: Container(
          height: 200,
          color: AppTheme.backgroundColor,
          child: Center(
            child: CircularProgressIndicator(
              color: AppTheme.primaryColor, // Крутящийся индикатор загрузки
            ),
          ),
        ),
      );
    }

    // Если места не найдены, показываем сообщение
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

    // Если есть места, показываем список
    // SliverList - эффективный способ отобразить большой список в CustomScrollView
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        // Функция-строитель для каждого элемента списка
            (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: PlaceCard(
              place: places[index], // Передаем место в карточку
              onPressed: () {
                // При нажатии на карточку переходим к детальному экрану
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
        childCount: places.length, // Количество элементов в списке
      ),
    );
  }
}