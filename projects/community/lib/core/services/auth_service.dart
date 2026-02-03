// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService extends GetxService {
  final ApiService _apiService = Get.find();
  final StorageService _storageService = Get.find();

  // ✅ Convertit dynamiquement user_id (int ou String) en int
  int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is String) {
      final parsed = int.tryParse(v);
      if (parsed != null) return parsed;
    }
    throw Exception('user_id invalide: $v');
  }

  Future<Map<String, dynamic>?> register({
    required String email,
    required String password,
    required String nom,
    required String prenom,
  }) async {
    final response = await _apiService.post('/auth/register', {
      'email': email,
      'password': password,
      'nom': nom,
      'prenom': prenom,
    });

    print('Register response: ${response.data}');

    if (response.success) {
      final data = response.data;
      await _storageService.setToken(data['token']);
      // await _storageService.setUserId(data['user_id']);
      // ✅ FIX: force user_id en int avant de le passer au StorageService
      final int uid = _toInt(data['user_id']);
      await _storageService.setUserId(uid);
      return data;
    }
    return null;
  }

  Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.post('/auth/login', {
      'email': email,
      'password': password,
    });

    print('Login response: ${response.data}');

    if (response.success) {
      final data = response.data;
      await _storageService.setToken(data['token']);
      // await _storageService.setUserId(data['user_id']);
      // ✅ FIX: force user_id en int avant de le passer au StorageService
      final int uid = _toInt(data['user_id']);
      await _storageService.setUserId(uid);
      return data;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getProfile() async {
    print('=== GET PROFILE ===');

    final response = await _apiService.get('/auth/profile');

    print('Profile Response success: ${response.success}');
    print('Profile Response data: ${response.data}');
    print('Profile Response message: ${response.message}');
    print('===================');

    if (response.success && response.data != null) {
      // ✅ L'API peut renvoyer {user: {...}} ou directement {...}
      if (response.data!.containsKey('user')) {
        return response.data!['user'] as Map<String, dynamic>;
      }
      return response.data;
    }
    return null;
  }

  Future<bool> updateProfile({
    String? nom,
    String? prenom,
    String? password,
  }) async {
    final Map<String, dynamic> data = {};
    if (nom != null) data['nom'] = nom;
    if (prenom != null) data['prenom'] = prenom;
    if (password != null) data['password'] = password;

    final response = await _apiService.put('/auth/profile', data);
    return response.success;
  }

  Future<void> logout() async {
    await _storageService.clear();
  }

  Future<bool> isLoggedIn() async {
    try {
      final token = await _storageService.getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      print('Error in isLoggedIn: $e');
      return false;
    }
  }
}
