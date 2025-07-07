// Подключаем основную библиотеку Flutter для создания интерфейса
import 'package:flutter/material.dart';
// Подключаем наш кастомный виджет для иконок навигации
import '../widgets/nav_icon.dart';
// Подключаем файл с темой приложения (цвета, стили)
import '../theme/app_theme.dart';
// Подключаем файл с константами (неизменяемые значения)
import '../utils/constants.dart';
// Подключаем экраны, которые будут показываться в приложении
import 'places/places_list_screen.dart';
import 'favorites_screen.dart';
import 'history_screen.dart';
import 'about_screen.dart';

// Создаем главный экран приложения
// StatefulWidget означает, что этот виджет может изменяться (у него есть состояние)
class MainScreen extends StatefulWidget {
  @override
  // Эта функция создает объект состояния для нашего виджета
  _MainScreenState createState() => _MainScreenState();
}

// Класс состояния - здесь хранится вся "память" нашего экрана
class _MainScreenState extends State<MainScreen> {
  // Переменная для запоминания какая вкладка сейчас выбрана
  // 0 = первая вкладка, 1 = вторая, и т.д.
  int _selectedIndex = 0;

  // Список всех экранов нашего приложения
  // final означает, что этот список нельзя изменить после создания
  final List<Widget> _screens = [
    PlacesListScreen(),    // Экран 0 - Главная страница
    FavoritesScreen(),     // Экран 1 - Избранное
    HistoryScreen(),       // Экран 2 - История
    AboutScreen(),         // Экран 3 - О приложении
  ];

  // Главная функция - она рисует весь интерфейс
  @override
  Widget build(BuildContext context) {
    // Scaffold - это основа экрана (как каркас дома)
    return Scaffold(
      // AppBar - верхняя панель с заголовком
      appBar: AppBar(
        backgroundColor: Colors.white,        // Делаем фон белым
        elevation: 0,                        // Убираем тень под панелью
        centerTitle: true,                   // Ставим заголовок по центру
        toolbarHeight: 60,                   // Делаем панель высотой 80 пикселей
        automaticallyImplyLeading: false,    // Убираем кнопку "назад" (стрелочку)

        // title - это то, что показывается в заголовке
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🎒 Туристические иконки до логотипа
              Icon(Icons.map, color: Colors.grey, size: 14),              // Карта
              Icon(Icons.museum, color: Colors.grey, size: 14),           // Музей
              Icon(Icons.landscape, color: Colors.grey, size: 14),        // Природа
              Icon(Icons.local_cafe, color: Colors.grey, size: 14),       // Кафе
              Icon(Icons.camera_alt, color: Colors.grey, size: 14),       // Фото
              Icon(Icons.directions_walk, color: Colors.grey, size: 14),  // Пеший маршрут
              Icon(Icons.explore, color: Colors.grey, size: 14),          // Компас
              Icon(Icons.hiking, color: Colors.grey, size: 14),           // Поход (если FontAwesome, иначе заменить)

              SizedBox(width: 10),

              // 📍 Основной логотип
              Icon(Icons.place, color: Colors.green, size: 18),
              SizedBox(width: 4),
              Text(
                '5Place',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(width: 10),

              // 🎒 Туристические иконки после логотипа
              Icon(Icons.account_balance, color: Colors.grey, size: 14),  // Историческое здание
              Icon(Icons.alt_route, color: Colors.grey, size: 14),        // Маршрут
              Icon(Icons.hotel, color: Colors.grey, size: 14),            // Отель
              Icon(Icons.restaurant, color: Colors.grey, size: 14),       // Ресторан
              Icon(Icons.nature_people, color: Colors.grey, size: 14),    // Прогулки
              Icon(Icons.attractions, color: Colors.grey, size: 14),      // Развлечения
              Icon(Icons.park, color: Colors.grey, size: 14),             // Парк
              Icon(Icons.event, color: Colors.grey, size: 14),            // Событие
            ],
          )


      ),

      // body - основное содержимое экрана
      // Показываем экран в зависимости от выбранной вкладки
      body: _screens[_selectedIndex],

      // bottomNavigationBar - нижняя панель с кнопками
      bottomNavigationBar: Container(
        // decoration - украшение контейнера
        decoration: BoxDecoration(
          boxShadow: [                       // Добавляем тень
            BoxShadow(
              color: Colors.black.withOpacity(0.1),  // Цвет тени (черный с прозрачностью)
              blurRadius: 10,                // Размытие тени
              offset: Offset(0, -2),         // Смещение тени (0 по горизонтали, -2 по вертикали)
            ),
          ],
        ),
        // Сама панель навигации
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,      // Какая вкладка сейчас активна
          onTap: _onItemTapped,             // Функция, которая вызывается при нажатии
          type: BottomNavigationBarType.fixed,  // Фиксированный тип (все вкладки видны)
          backgroundColor: Colors.white,     // Белый фон панели
          selectedItemColor: AppTheme.primaryColor,    // Цвет выбранной вкладки
          unselectedItemColor: Colors.grey[500],       // Цвет невыбранных вкладок

          // Стили для текста выбранной вкладки
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w600,     // Полужирный шрифт
            fontSize: 12,                    // Размер шрифта
          ),
          // Стили для текста невыбранных вкладок
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w500,     // Обычный шрифт
            fontSize: 12,                    // Размер шрифта
          ),

          // Список вкладок
          items: [
            // Первая вкладка - Главная
            BottomNavigationBarItem(
              icon: NavIcon(                 // Наш кастомный виджет иконки
                icon: Icons.place,            // Иконка домика
                index: 0,                    // Номер этой вкладки
                selectedIndex: _selectedIndex,  // Текущая выбранная вкладка
              ),
              label: '5Place',             // Подпись под иконкой
            ),

            // Вторая вкладка - search
            BottomNavigationBarItem(
              icon: NavIcon(                 // Наш кастомный виджет иконки
                icon: Icons.search,            // Иконка домика
                index: 1,                    // Номер этой вкладки
                selectedIndex: _selectedIndex,  // Текущая выбранная вкладка
              ),
              label: 'Поиск',             // Подпись под иконкой
            ),

            // Третья вкладка - История
            BottomNavigationBarItem(
              icon: NavIcon(
                icon: Icons.shuffle,         // Иконка часов
                index: 2,                    // Номер этой вкладки
                selectedIndex: _selectedIndex,
              ),
              label: 'Случайно',
            ),

            BottomNavigationBarItem(
              icon: NavIcon(
                icon: Icons.favorite,        // Иконка сердечка
                index: 3,                    // Номер этой вкладки
                selectedIndex: _selectedIndex,
              ),
              label: 'Избранное',
            ),

            // Четвертая вкладка - О приложении
            BottomNavigationBarItem(
              icon: NavIcon(
                icon: Icons.account_box,            // Иконка информации
                index: 4,                    // Номер этой вкладки
                selectedIndex: _selectedIndex,
              ),
              label: 'Профиль',
            ),
          ],
        ),
      ),
    );
  }

  // Функция, которая вызывается когда пользователь нажимает на вкладку
  void _onItemTapped(int index) {
    // setState говорит Flutter'у: "Я изменил состояние, перерисуй экран!"
    setState(() {
      // Запоминаем какую вкладку выбрал пользователь
      _selectedIndex = index;
    });
  }
}