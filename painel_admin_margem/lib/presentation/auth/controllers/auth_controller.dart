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

  // Variáveis privadas sem reatividade
  User? _currentUser;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String _errorMessage = '';

  AuthController({
    required this.loginUseCase,
    required this.logoutUseCase,
  });

  // Getters públicos
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String get errorMessage => _errorMessage;

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
    _setLoading(true);

    final result = await loginUseCase.repository.isAuthenticated();
    result.fold(
      (failure) {
        _isAuthenticated = false;
        _currentUser = null;
      },
      (isAuth) async {
        _isAuthenticated = isAuth;
        if (isAuth) {
          final userResult = await loginUseCase.repository.getCurrentUser();
          userResult.fold(
            (failure) {
              _currentUser = null;
            },
            (user) {
              _currentUser = user;
            },
          );
        }
      },
    );

    _setLoading(false);
  }

  /// Realiza o login do usuário
  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    _setLoading(true);
    _setErrorMessage('');

    final params = LoginParams(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    final result = await loginUseCase(params);

    result.fold(
      (failure) {
        _setErrorMessage(failure.message);
        _isAuthenticated = false;
        _currentUser = null;
      },
      (user) {
        _currentUser = user;
        _isAuthenticated = true;
        _setErrorMessage('');
        Get.offAllNamed('/stores');
      },
    );

    _setLoading(false);
  }

  /// Realiza o logout do usuário
  Future<void> logout() async {
    _setLoading(true);

    final result = await logoutUseCase();

    result.fold(
      (failure) {
        _setErrorMessage(failure.message);
      },
      (_) {
        _currentUser = null;
        _isAuthenticated = false;
        _setErrorMessage('');
        // Volta para a tela de login
        Get.offAllNamed('/login');
      },
    );

    _setLoading(false);
  }

  /// Limpa os campos do formulário
  void clearForm() {
    emailController.clear();
    passwordController.clear();
    _setErrorMessage('');
  }

  // Métodos privados para atualizar estado e notificar UI
  void _setLoading(bool value) {
    _isLoading = value;
    update(['loading']); // Atualiza apenas widgets com ID 'loading'
  }

  void _setErrorMessage(String message) {
    _errorMessage = message;
    update(['error_message']); // Atualiza apenas widgets com ID 'error_message'
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
