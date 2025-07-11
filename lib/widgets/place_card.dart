// widgets/place_card.dart
import 'package:flutter/material.dart';
import '../models/place.dart';

class PlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback onTap;

  const PlaceCard({
    Key? key,
    required this.place,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[300],
          ),
          child: Icon(Icons.place, size: 30), // Пока вместо картинки
        ),
        title: Text(place.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(place.description),
            Row(
              children: [
                Icon(Icons.star, color: Colors.orange, size: 16),
                Text(' ${place.rating}'),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.favorite_border),
          onPressed: () {
            // Пока просто показываем сообщение
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Добавлено в избранное!')),
            );
          },
        ),
        onTap: onTap,
      ),
    );
  }
}