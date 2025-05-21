import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/auth/login_usecase.dart';
import '../../../domain/usecases/auth/logout_usecase.dart';

/// Controlador para autenticação usando GetX
class AuthController extends GetxController {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final Rx<User?> _currentUser = Rx<User?>(null);
  final RxBool _isLoading = false.obs;
  final RxBool _isAuthenticated = false.obs;
  final RxString _errorMessage = ''.obs;

  AuthController({
    required this.loginUseCase,
    required this.logoutUseCase,
  });

  User? get currentUser => _currentUser.value;
  bool get isLoading => _isLoading.value;
  bool get isAuthenticated => _isAuthenticated.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    checkAuthentication();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Verifica se o usuário está autenticado
  Future<void> checkAuthentication() async {
    _isLoading.value = true;
    final result = await loginUseCase.repository.isAuthenticated();
    result.fold(
      (failure) {
        _isAuthenticated.value = false;
        _currentUser.value = null;
      },
      (isAuth) async {
        _isAuthenticated.value = isAuth;
        if (isAuth) {
          final userResult = await loginUseCase.repository.getCurrentUser();
          userResult.fold(
            (failure) {
              _currentUser.value = null;
            },
            (user) {
              _currentUser.value = user;
            },
          );
        }
      },
    );
    _isLoading.value = false;
  }

  /// Realiza o login do usuário
  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    final params = LoginParams(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    final result = await loginUseCase(params);

    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
        _isAuthenticated.value = false;
        _currentUser.value = null;
      },
      (user) {
        _currentUser.value = user;
        _isAuthenticated.value = true;
        _errorMessage.value = '';
        Get.offAllNamed('/stores');
      },
    );

    _isLoading.value = false;
  }

  /// Realiza o logout do usuário
  Future<void> logout() async {
    _isLoading.value = true;

    final result = await logoutUseCase();

    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
      },
      (_) {
        _currentUser.value = null;
        _isAuthenticated.value = false;
        _errorMessage.value = '';
        // Volta para a tela de login
        Get.offAllNamed('/login');
      },
    );

    _isLoading.value = false;
  }

  /// Limpa os campos do formulário
  void clearForm() {
    emailController.clear();
    passwordController.clear();
    _errorMessage.value = '';
  }

  /// Validador para o campo de e-mail
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, informe o e-mail';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Por favor, informe um e-mail válido';
    }
    return null;
  }

  /// Validador para o campo de senha
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, informe a senha';
    }
    return null;
  }
}
