import 'package:flutter/material.dart';
import '../../models/place.dart';
import '../../theme/app_theme.dart';

class PlaceDetailScreen extends StatelessWidget {
  final Place place;

  PlaceDetailScreen({required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: _buildContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: _buildImageGallery(),
      ),
      backgroundColor: AppTheme.primaryColor,
      iconTheme: IconThemeData(color: Colors.white),
    );
  }

  Widget _buildImageGallery() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          place.photo.isNotEmpty ? place.photo[0] : 'https://via.placeholder.com/400x300',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 60,
                  color: Colors.grey[500],
                ),
              ),
            );
          },
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              ),
            ),
          ),
        ),
        if (place.photo.length > 1)
          Positioned(
            top: 50,
            right: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.photo_library, size: 16, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    '1/${place.photo.length}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            place.name,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 20, color: AppTheme.primaryColor),
              SizedBox(width: 4),
              Text(
                '${place.distance.toStringAsFixed(1)} км от вас',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Описание',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          Text(
            place.desc,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
              height: 1.6,
            ),
          ),
          SizedBox(height: 30),
          _buildRouteButton(context),
          SizedBox(height: 20),
          _buildAdditionalInfo(),
        ],
      ),
    );
  }

  Widget _buildRouteButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _openRoute(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions, size: 24),
            SizedBox(width: 8),
            Text(
              'Построить маршрут',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Дополнительная информация',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          _buildInfoRow('ID места:', place.id.toString()),
          _buildInfoRow('Город:', place.cityName),
          _buildInfoRow('Координаты:', place.geom),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openRoute(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Открытие карт для построения маршрута...'),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}