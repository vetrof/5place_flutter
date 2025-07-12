import 'package:flutter/material.dart';

class RandomTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Случайные места')),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Здесь будут случайные места'),
            SizedBox(height: 16),
            Image.asset('assets/images.jpeg'),
            SizedBox(height: 16),
            Image.network("https://img1.akspic.ru/previews/1/6/0/6/7/176061/176061-yablochnyj_pejzazh-yabloko-illustracia-prirodnyj_landshaft-purpur-500x.jpg", width: 200)
          ],
        ),
      ),
    );
  }
}
