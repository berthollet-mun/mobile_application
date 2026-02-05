// ignore_for_file: avoid_print

import 'package:community/data/models/user_model.dart';
import 'package:community/core/services/auth_service.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find();

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;
      error.value = '';

      final data = await _authService.login(email: email, password: password);

      print(data);

      if (data != null) {
        user.value = UserModel.fromJson(data);
        print('User logged in: ${user.value?.user_id}');
        return true;
      } else {
        error.value = 'Email ou mot de passe incorrect';
        return false;
      }
    } catch (e) {
      error.value = 'Erreur de connexion: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String nom,
    required String prenom,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final data = await _authService.register(
        email: email,
        password: password,
        nom: nom,
        prenom: prenom,
      );

      print(data);

      if (data != null) {
        user.value = UserModel.fromJson(data);
        return true;
      } else {
        error.value = 'Erreur lors de l\'inscription';
        return false;
      }
    } catch (e) {
      error.value = 'Erreur d\'inscription: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Dans auth_controller.dart - Remplacez loadProfile

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      error.value = '';

      print('=== LOADING PROFILE IN CONTROLLER ===');

      final data = await _authService.getProfile();

      print('Profile data received: $data');

      if (data != null) {
        user.value = UserModel.fromJson(data);
        print('User loaded: ${user.value?.fullName}');
      } else {
        error.value = 'Impossible de charger le profil';
        print('Profile data is null');
      }
    } catch (e, stackTrace) {
      print('Load profile error: $e');
      print('Stack: $stackTrace');
      error.value = 'Erreur de chargement du profil: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    user.value = null;
    Get.offAllNamed('/welcome');
  }

  Future<bool> checkAuth() async {
    try {
      print('Checking authentication...');
      final isLoggedIn = await _authService.isLoggedIn();
      print('Authentication result: $isLoggedIn');
      return isLoggedIn;
    } catch (e) {
      print('Error in checkAuth: $e');
      error.value = 'Erreur de vérification d\'authentification: $e';
      return false;
    }
  }

  Future<bool> updateProfile({
    String? nom,
    String? prenom,
    String? password,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final success = await _authService.updateProfile(
        nom: nom,
        prenom: prenom,
        password: password,
      );

      if (success) {
        // Recharger le profil pour avoir les nouvelles données
        await loadProfile();
        return true;
      } else {
        error.value = 'Impossible de mettre à jour le profil';
        return false;
      }
    } catch (e) {
      error.value = 'Erreur: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
