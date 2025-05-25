import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'О приложении',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildAppLogo(),
            SizedBox(height: 24),
            _buildAppInfo(),
            SizedBox(height: 32),
            _buildDescriptionCard(),
            SizedBox(height: 20),
            _buildFeaturesCard(),
            SizedBox(height: 20),
            _buildContactCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue[400]!, Colors.blue[600]!],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        Icons.place,
        size: 50,
        color: Colors.white,
      ),
    );
  }

  Widget _buildAppInfo() {
    return Column(
      children: [
        Text(
          AppConstants.appName,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Версия ${AppConstants.appVersion}',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionCard() {
    return _buildInfoCard(
      'О приложении',
      '5Place - это ваш персональный гид по интересным местам. Приложение поможет вам найти удивительные локации поблизости, сохранить понравившиеся места в избранное и построить к ним маршрут.',
    );
  }

  Widget _buildFeaturesCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Возможности',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          _buildFeatureItem(Icons.map, 'Карта мест', 'Просматривайте интересные места на карте'),
          _buildFeatureItem(Icons.favorite, 'Избранное', 'Сохраняйте понравившиеся места'),
          _buildFeatureItem(Icons.directions, 'Навигация', 'Прокладывайте маршруты к местам'),
          _buildFeatureItem(Icons.history, 'История', 'Отслеживайте посещенные места'),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return _buildInfoCard(
      'Контакты',
      'Email: ${AppConstants.supportEmail}\nСайт: ${AppConstants.website}',
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppTheme.cardColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 15,
          offset: Offset(0, 4),
        ),
      ],
    );
  }
}