// lib/presentation/support/pages/support_users_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/support_controller.dart';
import '../widgets/support_user_list_item.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_text_styles.dart';
import '../../shared/widgets/sidebar_menu.dart'; // Importar o menu
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';

class SupportUsersPage extends StatelessWidget {
  const SupportUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SupportController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Usuários de Suporte',
          style: AppTextStyles.headline3,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      // Adicionar o drawer (menu lateral)
      drawer: const SidebarMenu(selectedIndex: 2),
      body: Column(
        children: [
          // Filtro e botão de novo usuário
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: SearchTextField(
                    controller: controller.emailSearchController,
                    hint: 'Buscar por e-mail',
                    onChanged: (_) {},
                    onClear: () {
                      controller.emailSearchController.clear();
                      controller.fetchUsers();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                CustomButton(
                  text: 'Buscar',
                  icon: Icons.search,
                  isFullWidth: false,
                  width: 120,
                  onPressed: controller.searchUserByEmail,
                ),
                const SizedBox(width: 16),
                CustomButton(
                  text: 'Novo usuário',
                  icon: Icons.add,
                  isFullWidth: false,
                  width: 160,
                  onPressed: () {
                    controller.clearSelection();
                    Get.toNamed('/support/form');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Lista de usuários
          Expanded(
            child: Obx(() {
              // O resto do conteúdo permanece o mesmo
              // ...
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

              if (controller.users.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/empty_users.png',
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhum usuário encontrado',
                        style: AppTextStyles.subtitle1,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Busque por e-mail ou crie um novo usuário.',
                        style: AppTextStyles.bodyText2,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Novo usuário',
                        icon: Icons.add,
                        onPressed: () {
                          controller.clearSelection();
                          Get.toNamed('/support/form');
                        },
                        width: 200,
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.users.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final user = controller.users[index];
                  return SupportUserListItem(
                    user: user,
                    onTap: () {
                      controller.selectUser(user);
                      Get.toNamed('/support/form');
                    },
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
