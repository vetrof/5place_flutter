import 'package:flutter/material.dart';
import '../models/place.dart';

class PlaceCard extends StatelessWidget {
  final Place place;         // 👉 объект с названием, описанием, фото, рейтингом
  final VoidCallback onTap;  // 👉 действие при нажатии на карточку
  final VoidCallback onToggleFavorite;


  const PlaceCard({
    Key? key,
    required this.place,
    required this.onTap,
    required this.onToggleFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // 👆 НАЖАТИЕ НА КАРТОЧКУ
      child: Card(
        // 📦 КАРТОЧКА
        margin: EdgeInsets.all(8.0), // отступы снаружи карточки
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // скругленные углы
        ),
        elevation: 4, // тень под карточкой
        clipBehavior: Clip.antiAlias, // всё внутри карточки обрезается по краям
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // выравнивание по левому краю
          children: [
            // 🖼 ФОТО СВЕРХУ КАРТОЧКИ
            SizedBox(
              width: double.infinity,
              height: 180,
              child: Image.network(
                place.photos[0], // ссылка на изображение
                fit: BoxFit.cover, // фото масштабируется, заполняя контейнер
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child; // если загружено — показать
                  return Center(
                    child: CircularProgressIndicator(), // пока грузится — индикатор
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(Icons.broken_image, size: 60, color: Colors.grey[700]),
                    ),
                  );
                },
              ),
            ),

            // 📝 ТЕКСТ ПОД ФОТО
            Padding(
              padding: EdgeInsets.all(12), // отступы внутри карточки
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 📝 НАЗВАНИЕ МЕСТА
                  Text(
                    place.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 4),

                  // 📝 ОПИСАНИЕ МЕСТА
                  Text(
                    place.desc,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),

                  SizedBox(height: 8),

                  // ⭐ РЕЙТИНГ + ❤️ КНОПКА "ИЗБРАННОЕ"
                  Row(
                    children: [
                      // ⭐ ЗНАЧОК ЗВЕЗДА
                      Icon(Icons.star, color: Colors.orange, size: 16),

                      SizedBox(width: 4),

                      // ⭐ ТЕКСТ С РЕЙТИНГОМ
                      Text('${place.currency}'),

                      Spacer(), // раздвигает элементы по краям

                      // ❤️ КНОПКА ДОБАВИТЬ В ИЗБРАННОЕ
                      IconButton(
                        // 👇 Выбираем иконку в зависимости от флага
                        icon: Icon(
                          place.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: place.isFavorite ? Colors.red : null, // цвет только если true
                        ),

                        // 👇 Что делать при нажатии
                        onPressed: () {
                          onToggleFavorite(); // 🔁 Меняем флаг через родитель

                          // Показать сообщение — можно поменять текст в зависимости от состояния
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(place.isFavorite
                                  ? 'Добавлено в избранное!'
                                  : 'Удалено из избранного'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
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
}
