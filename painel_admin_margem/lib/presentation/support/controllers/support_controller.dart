import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/support_user.dart';
import '../../../domain/usecases/support/get_support_users_usecase.dart';
import '../../../domain/usecases/support/create_support_user_usecase.dart';
import '../../../domain/usecases/support/update_support_user_usecase.dart';
import '../../../domain/usecases/support/delete_support_user_usecase.dart';
import '../../../core/error/failures.dart';

class SupportController extends GetxController {
  final GetSupportUsersUseCase getSupportUsersUseCase;
  final CreateSupportUserUseCase createSupportUserUseCase;
  final UpdateSupportUserUseCase updateSupportUserUseCase;
  final DeleteSupportUserUseCase deleteSupportUserUseCase;

  // Controles de formulário
  final formKey = GlobalKey<FormState>();
  final emailSearchController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  // Estado
  final RxList<SupportUser> _users = <SupportUser>[].obs;
  final Rx<SupportUser?> _selectedUser = Rx<SupportUser?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxString _selectedPartner = ''.obs;
  final RxDouble _selectedPartnerCode = 0.0.obs;
  final RxList<Map<String, dynamic>> _partners = <Map<String, dynamic>>[].obs;

  // Getters
  List<SupportUser> get users => _users;
  SupportUser? get selectedUser => _selectedUser.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  String get selectedPartner => _selectedPartner.value;
  double get selectedPartnerCode => _selectedPartnerCode.value;
  List<Map<String, dynamic>> get partners => _partners;

  SupportController({
    required this.getSupportUsersUseCase,
    required this.createSupportUserUseCase,
    required this.updateSupportUserUseCase,
    required this.deleteSupportUserUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
    fetchPartners();
  }

  @override
  void onClose() {
    emailSearchController.dispose();
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  // Busca os usuários de suporte
  Future<void> fetchUsers() async {
    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await getSupportUsersUseCase();

    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
      },
      (users) {
        _users.assignAll(users);
      },
    );

    _isLoading.value = false;
  }

  // Busca os parceiros
  Future<void> fetchPartners() async {
    _isLoading.value = true;

    final result = await getSupportUsersUseCase.repository.getPartners();

    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
      },
      (partners) {
        _partners.value = partners;
      },
    );

    _isLoading.value = false;
  }

  // Busca usuário por e-mail
  Future<void> searchUserByEmail() async {
    if (emailSearchController.text.isEmpty) {
      fetchUsers();
      return;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    final result =
        await getSupportUsersUseCase.repository.getSupportUserByEmail(
      emailSearchController.text.trim(),
    );

    result.fold(
      (failure) {
        if (failure is ServerFailure && failure.statusCode == 404) {
          _users.clear();
        } else {
          _errorMessage.value = failure.message;
        }
      },
      (user) {
        _users.assignAll([user]);
      },
    );

    _isLoading.value = false;
  }

  // Seleciona um usuário para edição
  void selectUser(SupportUser user) {
    _selectedUser.value = user;
    _populateFormWithUser(user);
  }

  // Limpa a seleção e o formulário
  void clearSelection() {
    _selectedUser.value = null;
    _clearForm();
  }

  // Preenche o formulário com os dados do usuário
  void _populateFormWithUser(SupportUser user) {
    nameController.text = user.name;
    emailController.text = user.email;
    _selectedPartner.value = user.partner;
    _selectedPartnerCode.value = user.codePartner;
  }

  // Limpa o formulário
  void _clearForm() {
    nameController.clear();
    emailController.clear();
    _selectedPartner.value = '';
    _selectedPartnerCode.value = 0.0;
  }

  // Salva o usuário (cria ou atualiza)
  Future<void> saveUser() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    // Constrói o objeto SupportUser a partir do formulário
    final user = _buildUserFromForm();

    if (_selectedUser.value != null) {
      // Atualiza o usuário existente
      final result = await updateSupportUserUseCase(user);
      result.fold(
        (failure) {
          _errorMessage.value = failure.message;
        },
        (updatedUser) {
          final index = _users.indexWhere((u) => u.id == updatedUser.id);
          if (index >= 0) {
            _users[index] = updatedUser;
          }
          Get.back();
        },
      );
    } else {
      // Cria um novo usuário
      final result = await createSupportUserUseCase(user);
      result.fold(
        (failure) {
          _errorMessage.value = failure.message;
        },
        (createdUser) {
          _users.add(createdUser);
          Get.back();
        },
      );
    }

    _isLoading.value = false;
  }

  // Deleta o usuário
  Future<void> deleteUser() async {
    if (_selectedUser.value == null) {
      return;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await deleteSupportUserUseCase(_selectedUser.value!.id);

    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
      },
      (_) {
        _users.removeWhere((user) => user.id == _selectedUser.value!.id);
        Get.back();
      },
    );

    _isLoading.value = false;
  }

  // Seleciona um parceiro
  void selectPartner(String partnerName, double partnerCode) {
    _selectedPartner.value = partnerName;
    _selectedPartnerCode.value = partnerCode;
  }

  // Constrói um objeto SupportUser a partir dos dados do formulário
  SupportUser _buildUserFromForm() {
    return SupportUser(
      id: _selectedUser.value?.id ?? '',
      name: nameController.text,
      email: emailController.text,
      partner: _selectedPartner.value,
      codePartner: _selectedPartnerCode.value,
    );
  }

  // Validação de campos obrigatórios
  String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  // Validação de e-mail
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, informe o e-mail';
    }
    if (!GetUtils.isEmail(value)) {
      return 'E-mail inválido';
    }
    return null;
  }
}
