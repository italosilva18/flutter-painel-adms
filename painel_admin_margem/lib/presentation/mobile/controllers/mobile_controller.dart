import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import '../../../domain/entities/mobile_user.dart';
import '../../../domain/entities/store.dart';
import '../../../domain/usecases/mobile/get_mobile_users_usecase.dart';
import '../../../domain/usecases/mobile/create_mobile_user_usecase.dart';
import '../../../domain/usecases/mobile/update_mobile_user_usecase.dart';
import '../../../domain/usecases/mobile/delete_mobile_user_usecase.dart';
import '../../../domain/usecases/store/get_stores_usecase.dart';
import '../../../core/error/failures.dart';

class MobileController extends GetxController {
  final GetMobileUsersUseCase getMobileUsersUseCase;
  final CreateMobileUserUseCase createMobileUserUseCase;
  final UpdateMobileUserUseCase updateMobileUserUseCase;
  final DeleteMobileUserUseCase deleteMobileUserUseCase;
  final GetStoresUseCase getStoresUseCase;

  // Controles de formulário
  final formKey = GlobalKey<FormState>();
  final emailSearchController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = MaskedTextController(mask: '(00) 00000-0000');
  final passwordController = TextEditingController();
  final storeSearchController = TextEditingController();

  // Estado
  final RxList<MobileUser> _users = <MobileUser>[].obs;
  final Rx<MobileUser?> _selectedUser = Rx<MobileUser?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxString _selectedType = MobileUserType.customer.value.obs;
  final RxString _selectedPartner = ''.obs;
  final RxDouble _selectedPartnerCode = 0.0.obs;
  final RxBool _isActive = true.obs;
  final RxList<Store> _userStores = <Store>[].obs;
  final RxList<Store> _allStores = <Store>[].obs;
  final RxList<Store> _filteredStores = <Store>[].obs;
  final RxList<Map<String, dynamic>> _partners = <Map<String, dynamic>>[].obs;
  final RxInt _tabIndex = 0.obs;

  // Getters
  List<MobileUser> get users => _users;
  MobileUser? get selectedUser => _selectedUser.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  String get selectedType => _selectedType.value;
  String get selectedPartner => _selectedPartner.value;
  double get selectedPartnerCode => _selectedPartnerCode.value;
  bool get isActive => _isActive.value;
  List<Store> get userStores => _userStores;
  List<Store> get filteredStores => _filteredStores;
  List<Map<String, dynamic>> get partners => _partners;
  int get tabIndex => _tabIndex.value;

  MobileController({
    required this.getMobileUsersUseCase,
    required this.createMobileUserUseCase,
    required this.updateMobileUserUseCase,
    required this.deleteMobileUserUseCase,
    required this.getStoresUseCase,
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
    phoneController.dispose();
    passwordController.dispose();
    storeSearchController.dispose();
    super.onClose();
  }

  // Muda o índice da tab
  void changeTabIndex(int index) {
    _tabIndex.value = index;
    if (index == 1 && _selectedUser.value != null) {
      fetchUserStores();
    }
  }

  // Busca os usuários mobile
  Future<void> fetchUsers() async {
    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await getMobileUsersUseCase();

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

    final result = await getStoresUseCase.repository.getPartners();

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

    final result = await getMobileUsersUseCase.repository.getMobileUserByEmail(
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

  // Busca as lojas do usuário
  Future<void> fetchUserStores() async {
    if (_selectedUser.value == null) {
      return;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await getMobileUsersUseCase.repository.getMobileUserStores(
      _selectedUser.value!.id,
    );

    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
      },
      (stores) {
        _userStores.assignAll(stores);
      },
    );

    _isLoading.value = false;
  }

  // Busca todas as lojas
  Future<void> fetchAllStores() async {
    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await getStoresUseCase();

    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
      },
      (stores) {
        _allStores.assignAll(stores);
        _filterStores('');
      },
    );

    _isLoading.value = false;
  }

  // Filtra as lojas pelo nome
  void filterStores(String query) {
    if (query.isEmpty) {
      _filteredStores.assignAll(_allStores);
    } else {
      _filteredStores.assignAll(_allStores.where((store) {
        return store.tradeName.toLowerCase().contains(query.toLowerCase()) ||
            store.company.toLowerCase().contains(query.toLowerCase()) ||
            store.cnpj.contains(query);
      }).toList());
    }
  }

  // Seleciona um usuário para edição
  void selectUser(MobileUser user) {
    _selectedUser.value = user;
    _populateFormWithUser(user);
    _tabIndex.value = 0;
  }

  // Limpa a seleção e o formulário
  void clearSelection() {
    _selectedUser.value = null;
    _clearForm();
    _userStores.clear();
  }

  // Preenche o formulário com os dados do usuário
  void _populateFormWithUser(MobileUser user) {
    nameController.text = user.name;
    emailController.text = user.email;
    phoneController.text = user.phone;
    passwordController.clear();
    _selectedType.value = user.type;
    _selectedPartner.value = user.partner;
    _selectedPartnerCode.value = user.codePartner;
    _isActive.value = user.active;
  }

  // Limpa o formulário
  void _clearForm() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    _selectedType.value = MobileUserType.customer.value;
    _selectedPartner.value = '';
    _selectedPartnerCode.value = 0.0;
    _isActive.value = true;
  }

  // Salva o usuário (cria ou atualiza)
  Future<void> saveUser() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    // Constrói o objeto MobileUser a partir do formulário
    final user = _buildUserFromForm();

    if (_selectedUser.value != null) {
      // Atualiza o usuário existente
      final result = await updateMobileUserUseCase(user);
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
      final result = await createMobileUserUseCase(user);
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

    final result = await deleteMobileUserUseCase(_selectedUser.value!.id);

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

  // Vincula uma loja ao usuário
  Future<void> linkStoreToUser(Store store) async {
    if (_selectedUser.value == null) {
      return;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await getMobileUsersUseCase.repository.linkStoreToMobileUser(
      _selectedUser.value!.id,
      store.id,
    );

    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
      },
      (_) {
        if (!_userStores.any((s) => s.id == store.id)) {
          _userStores.add(store);
        }
      },
    );

    _isLoading.value = false;
  }

  // Remove o vínculo de uma loja com o usuário
  Future<void> unlinkStoreFromUser(Store store) async {
    if (_selectedUser.value == null) {
      return;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    final result =
        await getMobileUsersUseCase.repository.unlinkStoreFromMobileUser(
      _selectedUser.value!.id,
      store.id,
    );

    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
      },
      (_) {
        _userStores.removeWhere((s) => s.id == store.id);
      },
    );

    _isLoading.value = false;
  }

  // Seleciona um tipo de usuário
  void selectType(String type) {
    _selectedType.value = type;
  }

  // Seleciona um parceiro
  void selectPartner(String partnerName, double partnerCode) {
    _selectedPartner.value = partnerName;
    _selectedPartnerCode.value = partnerCode;
  }

  // Alterna o status "ativo" do usuário
  void toggleActive(bool value) {
    _isActive.value = value;
  }

  // Constrói um objeto MobileUser a partir dos dados do formulário
  MobileUser _buildUserFromForm() {
    return MobileUser(
      id: _selectedUser.value?.id ?? '',
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      password:
          passwordController.text.isNotEmpty ? passwordController.text : null,
      type: _selectedType.value,
      partner: _selectedPartner.value,
      codePartner: _selectedPartnerCode.value,
      active: _isActive.value,
      storeIds: _selectedUser.value?.storeIds ?? [],
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

  // Validação de senha (opcional para atualização)
  String? validatePassword(String? value) {
    if (_selectedUser.value == null && (value == null || value.isEmpty)) {
      return 'Senha obrigatória para novos usuários';
    }
    return null;
  }
}
