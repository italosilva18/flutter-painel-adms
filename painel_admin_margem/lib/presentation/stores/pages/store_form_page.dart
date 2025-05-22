import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/stores_controller.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_text_styles.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_dropdown.dart';
import '../../../core/widgets/custom_switch.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/confirmation_dialog.dart';

class StoreFormPage extends StatelessWidget {
  const StoreFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoresController>();
    final isEditing = controller.selectedStore != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar Loja' : 'Nova Loja',
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
                // Seção: Dados principais
                _buildSectionHeader('Dados principais'),
                const SizedBox(height: 16),

                // CNPJ
                CustomTextField(
                  label: 'CNPJ',
                  controller: controller.cnpjController,
                  keyboardType: TextInputType.number,
                  validator: controller.validateCnpj,
                  readOnly:
                      isEditing, // CNPJ não pode ser alterado após criação
                ),
                const SizedBox(height: 16),

                // Razão Social
                CustomTextField(
                  label: 'Razão Social',
                  controller: controller.companyController,
                  validator: controller.validateRequired,
                ),
                const SizedBox(height: 16),

                // Nome Fantasia
                CustomTextField(
                  label: 'Nome Fantasia',
                  controller: controller.tradeNameController,
                  validator: controller.validateRequired,
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

                // E-mail
                CustomTextField(
                  label: 'E-mail',
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateEmail,
                ),
                const SizedBox(height: 16),

                // Serial
                CustomTextField(
                  label: 'Serial',
                  controller: controller.serialController,
                  validator: controller.validateRequired,
                ),
                const SizedBox(height: 16),

                // Parceiro
                _buildPartnerDropdown(controller),
                const SizedBox(height: 16),

                // Segmento
                _buildSegmentDropdown(controller),
                const SizedBox(height: 16),

                // Tamanho
                _buildSizeDropdown(controller),
                const SizedBox(height: 24),

                // Seção: Endereço
                _buildSectionHeader('Endereço'),
                const SizedBox(height: 16),

                // Estado
                _buildStateDropdown(controller),
                const SizedBox(height: 16),

                // Cidade
                CustomTextField(
                  label: 'Cidade',
                  controller: controller.cityController,
                  validator: controller.validateRequired,
                ),
                const SizedBox(height: 16),

                // Bairro
                CustomTextField(
                  label: 'Bairro',
                  controller: controller.neighborhoodController,
                  validator: controller.validateRequired,
                ),
                const SizedBox(height: 16),

                // Rua / Logradouro
                CustomTextField(
                  label: 'Rua / Logradouro',
                  controller: controller.streetController,
                  validator: controller.validateRequired,
                ),
                const SizedBox(height: 16),

                // Número
                CustomTextField(
                  label: 'Número',
                  controller: controller.numberController,
                  validator: controller.validateRequired,
                ),
                const SizedBox(height: 24),

                // Seção: Serviços
                _buildSectionHeader('Serviços'),
                const SizedBox(height: 16),

                // Operações
                _buildOperationsCheckboxes(controller),
                const SizedBox(height: 16),

                // Status
                _buildStatusSwitches(controller),
                const SizedBox(height: 24),

                // Seção: Scanner de Produtos
                _buildSectionHeader('Scanner de Produtos'),
                const SizedBox(height: 16),

                // Scanner
                _buildScannerOptions(controller),
                const SizedBox(height: 32),

                // Botões de ação
                _buildActionButtons(context, controller, isEditing),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.headline3.copyWith(
            color: AppColors.primary,
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildPartnerDropdown(StoresController controller) {
    return Obx(() {
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
    });
  }

  Widget _buildSegmentDropdown(StoresController controller) {
    return Obx(() {
      final items = controller.segments.map((segment) {
        return DropdownMenuItem<String>(
          value: segment,
          child: Text(segment),
        );
      }).toList();

      return CustomDropdown<String>(
        label: 'Segmento',
        value: controller.selectedSegment.isNotEmpty
            ? controller.selectedSegment
            : null,
        items: items,
        onChanged: (value) {
          if (value != null) {
            controller.selectSegment(value);
          }
        },
        validator: controller.validateRequired,
        hint: 'Selecione um segmento',
      );
    });
  }

  Widget _buildSizeDropdown(StoresController controller) {
    return Obx(() {
      final items = controller.sizes.map((size) {
        return DropdownMenuItem<String>(
          value: size,
          child: Text(size),
        );
      }).toList();

      return CustomDropdown<String>(
        label: 'Porte',
        value:
            controller.selectedSize.isNotEmpty ? controller.selectedSize : null,
        items: items,
        onChanged: (value) {
          if (value != null) {
            controller.selectSize(value);
          }
        },
        validator: controller.validateRequired,
        hint: 'Selecione um porte',
      );
    });
  }

  Widget _buildStateDropdown(StoresController controller) {
    return Obx(() {
      final items = controller.states.map((state) {
        return DropdownMenuItem<String>(
          value: state['name'],
          child: Text(state['name']),
          onTap: () => controller.selectState(
            state['name'],
            int.parse(state['code']),
          ),
        );
      }).toList();

      return CustomDropdown<String>(
        label: 'Estado',
        value: controller.selectedState.isNotEmpty
            ? controller.selectedState
            : null,
        items: items,
        onChanged: (value) {
          if (value != null) {
            final state = controller.states.firstWhere(
              (s) => s['name'] == value,
              orElse: () => {'name': value, 'code': '0'},
            );
            controller.selectState(state['name'], int.parse(state['code']));
          }
        },
        validator: controller.validateRequired,
        hint: 'Selecione um estado',
      );
    });
  }

  Widget _buildOperationsCheckboxes(StoresController controller) {
    final operations = [
      {'id': 0, 'name': 'Atendimento'},
      {'id': 1, 'name': 'Estoque'},
      {'id': 2, 'name': 'Financeiro'},
      {'id': 3, 'name': 'Cadastro'},
      {'id': 4, 'name': 'Expedição'},
      {'id': 5, 'name': 'Compras'},
      {'id': 6, 'name': 'Verificação'},
      {'id': 7, 'name': 'Movimento'},
      {'id': 33, 'name': 'Loja'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Operações',
          style: AppTextStyles.label,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: operations.map((operation) {
            return Obx(() {
              final isSelected = controller.selectedOperations
                  .contains(operation['id'] as int);
              return FilterChip(
                label: Text(operation['name'] as String),
                selected: isSelected,
                onSelected: (selected) {
                  controller.toggleOperation(operation['id'] as int);
                },
                selectedColor: AppColors.primary.withOpacity(0.2),
                checkmarkColor: AppColors.primary,
              );
            });
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStatusSwitches(StoresController controller) {
    return Column(
      children: [
        Obx(() => CustomSwitchTile(
              title: 'Ativo',
              subtitle: 'A loja está ativa no sistema',
              value: controller.isActive,
              onChanged: controller.toggleActive,
            )),
        const SizedBox(height: 8),
        Obx(() => CustomSwitchTile(
              title: 'Offerta',
              subtitle: 'Habilitar o módulo Offerta',
              value: controller.isOfferta,
              onChanged: controller.toggleOfferta,
            )),
        const SizedBox(height: 8),
        Obx(() => CustomSwitchTile(
              title: 'Oppinar',
              subtitle: 'Habilitar o módulo Oppinar',
              value: controller.isOppinar,
              onChanged: controller.toggleOppinar,
            )),
        const SizedBox(height: 8),
        Obx(() => CustomSwitchTile(
              title: 'Prazzo',
              subtitle: 'Habilitar o módulo Prazzo',
              value: controller.isPrazzo,
              onChanged: controller.togglePrazzo,
            )),
      ],
    );
  }

  Widget _buildScannerOptions(StoresController controller) {
    return Column(
      children: [
        Obx(() => CustomSwitchTile(
              title: 'Scanner Ativo',
              subtitle: 'Habilitar scanner de produtos',
              value: controller.isScannerActive,
              onChanged: controller.toggleScannerActive,
            )),
        const SizedBox(height: 8),
        Obx(() => CustomSwitchTile(
              title: 'Beta',
              subtitle: 'Versão beta do scanner',
              value: controller.isScannerBeta,
              onChanged: controller.toggleScannerBeta,
              enabled: controller.isScannerActive,
            )),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    StoresController controller,
    bool isEditing,
  ) {
    return Row(
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
            onPressed: controller.saveStore,
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
                entityName: 'a loja ${controller.selectedStore!.tradeName}',
                onConfirm: () {
                  controller.deleteStore();
                },
              );
            },
          ),
        ],
      ],
    );
  }
}
