import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/support_controller.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_text_styles.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_dropdown.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/confirmation_dialog.dart';

class SupportUserFormPage extends StatelessWidget {
  const SupportUserFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SupportController>();
    final isEditing = controller.selectedUser != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar Usuário de Suporte' : 'Novo Usuário de Suporte',
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

                // Parceiro
                _buildPartnerDropdown(controller),
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
      }),
    );
  }

  Widget _buildPartnerDropdown(SupportController controller) {
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
}
