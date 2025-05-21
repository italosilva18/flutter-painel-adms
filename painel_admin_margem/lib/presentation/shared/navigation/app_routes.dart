import 'package:get/get.dart';
import '../../auth/pages/login_page.dart';
import '../../stores/pages/stores_page.dart';
import '../../mobile/pages/mobile_users_page.dart';
import '../../support/pages/support_users_page.dart';
import '../../auth/controllers/auth_controller.dart';

/// Classe que contém as rotas do aplicativo
class AppRoutes {
  static final routes = [
    GetPage(
      name: '/login',
      page: () => const LoginPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: '/stores',
      page: () => const StoresPage(),
      transition: Transition.fadeIn,
      middlewares: [
        RouteGuard(),
      ],
    ),
    GetPage(
      name: '/mobile',
      page: () => const MobileUsersPage(),
      transition: Transition.fadeIn,
      middlewares: [
        RouteGuard(),
      ],
    ),
    GetPage(
      name: '/support',
      page: () => const SupportUsersPage(),
      transition: Transition.fadeIn,
      middlewares: [
        RouteGuard(),
      ],
    ),
  ];
}

/// Middleware para proteção de rotas
class RouteGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    // Se não estiver autenticado, redireciona para a tela de login
    if (!authController.isAuthenticated) {
      return const RouteSettings(name: '/login');
    }

    return null;
  }
}
