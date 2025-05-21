import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

// Core
import 'core/network/api_client.dart';
import 'core/network/network_info.dart';

// Data
import 'data/datasources/auth_datasource.dart';
import 'data/repositories/auth_repository.dart';

// Domain
import 'domain/usecases/auth/login_usecase.dart';
import 'domain/usecases/auth/logout_usecase.dart';

// Presentation
import 'presentation/auth/controllers/auth_controller.dart';
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

  // Auth DataSource
  final authDataSource = AuthDataSourceImpl(
    client: apiClient,
    sharedPreferences: sharedPreferences,
  );
  Get.put<AuthDataSource>(authDataSource);

  // Auth Repository
  final authRepository = AuthRepository(
    dataSource: authDataSource,
    networkInfo: networkInfo,
  );
  Get.put(authRepository);

  // Casos de uso de Auth
  final loginUseCase = LoginUseCase(
    repository: authRepository,
    networkInfo: networkInfo,
  );
  Get.put(loginUseCase);

  final logoutUseCase = LogoutUseCase(
    repository: authRepository,
  );
  Get.put(logoutUseCase);

  // Controladores
  final authController = AuthController(
    loginUseCase: loginUseCase,
    logoutUseCase: logoutUseCase,
  );
  Get.put(authController);
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
