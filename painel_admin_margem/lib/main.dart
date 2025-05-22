import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

// Core
import 'core/network/api_client.dart';
import 'core/network/network_info.dart';
import 'core/utils/input_converter.dart';

// Data
import 'data/datasources/auth_datasource.dart';
import 'data/datasources/store_datasource.dart';
import 'data/datasources/mobile_datasource.dart';
import 'data/datasources/support_datasource.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/store_repository.dart';
import 'data/repositories/mobile_repository.dart';
import 'data/repositories/support_repository.dart';

// Domain
import 'domain/usecases/auth/login_usecase.dart';
import 'domain/usecases/auth/logout_usecase.dart';
import 'domain/usecases/store/get_stores_usecase.dart';
import 'domain/usecases/store/create_store_usecase.dart';
import 'domain/usecases/store/update_store_usecase.dart';
import 'domain/usecases/store/delete_store_usecase.dart';
import 'domain/usecases/mobile/get_mobile_users_usecase.dart';
import 'domain/usecases/mobile/create_mobile_user_usecase.dart';
import 'domain/usecases/mobile/update_mobile_user_usecase.dart';
import 'domain/usecases/mobile/delete_mobile_user_usecase.dart';
import 'domain/usecases/support/get_support_users_usecase.dart';
import 'domain/usecases/support/create_support_user_usecase.dart';
import 'domain/usecases/support/update_support_user_usecase.dart';
import 'domain/usecases/support/delete_support_user_usecase.dart';

// Presentation
import 'presentation/auth/controllers/auth_controller.dart';
import 'presentation/stores/controllers/stores_controller.dart';
import 'presentation/mobile/controllers/mobile_controller.dart';
import 'presentation/support/controllers/support_controller.dart';
import 'presentation/shared/theme/app_theme.dart';
import 'presentation/shared/navigation/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carrega variáveis de ambiente
  await dotenv.load(fileName: '.env');

  // Configura orientação da tela (apenas modo retrato)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Inicializa dependências
  await initDependencies();

  runApp(const MyApp());
}

/// Inicializa as dependências do aplicativo
Future<void> initDependencies() async {
  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(sharedPreferences);

  // Dio e ApiClient
  final dio = Dio();
  final apiClient = ApiClient(dio);
  Get.put<ApiClient>(apiClient);

  // NetworkInfo
  final networkInfo = NetworkInfoImpl();
  Get.put<NetworkInfo>(networkInfo);

  // InputConverter
  final inputConverter = InputConverter();
  Get.put<InputConverter>(inputConverter);

  // DataSources
  final authDataSource = AuthDataSourceImpl(
    client: apiClient,
    sharedPreferences: sharedPreferences,
  );
  Get.put<AuthDataSource>(authDataSource);

  final storeDataSource = StoreDataSourceImpl(
    client: apiClient,
  );
  Get.put<StoreDataSource>(storeDataSource);

  final mobileDataSource = MobileDataSourceImpl(
    client: apiClient,
  );
  Get.put<MobileDataSource>(mobileDataSource);

  final supportDataSource = SupportDataSourceImpl(
    client: apiClient,
  );
  Get.put<SupportDataSource>(supportDataSource);

  // Repositories
  final authRepository = AuthRepository(
    dataSource: authDataSource,
    networkInfo: networkInfo,
  );
  Get.put(authRepository);

  final storeRepository = StoreRepository(
    dataSource: storeDataSource,
    networkInfo: networkInfo,
  );
  Get.put(storeRepository);

  final mobileRepository = MobileRepository(
    dataSource: mobileDataSource,
    networkInfo: networkInfo,
  );
  Get.put(mobileRepository);

  final supportRepository = SupportRepository(
    dataSource: supportDataSource,
    networkInfo: networkInfo,
  );
  Get.put(supportRepository);

  // UseCases - Auth
  final loginUseCase = LoginUseCase(
    repository: authRepository,
    networkInfo: networkInfo,
  );
  Get.put(loginUseCase);

  final logoutUseCase = LogoutUseCase(
    repository: authRepository,
  );
  Get.put(logoutUseCase);

  // UseCases - Store
  final getStoresUseCase = GetStoresUseCase(
    repository: storeRepository,
  );
  Get.put(getStoresUseCase);

  final createStoreUseCase = CreateStoreUseCase(
    repository: storeRepository,
  );
  Get.put(createStoreUseCase);

  final updateStoreUseCase = UpdateStoreUseCase(
    repository: storeRepository,
  );
  Get.put(updateStoreUseCase);

  final deleteStoreUseCase = DeleteStoreUseCase(
    repository: storeRepository,
  );
  Get.put(deleteStoreUseCase);

  // UseCases - Mobile
  final getMobileUsersUseCase = GetMobileUsersUseCase(
    repository: mobileRepository,
  );
  Get.put(getMobileUsersUseCase);

  final createMobileUserUseCase = CreateMobileUserUseCase(
    repository: mobileRepository,
  );
  Get.put(createMobileUserUseCase);

  final updateMobileUserUseCase = UpdateMobileUserUseCase(
    repository: mobileRepository,
  );
  Get.put(updateMobileUserUseCase);

  final deleteMobileUserUseCase = DeleteMobileUserUseCase(
    repository: mobileRepository,
  );
  Get.put(deleteMobileUserUseCase);

  // UseCases - Support
  final getSupportUsersUseCase = GetSupportUsersUseCase(
    repository: supportRepository,
  );
  Get.put(getSupportUsersUseCase);

  final createSupportUserUseCase = CreateSupportUserUseCase(
    repository: supportRepository,
  );
  Get.put(createSupportUserUseCase);

  final updateSupportUserUseCase = UpdateSupportUserUseCase(
    repository: supportRepository,
  );
  Get.put(updateSupportUserUseCase);

  final deleteSupportUserUseCase = DeleteSupportUserUseCase(
    repository: supportRepository,
  );
  Get.put(deleteSupportUserUseCase);

  // Controllers
  final authController = AuthController(
    loginUseCase: loginUseCase,
    logoutUseCase: logoutUseCase,
  );
  Get.put(authController);

  final storesController = StoresController(
    getStoresUseCase: getStoresUseCase,
    createStoreUseCase: createStoreUseCase,
    updateStoreUseCase: updateStoreUseCase,
    deleteStoreUseCase: deleteStoreUseCase,
    inputConverter: inputConverter,
  );
  Get.put(storesController);

  final mobileController = MobileController(
    getMobileUsersUseCase: getMobileUsersUseCase,
    createMobileUserUseCase: createMobileUserUseCase,
    updateMobileUserUseCase: updateMobileUserUseCase,
    deleteMobileUserUseCase: deleteMobileUserUseCase,
    getStoresUseCase: getStoresUseCase,
  );
  Get.put(mobileController);

  final supportController = SupportController(
    getSupportUsersUseCase: getSupportUsersUseCase,
    createSupportUserUseCase: createSupportUserUseCase,
    updateSupportUserUseCase: updateSupportUserUseCase,
    deleteSupportUserUseCase: deleteSupportUserUseCase,
  );
  Get.put(supportController);
}

/// Widget principal do aplicativo
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Painel Admin Margem',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
      getPages: AppRoutes.routes,
      initialRoute: '/login',
      locale: const Locale('pt', 'BR'),
    );
  }
}
