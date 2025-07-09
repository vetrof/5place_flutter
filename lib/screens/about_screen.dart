import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/login.dart';

class ApiInfo {
  final String message;
  final String version;
  final String swagger;

  ApiInfo({
    required this.message,
    required this.version,
    required this.swagger,
  });

  factory ApiInfo.fromJson(Map<String, dynamic> json) {
    return ApiInfo(
      message: json['message'],
      version: json['version'],
      swagger: json['swagger'],
    );
  }
}

class AboutScreen extends StatefulWidget {
  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  ApiInfo? _apiInfo;
  String? _error;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _loginError;
  bool _isLoadingLogin = false;

  @override
  void initState() {
    super.initState();
    _fetchApiInfo();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _fetchApiInfo() async {
    try {
      final response = await http.get(Uri.parse('${AppConstants.apiBaseUrl}/'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _apiInfo = ApiInfo.fromJson(data);
          _error = null;
        });
      } else {
        setState(() {
          _error = 'Ошибка сервера: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Ошибка запроса: $e';
      });
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoadingLogin = true;
      _loginError = null;
    });

    final token = await AuthService.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    setState(() {
      _isLoadingLogin = false;
    });

    if (token != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Успешный вход! Токен сохранён.')),
      );
    } else {
      setState(() {
        _loginError = 'Ошибка входа. Проверьте email и пароль.';
      });
    }
  }

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
            SizedBox(height: 16),
            _buildApiInfoBlock(),
            SizedBox(height: 32),
            _buildDescriptionCard(),
            SizedBox(height: 20),
            _buildFeaturesCard(),
            SizedBox(height: 20),
            _buildContactCard(),
            SizedBox(height: 20),
            _buildLoginForm(), // 🔥 Добавили форму логина
          ],
        ),
      ),
    );
  }

  Widget _buildApiInfoBlock() {
    if (_error != null) {
      return _buildInfoCard('Инфо о сервере', _error!);
    }

    if (_apiInfo == null) {
      return Center(child: CircularProgressIndicator());
    }

    return _buildInfoCard(
      'Инфо о сервере',
      'Сообщение: ${_apiInfo!.message}\n'
          'Версия: ${_apiInfo!.version}\n'
          'Swagger: ${_apiInfo!.swagger}',
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
      '5Place - это ваш персональный гид по интересным местам. '
          'Приложение поможет вам найти удивительные локации поблизости, '
          'сохранить понравившиеся места в избранное и построить к ним маршрут.',
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

  Widget _buildLoginForm() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Войти',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
              value == null || value.isEmpty ? 'Введите email' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Пароль',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
              value == null || value.isEmpty ? 'Введите пароль' : null,
            ),
            SizedBox(height: 16),
            if (_loginError != null)
              Text(
                _loginError!,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoadingLogin ? null : _handleLogin,
              child: _isLoadingLogin
                  ? SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text('Войти'),
            ),
          ],
        ),
      ),
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
