// lib/presentation/stores/pages/stores_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/stores_controller.dart';
import '../widgets/store_list_item.dart';
import '../widgets/store_filter.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_text_styles.dart';
import '../../shared/widgets/sidebar_menu.dart'; // Importar o menu
import '../../../core/widgets/custom_button.dart';

class StoresPage extends StatelessWidget {
  const StoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoresController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lojas',
          style: AppTextStyles.headline3,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      // Adicionar o drawer (menu lateral)
      drawer: const SidebarMenu(selectedIndex: 0),
      body: Column(
        children: [
          // Filtro e botão de nova loja
          StoreFilter(
            controller: controller,
            onAddStore: () => Get.toNamed('/stores/form'),
          ),
          const SizedBox(height: 16),

          // Lista de lojas
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Text(
                    controller.errorMessage,
                    style: AppTextStyles.bodyText2.copyWith(
                      color: AppColors.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              if (controller.stores.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/empty_stores.svg',
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhuma loja encontrada',
                        style: AppTextStyles.subtitle1,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Insira o CNPJ de uma loja no campo acima para\npoder visualizar e editar seus dados.',
                        style: AppTextStyles.bodyText2,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Nova loja',
                        icon: Icons.add,
                        onPressed: () => Get.toNamed('/stores/form'),
                        width: 200,
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.stores.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final store = controller.stores[index];
                  return StoreListItem(
                    store: store,
                    onTap: () => Get.toNamed(
                      '/stores/details',
                      arguments: store.id,
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
