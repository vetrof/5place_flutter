// Импортируем нужные библиотеки:
// - flutter/material.dart: стандартные элементы интерфейса Flutter (кнопки, тексты, иконки и т.д.)
// - ../models/place.dart: файл с моделью данных "Place" (место, которое отображается в карточке)
// - ../theme/app_theme.dart: настройки цветов и стилей приложения
import 'package:flutter/material.dart';
import '../models/place.dart';
import '../theme/app_theme.dart';
import '../services/places_api_service.dart';

// Виджет (компонент) карточки места, который можно переиспользовать
class PlaceCard extends StatefulWidget {
  final Place place; // Данные конкретного места
  final VoidCallback onPressed; // Действие при нажатии на карточку


  // Конструктор карточки, принимающий данные места и обработчик нажатия
  const PlaceCard({
    Key? key,
    required this.place,
    required this.onPressed,

  }) : super(key: key);

  @override
  State<PlaceCard> createState() => _PlaceCardState();
}

// Внутреннее состояние карточки
class _PlaceCardState extends State<PlaceCard> {
  late bool isFavorite; // Переменная для хранения, в "избранном" ли карточка

  @override
  void initState() {
    super.initState();
    isFavorite = widget.place.isFavorite; // 🔧 берём начальное значение из place

    print('[PlaceCard INIT] ${widget.place.name} → isFavorite: ${widget.place.isFavorite}');
  }

  @override
  Widget build(BuildContext context) {
    // Определяем картинку для карточки:
    // если у места есть фотографии — берём первую
    // если нет — показываем заглушку (пустую картинку)
    final imageUrl = widget.place.photos.isNotEmpty
        ? widget.place.photos[0]
        : 'https://via.placeholder.com/400x300';

    return InkWell(
      onTap: widget.onPressed, // что делать при нажатии на всю карточку
      borderRadius: BorderRadius.circular(16), // скругление краёв при анимации
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8), // отступы сверху и снизу
        decoration: BoxDecoration(
          color: AppTheme.cardColor, // цвет карточки из темы
          borderRadius: BorderRadius.circular(16), // скругление углов
          boxShadow: [ // тень под карточкой
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // выравнивание влево
          children: [
            // Блок с изображением
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)), // скругляем верхние углы
              child: Image.network(
                imageUrl, // ссылка на картинку
                height: 180,
                width: double.infinity, // растягиваем на всю ширину
                fit: BoxFit.cover, // обрезаем, чтобы картинка полностью заполнила область
              ),
            ),

            // Текстовая часть карточки
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16), // внутренние отступы
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Название места
                  Text(
                    widget.place.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 8),

                  // Краткое описание (максимум 2 строки)
                  Text(
                    widget.place.desc,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis, // обрезаем и добавляем "..."
                  ),

                  const SizedBox(height: 12),

                  // Нижняя строка с иконками и данными
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Левая часть: расстояние, тип, цена
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.location_on, size: 18, color: AppTheme.cardIconColor),
                            const SizedBox(width: 1),
                            Text(
                              _formatDistance(widget.place.distance), // форматируем расстояние
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Icon(Icons.visibility, size: 18, color: AppTheme.cardIconColor),
                            const SizedBox(width: 5),
                            Text(
                              widget.place.type, // тип места (например, "кафе")
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Icon(Icons.monetization_on, size: 18, color: AppTheme.cardIconColor),
                            const SizedBox(width: 1),
                            Text(
                              _formatPrice(widget.place.price, widget.place.currency), // форматируем цену
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Правая часть: иконка "избранное"
                      IconButton(
                        onPressed: () async {
                          final success = await PlacesApiService.toggleFavorite(widget.place.id, isFavorite);
                          if (success) {
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Ошибка при обновлении избранного')),
                            );
                          }
                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : AppTheme.cardIconColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Вспомогательная функция: форматируем расстояние в метры или километры
  String _formatDistance(double distance) {
    if (distance < 1000) {
      return '${distance.toStringAsFixed(0)} м';
    } else {
      return '${(distance / 1000).toStringAsFixed(1)} км';
    }
  }

  // Вспомогательная функция: форматируем цену. Если null — пишем "Бесплатно"
  String _formatPrice(double? price, String currency) {
    if (price == null) return 'Нет информации';
    if (price == 0) return 'Бесплатно';
    return '${price.toStringAsFixed(0)} $currency';
  }
}
