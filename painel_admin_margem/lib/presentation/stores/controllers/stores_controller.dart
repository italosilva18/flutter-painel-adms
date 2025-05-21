import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import '../../../domain/entities/store.dart';
import '../../../domain/usecases/store/get_stores_usecase.dart';
import '../../../domain/usecases/store/create_store_usecase.dart';
import '../../../domain/usecases/store/update_store_usecase.dart';
import '../../../domain/usecases/store/delete_store_usecase.dart';
import '../../../core/error/failures.dart';
import '../../../core/utils/input_converter.dart';

class StoresController extends GetxController {
  final GetStoresUseCase getStoresUseCase;
  final CreateStoreUseCase createStoreUseCase;
  final UpdateStoreUseCase updateStoreUseCase;
  final DeleteStoreUseCase deleteStoreUseCase;
  final InputConverter inputConverter;

  // Controles de formulário
  final formKey = GlobalKey<FormState>();
  final cnpjSearchController = MaskedTextController(mask: '00.000.000/0000-00');
  final cnpjController = MaskedTextController(mask: '00.000.000/0000-00');
  final companyController = TextEditingController();
  final tradeNameController = TextEditingController();
  final phoneController = MaskedTextController(mask: '(00) 00000-0000');
  final emailController = TextEditingController();
  final serialController = TextEditingController();
  final streetController = TextEditingController();
  final numberController = TextEditingController();
  final neighborhoodController = TextEditingController();
  final cityController = TextEditingController();

  // Estado
  final RxList<Store> _stores = <Store>[].obs;
  final Rx<Store?> _selectedStore = Rx<Store?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxList<String> _segments = <String>[].obs;
  final RxList<String> _sizes = <String>[].obs;
  final RxList<Map<String, dynamic>> _states = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> _partners = <Map<String, dynamic>>[].obs;
  final RxString _selectedSegment = ''.obs;
  final RxString _selectedSize = ''.obs;
  final RxString _selectedState = ''.obs;
  final RxInt _selectedStateCode = 0.obs;
  final RxString _selectedPartner = ''.obs;
  final RxDouble _selectedPartnerCode = 0.0.obs;
  final RxInt _selectedCityCode = 0.obs;
  final RxList<int> _selectedOperations = <int>[].obs;
  final RxBool _isActive = true.obs;
  final RxBool _isOfferta = false.obs;
  final RxBool _isOppinar = false.obs;
  final RxBool _isPrazzo = false.obs;
  final RxBool _isScannerActive = false.obs;
  final RxBool _isScannerBeta = false.obs;
  final RxInt _scannerExpire = 0.obs;

  // Getters
  List<Store> get stores => _stores;
  Store? get selectedStore => _selectedStore.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  List<String> get segments => _segments;
  List<String> get sizes => _sizes;
  List<Map<String, dynamic>> get states => _states;
  List<Map<String, dynamic>> get partners => _partners;
  String get selectedSegment => _selectedSegment.value;
  String get selectedSize => _selectedSize.value;
  String get selectedState => _selectedState.value;
  int get selectedStateCode => _selectedStateCode.value;
  String get selectedPartner => _selectedPartner.value;
  double get selectedPartnerCode => _selectedPartnerCode.value;
  int get selectedCityCode => _selectedCityCode.value;
  List<int> get selectedOperations => _selectedOperations;
  bool get isActive => _isActive.value;
  bool get isOfferta => _isOfferta.value;
  bool get isOppinar => _isOppinar.value;
  bool get isPrazzo => _isPrazzo.value;
  bool get isScannerActive => _isScannerActive.value;
  bool get isScannerBeta => _isScannerBeta.value;
  int get scannerExpire => _scannerExpire.value;

  StoresController({
    required this.getStoresUseCase,
    required this.createStoreUseCase,
    required this.updateStoreUseCase,
    required this.deleteStoreUseCase,
    required this.inputConverter,
  });

  @override
  void onInit() {
    super.onInit();
    fetchStores();
    fetchReferenceData();
  }

  @override
  void onClose() {
    cnpjSearchController.dispose();
    cnpjController.dispose();
    companyController.dispose();
    tradeNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    serialController.dispose();
    streetController.dispose();
    numberController.dispose();
    neighborhoodController.dispose();
    cityController.dispose();
    super.onClose();
  }

  // Busca as lojas
  Future<void> fetchStores() async {
    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await getStoresUseCase();

    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
      },
      (stores) {
        _stores.assignAll(stores);
      },
    );

    _isLoading.value = false;
  }

  // Busca dados de referência (segmentos, tamanhos, estados, parceiros)
  Future<void> fetchReferenceData() async {
    _isLoading.value = true;

    // Segmentos
    final segmentsResult = await getStoresUseCase.repository.getSegments();
    segmentsResult.fold(
      (failure) => _errorMessage.value = failure.message,
      (segments) => _segments.value = segments,
    );

    // Tamanhos
    final sizesResult = await getStoresUseCase.repository.getSizes();
    sizesResult.fold(
      (failure) => _errorMessage.value = failure.message,
      (sizes) => _sizes.value = sizes,
    );

    // Estados
    final statesResult = await getStoresUseCase.repository.getStates();
    statesResult.fold(
      (failure) => _errorMessage.value = failure.message,
      (states) => _states.value = states,
    );

    // Parceiros
    final partnersResult = await getStoresUseCase.repository.getPartners();
    partnersResult.fold(
      (failure) => _errorMessage.value = failure.message,
      (partners) => _partners.value = partners,
    );

    _isLoading.value = false;
  }

  // Busca loja pelo CNPJ
  Future<void> searchStoreByCnpj() async {
    if (cnpjSearchController.text.isEmpty) {
      fetchStores();
      return;
    }

    final String cnpj =
        inputConverter.removeNonDigits(cnpjSearchController.text);
    if (cnpj.length != 14) {
      _errorMessage.value = 'CNPJ inválido';
      return;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await getStoresUseCase.repository.getStoreByCnpj(cnpj);

    result.fold(
      (failure) {
        if (failure is ServerFailure && failure.statusCode == 404) {
          _stores.clear();
        } else {
          _errorMessage.value = failure.message;
        }
      },
      (store) {
        _stores.assignAll([store]);
      },
    );

    _isLoading.value = false;
  }

  // Seleciona uma loja para edição
  void selectStore(Store store) {
    _selectedStore.value = store;
    _populateFormWithStore(store);
  }

  // Limpa a seleção e o formulário
  void clearSelection() {
    _selectedStore.value = null;
    _clearForm();
  }

  // Preenche o formulário com os dados da loja
  void _populateFormWithStore(Store store) {
    cnpjController.text = inputConverter.formatCnpj(store.cnpj);
    companyController.text = store.company;
    tradeNameController.text = store.tradeName;
    phoneController.text = store.phone;
    emailController.text = store.email;
    serialController.text = store.serial;
    streetController.text = store.address.street;
    numberController.text = store.address.number;
    neighborhoodController.text = store.address.neighborhood;
    cityController.text = store.address.city;
    _selectedCityCode.value = store.address.cityCode;
    _selectedState.value = store.address.state;
    _selectedStateCode.value = store.address.stateCode;
    _selectedPartner.value = store.partner;
    _selectedPartnerCode.value = store.codePartner;
    _selectedSize.value = store.size;
    _selectedSegment.value = store.segment;
    _selectedOperations.value = List<int>.from(store.operation);
    _isActive.value = store.active;
    _isScannerActive.value = store.scanner.active;
    _isScannerBeta.value = store.scanner.beta;
    _scannerExpire.value = store.scanner.expire;
    _isOfferta.value = store.offerta;
    _isOppinar.value = store.oppinar;
    _isPrazzo.value = store.prazzo;
  }

  // Limpa o formulário
  void _clearForm() {
    cnpjController.clear();
    companyController.clear();
    tradeNameController.clear();
    phoneController.clear();
    emailController.clear();
    serialController.clear();
    streetController.clear();
    numberController.clear();
    neighborhoodController.clear();
    cityController.clear();
    _selectedCityCode.value = 0;
    _selectedState.value = '';
    _selectedStateCode.value = 0;
    _selectedPartner.value = '';
    _selectedPartnerCode.value = 0.0;
    _selectedSize.value = '';
    _selectedSegment.value = '';
    _selectedOperations.value = [];
    _isActive.value = true;
    _isScannerActive.value = false;
    _isScannerBeta.value = false;
    _scannerExpire.value = 0;
    _isOfferta.value = false;
    _isOppinar.value = false;
    _isPrazzo.value = false;
  }

  // Salva a loja (cria ou atualiza)
  Future<void> saveStore() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    // Constrói o objeto Store a partir do formulário
    final store = _buildStoreFromForm();

    if (_selectedStore.value != null) {
      // Atualiza a loja existente
      final result = await updateStoreUseCase(store);
      result.fold(
        (failure) {
          _errorMessage.value = failure.message;
        },
        (updatedStore) {
          final index = _stores.indexWhere((s) => s.id == updatedStore.id);
          if (index >= 0) {
            _stores[index] = updatedStore;
          }
          Get.back();
        },
      );
    } else {
      // Cria uma nova loja
      final result = await createStoreUseCase(store);
      result.fold(
        (failure) {
          _errorMessage.value = failure.message;
        },
        (createdStore) {
          _stores.add(createdStore);
          Get.back();
        },
      );
    }

    _isLoading.value = false;
  }

  // Deleta a loja
  Future<void> deleteStore() async {
    if (_selectedStore.value == null) {
      return;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await deleteStoreUseCase(_selectedStore.value!.id);

    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
      },
      (_) {
        _stores.removeWhere((store) => store.id == _selectedStore.value!.id);
        Get.back();
      },
    );

    _isLoading.value = false;
  }

  // Seleciona um estado
  void selectState(String stateName, int stateCode) {
    _selectedState.value = stateName;
    _selectedStateCode.value = stateCode;
  }

  // Seleciona um parceiro
  void selectPartner(String partnerName, double partnerCode) {
    _selectedPartner.value = partnerName;
    _selectedPartnerCode.value = partnerCode;
  }

  // Seleciona um segmento
  void selectSegment(String segment) {
    _selectedSegment.value = segment;
  }

  // Seleciona um tamanho
  void selectSize(String size) {
    _selectedSize.value = size;
  }

  // Alterna uma operação na lista de operações selecionadas
  void toggleOperation(int operationId) {
    if (_selectedOperations.contains(operationId)) {
      _selectedOperations.remove(operationId);
    } else {
      _selectedOperations.add(operationId);
    }
  }

  // Alterna o status "ativo" da loja
  void toggleActive(bool value) {
    _isActive.value = value;
  }

  // Alterna o status "ativo" do scanner
  void toggleScannerActive(bool value) {
    _isScannerActive.value = value;
  }

  // Alterna o status "beta" do scanner
  void toggleScannerBeta(bool value) {
    _isScannerBeta.value = value;
  }

  // Alterna o status "offerta"
  void toggleOfferta(bool value) {
    _isOfferta.value = value;
  }

  // Alterna o status "oppinar"
  void toggleOppinar(bool value) {
    _isOppinar.value = value;
  }

  // Alterna o status "prazzo"
  void togglePrazzo(bool value) {
    _isPrazzo.value = value;
  }

  // Constrói um objeto Store a partir dos dados do formulário
  Store _buildStoreFromForm() {
    final String id = _selectedStore.value?.id ?? '';
    final String cnpj = inputConverter.removeNonDigits(cnpjController.text);
    final String phone = inputConverter.removeNonDigits(phoneController.text);

    final scanner = Scanner(
      active: _isScannerActive.value,
      beta: _isScannerBeta.value,
      expire: _scannerExpire.value,
    );

    final address = Address(
      street: streetController.text,
      number: numberController.text,
      city: cityController.text,
      cityCode: _selectedCityCode.value,
      state: _selectedState.value,
      stateCode: _selectedStateCode.value,
      neighborhood: neighborhoodController.text,
    );

    return Store(
      id: id,
      company: companyController.text,
      tradeName: tradeNameController.text,
      cnpj: cnpj,
      phone: phone,
      email: emailController.text,
      serial: serialController.text,
      address: address,
      partner: _selectedPartner.value,
      codePartner: _selectedPartnerCode.value,
      size: _selectedSize.value,
      segment: _selectedSegment.value,
      operation: _selectedOperations.toList(),
      active: _isActive.value,
      scanner: scanner,
      offerta: _isOfferta.value,
      oppinar: _isOppinar.value,
      prazzo: _isPrazzo.value,
    );
  }

  // Validação do CNPJ
  String? validateCnpj(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, informe o CNPJ';
    }
    final cnpj = inputConverter.removeNonDigits(value);
    if (cnpj.length != 14) {
      return 'CNPJ inválido';
    }
    return null;
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
