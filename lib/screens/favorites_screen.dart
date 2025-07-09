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

/// Экран со списком избранного
class FavoritePlacesListScreen extends StatefulWidget {
  @override
  _FavoritePlacesListScreenState createState() =>
      _FavoritePlacesListScreenState();
}

/// Состояние экрана FavoritePlacesListScreen
class _FavoritePlacesListScreenState extends State<FavoritePlacesListScreen> {
  // Список мест для отображения
  List<Place> places = [];

  // Флаг, который показывает, идет ли сейчас загрузка данных
  bool isLoading = true;

  /// Метод вызывается один раз при создании виджета
  @override
  void initState() {
    super.initState();
    _initializeLocation(); // Запускаем получение местоположения
  }

  /// Получаем текущее местоположение пользователя и загружаем близкие места
  Future<void> _initializeLocation() async {
    // Получаем текущую позицию через сервис локации
    final position = await LocationService.getCurrentLocation();

    // Загружаем места
    await _loadPlaces();
  }

  /// Загружаем список мест из API
  Future<void> _loadPlaces() async {
    print('[DEBUG] Загружаем места...');

    // Вызываем API для получения избранных мест
    final loadedPlaces = await PlacesApiService.getFavoritePlaces();

    print('[DEBUG] Загружено мест: ${loadedPlaces.length}');

    // Обновляем состояние с загруженными местами
    setState(() {
      places = loadedPlaces;
      isLoading = false; // Убираем индикатор загрузки
    });
  }

  /// Основной метод построения UI экрана
  @override
  Widget build(BuildContext context) {
    // CustomScrollView позволяет создать прокручиваемый экран с разными типами контента
    return CustomScrollView(
      slivers: [
        _buildPlacesSliverList(), // Вставляем виджет с местами
      ],
    );
  }

  /// Строит прокручиваемый список мест
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
