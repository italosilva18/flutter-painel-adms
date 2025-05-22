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

  // Inicializa dependências básicas
  await initCoreDependencies();

  runApp(const MyApp());
}

/// Inicializa apenas as dependências essenciais
Future<void> initCoreDependencies() async {
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

  // Inicializa apenas o AuthController para login
  _initAuthDependencies();
}

/// Inicializa dependências de autenticação
void _initAuthDependencies() {
  // DataSource
  Get.lazyPut<AuthDataSource>(() => AuthDataSourceImpl(
        client: Get.find<ApiClient>(),
        sharedPreferences: Get.find<SharedPreferences>(),
      ));

  // Repository
  Get.lazyPut(() => AuthRepository(
        dataSource: Get.find<AuthDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ));

  // UseCases
  Get.lazyPut(() => LoginUseCase(
        repository: Get.find<AuthRepository>(),
        networkInfo: Get.find<NetworkInfo>(),
      ));

  Get.lazyPut(() => LogoutUseCase(
        repository: Get.find<AuthRepository>(),
      ));

  // Controller
  Get.put(AuthController(
    loginUseCase: Get.find<LoginUseCase>(),
    logoutUseCase: Get.find<LogoutUseCase>(),
  ));
}

/// Inicializa dependências de lojas (lazy)
void initStoreDependencies() {
  // DataSource
  Get.lazyPut<StoreDataSource>(() => StoreDataSourceImpl(
        client: Get.find<ApiClient>(),
      ));

  // Repository
  Get.lazyPut(() => StoreRepository(
        dataSource: Get.find<StoreDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ));

  // UseCases
  Get.lazyPut(() => GetStoresUseCase(
        repository: Get.find<StoreRepository>(),
      ));

  Get.lazyPut(() => CreateStoreUseCase(
        repository: Get.find<StoreRepository>(),
      ));

  Get.lazyPut(() => UpdateStoreUseCase(
        repository: Get.find<StoreRepository>(),
      ));

  Get.lazyPut(() => DeleteStoreUseCase(
        repository: Get.find<StoreRepository>(),
      ));

  // Controller
  Get.lazyPut(() => StoresController(
        getStoresUseCase: Get.find<GetStoresUseCase>(),
        createStoreUseCase: Get.find<CreateStoreUseCase>(),
        updateStoreUseCase: Get.find<UpdateStoreUseCase>(),
        deleteStoreUseCase: Get.find<DeleteStoreUseCase>(),
        inputConverter: Get.find<InputConverter>(),
      ));
}

/// Inicializa dependências de usuários mobile (lazy)
void initMobileDependencies() {
  // DataSource
  Get.lazyPut<MobileDataSource>(() => MobileDataSourceImpl(
        client: Get.find<ApiClient>(),
      ));

  // Repository
  Get.lazyPut(() => MobileRepository(
        dataSource: Get.find<MobileDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ));

  // UseCases
  Get.lazyPut(() => GetMobileUsersUseCase(
        repository: Get.find<MobileRepository>(),
      ));

  Get.lazyPut(() => CreateMobileUserUseCase(
        repository: Get.find<MobileRepository>(),
      ));

  Get.lazyPut(() => UpdateMobileUserUseCase(
        repository: Get.find<MobileRepository>(),
      ));

  Get.lazyPut(() => DeleteMobileUserUseCase(
        repository: Get.find<MobileRepository>(),
      ));

  // Controller
  Get.lazyPut(() => MobileController(
        getMobileUsersUseCase: Get.find<GetMobileUsersUseCase>(),
        createMobileUserUseCase: Get.find<CreateMobileUserUseCase>(),
        updateMobileUserUseCase: Get.find<UpdateMobileUserUseCase>(),
        deleteMobileUserUseCase: Get.find<DeleteMobileUserUseCase>(),
        getStoresUseCase: Get.find<GetStoresUseCase>(),
      ));
}

/// Inicializa dependências de suporte (lazy)
void initSupportDependencies() {
  // DataSource
  Get.lazyPut<SupportDataSource>(() => SupportDataSourceImpl(
        client: Get.find<ApiClient>(),
      ));

  // Repository
  Get.lazyPut(() => SupportRepository(
        dataSource: Get.find<SupportDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ));

  // UseCases
  Get.lazyPut(() => GetSupportUsersUseCase(
        repository: Get.find<SupportRepository>(),
      ));

  Get.lazyPut(() => CreateSupportUserUseCase(
        repository: Get.find<SupportRepository>(),
      ));

  Get.lazyPut(() => UpdateSupportUserUseCase(
        repository: Get.find<SupportRepository>(),
      ));

  Get.lazyPut(() => DeleteSupportUserUseCase(
        repository: Get.find<SupportRepository>(),
      ));

  // Controller
  Get.lazyPut(() => SupportController(
        getSupportUsersUseCase: Get.find<GetSupportUsersUseCase>(),
        createSupportUserUseCase: Get.find<CreateSupportUserUseCase>(),
        updateSupportUserUseCase: Get.find<UpdateSupportUserUseCase>(),
        deleteSupportUserUseCase: Get.find<DeleteSupportUserUseCase>(),
      ));
}

/// Widget principal do aplicativo
class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      // Configurações para otimizar performance na web
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
    );
  }
}
