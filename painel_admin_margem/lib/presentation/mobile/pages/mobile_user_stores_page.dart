import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mobile_controller.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/confirmation_dialog.dart';

class MobileUserStoresPage extends StatelessWidget {
  const MobileUserStoresPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MobileController>();
    final userId = Get.arguments as String;

    // Carrega o usuário e suas lojas
    _loadUserData(controller, userId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lojas Vinculadas',
          style: AppTextStyles.headline3,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            controller.clearSelection();
            Get.back();
          },
        ),
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.selectedUser == null) {
          return const Center(
            child: Text('Usuário não encontrado'),
          );
        }

        return Column(
          children: [
            // Informações do usuário
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: AppColors.primary,
                        radius: 24,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.selectedUser!.name,
                              style: AppTextStyles.subtitle1,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              controller.selectedUser!.email,
                              style: AppTextStyles.bodyText2,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tipo: ${controller.selectedUser!.type}',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomButton(
                        text: 'Editar',
                        icon: Icons.edit,
                        isFullWidth: false,
                        onPressed: () {
                          Get.toNamed('/mobile/form');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Cabeçalho e botão para adicionar loja
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Lojas vinculadas',
                    style: AppTextStyles.subtitle1,
                  ),
                  CustomButton(
                    text: 'Adicionar Loja',
                    icon: Icons.add,
                    isFullWidth: false,
                    onPressed: () {
                      _showAddStoreDialog(context, controller);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Lista de lojas vinculadas
            Expanded(
              child: controller.userStores.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.store_outlined,
                            size: 64,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhuma loja vinculada',
                            style: AppTextStyles.subtitle1,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Clique em "Adicionar Loja" para\nvincular uma loja a este usuário.',
                            style: AppTextStyles.bodyText2,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.userStores.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final store = controller.userStores[index];
                        return ListTile(
                          title: Text(
                            store.tradeName,
                            style: AppTextStyles.subtitle2,
                          ),
                          subtitle: Text(
                            '${store.cnpj} - ${store.address.city}, ${store.address.state}',
                            style: AppTextStyles.bodyText2.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: AppColors.error,
                            ),
                            onPressed: () {
                              ConfirmationDialog.show(
                                context: context,
                                title: 'Remover vínculo',
                                message:
                                    'Tem certeza que deseja remover o vínculo com a loja ${store.tradeName}?',
                                confirmButtonText: 'Remover',
                                isDanger: true,
                                onConfirm: () {
                                  controller.unlinkStoreFromUser(store);
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _loadUserData(
    MobileController controller,
    String userId,
  ) async {
    if (controller.selectedUser?.id != userId) {
      final result = await controller.getMobileUsersUseCase.repository
          .getMobileUserById(userId);

      result.fold(
        (failure) {
          Get.snackbar(
            'Erro',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.error,
            colorText: Colors.white,
          );
          Get.back();
        },
        (user) {
          controller.selectUser(user);
          controller.fetchUserStores();
        },
      );
    } else {
      controller.fetchUserStores();
    }
  }

  void _showAddStoreDialog(
    BuildContext context,
    MobileController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Adicionar Loja',
            style: AppTextStyles.headline3,
          ),
          content: SizedBox(
            width: 500,
            height: 400,
            child: Column(
              children: [
                // Campo de busca
                SearchTextField(
                  controller: controller.storeSearchController,
                  hint: 'Buscar loja por nome ou CNPJ',
                  onChanged: (value) {
                    controller.filterStores(value);
                  },
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

                    if (controller.filteredStores.isEmpty) {
                      return Center(
                        child: Text(
                          'Nenhuma loja encontrada',
                          style: AppTextStyles.bodyText2,
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: controller.filteredStores.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final store = controller.filteredStores[index];
                        final isLinked =
                            controller.userStores.any((s) => s.id == store.id);

                        return ListTile(
                          title: Text(
                            store.tradeName,
                            style: AppTextStyles.subtitle2,
                          ),
                          subtitle: Text(
                            '${store.cnpj} - ${store.address.city}, ${store.address.state}',
                            style: AppTextStyles.caption,
                          ),
                          trailing: isLinked
                              ? const Chip(
                                  label: Text('Vinculada'),
                                  backgroundColor: AppColors.success,
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                )
                              : TextButton(
                                  child: const Text('Adicionar'),
                                  onPressed: () {
                                    controller.linkStoreToUser(store);
                                    Navigator.of(context).pop();
                                  },
                                ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
          actions: [
            CustomButton(
              text: 'Cancelar',
              type: ButtonType.text,
              isFullWidth: false,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    // Carrega as lojas ao abrir o modal
    controller.fetchAllStores();
  }
}
