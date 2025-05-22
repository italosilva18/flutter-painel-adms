import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mobile_controller.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_text_styles.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_dropdown.dart';
import '../../../core/widgets/custom_switch.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../domain/entities/mobile_user.dart';

class MobileUserFormPage extends StatelessWidget {
  const MobileUserFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MobileController>();
    final isEditing = controller.selectedUser != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar Usuário Mobile' : 'Novo Usuário Mobile',
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
        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              // Tabs
              TabBar(
                tabs: const [
                  Tab(text: 'Dados Principais'),
                  Tab(text: 'Lojas'),
                ],
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                onTap: controller.changeTabIndex,
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // Tab 1: Dados Principais
                    _buildMainDataTab(context, controller, isEditing),

                    // Tab 2: Lojas
                    _buildStoresTab(context, controller, isEditing),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMainDataTab(
    BuildContext context,
    MobileController controller,
    bool isEditing,
  ) {
    if (controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Form(
      key: controller.formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nome
            CustomTextField(
              label: 'Nome',
              controller: controller.nameController,
              validator: controller.validateRequired,
            ),
            const SizedBox(height: 16),

            // E-mail
            CustomTextField(
              label: 'E-mail',
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              validator: controller.validateEmail,
            ),
            const SizedBox(height: 16),

            // Telefone
            CustomTextField(
              label: 'Telefone',
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              validator: controller.validateRequired,
            ),
            const SizedBox(height: 16),

            // Senha (opcional para edição)
            CustomTextField(
              label: 'Senha',
              controller: controller.passwordController,
              obscureText: true,
              validator: controller.validatePassword,
            ),
            const SizedBox(height: 16),

            // Tipo
            _buildTypeDropdown(controller),
            const SizedBox(height: 16),

            // Parceiro
            _buildPartnerDropdown(controller),
            const SizedBox(height: 16),

            // Status
            CustomSwitchTile(
              title: 'Ativo',
              subtitle: 'O usuário está ativo no sistema',
              value: controller.isActive,
              onChanged: controller.toggleActive,
            ),
            const SizedBox(height: 24),

            // Mensagem de erro
            if (controller.errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  controller.errorMessage,
                  style: AppTextStyles.bodyText2.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),

            // Botões de ação
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Cancelar',
                    type: ButtonType.secondary,
                    onPressed: () {
                      controller.clearSelection();
                      Get.back();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: 'Salvar',
                    onPressed: controller.saveUser,
                    isLoading: controller.isLoading,
                  ),
                ),
                if (isEditing) ...[
                  const SizedBox(width: 16),
                  CustomButton(
                    text: '',
                    icon: Icons.delete,
                    type: ButtonType.danger,
                    isFullWidth: false,
                    width: 56,
                    onPressed: () {
                      DeleteConfirmationDialog.show(
                        context: context,
                        entityName:
                            'o usuário ${controller.selectedUser!.name}',
                        onConfirm: () {
                          controller.deleteUser();
                        },
                      );
                    },
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoresTab(
    BuildContext context,
    MobileController controller,
    bool isEditing,
  ) {
    if (!isEditing) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.info_outline,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'Salve o usuário para\ngerenciar as lojas vinculadas',
              style: AppTextStyles.subtitle1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      children: [
        // Cabeçalho e botão para adicionar loja
        Padding(
          padding: const EdgeInsets.all(16),
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
                        '${store.address.city}, ${store.address.state}',
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
  }

  Widget _buildTypeDropdown(MobileController controller) {
    final types = [
      MobileUserType.admin.value,
      MobileUserType.seller.value,
      MobileUserType.customer.value,
    ];

    final items = types.map((type) {
      return DropdownMenuItem<String>(
        value: type,
        child: Text(type),
      );
    }).toList();

    return CustomDropdown<String>(
      label: 'Tipo',
      value: controller.selectedType,
      items: items,
      onChanged: (value) {
        if (value != null) {
          controller.selectType(value);
        }
      },
      validator: controller.validateRequired,
      hint: 'Selecione um tipo',
    );
  }

  Widget _buildPartnerDropdown(MobileController controller) {
    final items = controller.partners.map((partner) {
      return DropdownMenuItem<String>(
        value: partner['name'],
        child: Text(partner['name']),
        onTap: () => controller.selectPartner(
          partner['name'],
          partner['code'],
        ),
      );
    }).toList();

    return CustomDropdown<String>(
      label: 'Parceiro',
      value: controller.selectedPartner.isNotEmpty
          ? controller.selectedPartner
          : null,
      items: items,
      onChanged: (value) {
        if (value != null) {
          final partner = controller.partners.firstWhere(
            (p) => p['name'] == value,
            orElse: () => {'name': value, 'code': 0.0},
          );
          controller.selectPartner(partner['name'], partner['code']);
        }
      },
      validator: controller.validateRequired,
      hint: 'Selecione um parceiro',
    );
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
