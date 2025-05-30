import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/pages/login_page.dart';
import '../../stores/pages/stores_page.dart';
import '../../stores/pages/store_form_page.dart';
import '../../stores/pages/store_details_page.dart';
import '../../mobile/pages/mobile_users_page.dart';
import '../../mobile/pages/mobile_user_form_page.dart';
import '../../mobile/pages/mobile_user_stores_page.dart';
import '../../support/pages/support_users_page.dart';
import '../../support/pages/support_user_form_page.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../main.dart';

/// Classe que contém as rotas do aplicativo
class AppRoutes {
  static final routes = [
    GetPage(
      name: '/login',
      page: () => const LoginPage(),
      transition: Transition.fadeIn,
    ),

    // Rotas de loja
    GetPage(
      name: '/stores',
      page: () => const StoresPage(),
      transition: Transition.fadeIn,
      middlewares: [
        RouteGuard(),
      ],
      binding: StoreBinding(),
    ),
    GetPage(
      name: '/stores/form',
      page: () => const StoreFormPage(),
      transition: Transition.rightToLeft,
      middlewares: [
        RouteGuard(),
      ],
      binding: StoreBinding(),
    ),
    GetPage(
      name: '/stores/details',
      page: () => const StoreDetailsPage(),
      transition: Transition.rightToLeft,
      middlewares: [
        RouteGuard(),
      ],
      binding: StoreBinding(),
    ),

    // Rotas de usuários mobile
    GetPage(
      name: '/mobile',
      page: () => const MobileUsersPage(),
      transition: Transition.fadeIn,
      middlewares: [
        RouteGuard(),
      ],
      binding: MobileBinding(),
    ),
    GetPage(
      name: '/mobile/form',
      page: () => const MobileUserFormPage(),
      transition: Transition.rightToLeft,
      middlewares: [
        RouteGuard(),
      ],
      binding: MobileBinding(),
    ),
    GetPage(
      name: '/mobile/stores',
      page: () => const MobileUserStoresPage(),
      transition: Transition.rightToLeft,
      middlewares: [
        RouteGuard(),
      ],
      binding: MobileBinding(),
    ),

    // Rotas de usuários de suporte
    GetPage(
      name: '/support',
      page: () => const SupportUsersPage(),
      transition: Transition.fadeIn,
      middlewares: [
        RouteGuard(),
      ],
      binding: SupportBinding(),
    ),
    GetPage(
      name: '/support/form',
      page: () => const SupportUserFormPage(),
      transition: Transition.rightToLeft,
      middlewares: [
        RouteGuard(),
      ],
      binding: SupportBinding(),
    ),
  ];
}

/// Binding para dependências de lojas
class StoreBinding extends Bindings {
  @override
  void dependencies() {
    initStoreDependencies();
  }
}

/// Binding para dependências de usuários mobile
class MobileBinding extends Bindings {
  @override
  void dependencies() {
    initMobileDependencies();
    // Mobile precisa das dependências de Store também
    initStoreDependencies();
  }
}

/// Binding para dependências de suporte
class SupportBinding extends Bindings {
  @override
  void dependencies() {
    initSupportDependencies();
  }
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

  @override
  GetPage? onPageCalled(GetPage? page) {
    return page;
  }

  @override
  List<Bindings>? onBindingsStart(List<Bindings>? bindings) {
    return bindings;
  }

  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
    return page;
  }

  @override
  Widget onPageBuilt(Widget page) {
    return page;
  }

  @override
  void onPageDispose() {}
}
