import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/stores_controller.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/utils/input_converter.dart';

class StoreDetailsPage extends StatefulWidget {
  const StoreDetailsPage({Key? key}) : super(key: key);

  @override
  State<StoreDetailsPage> createState() => _StoreDetailsPageState();
}

class _StoreDetailsPageState extends State<StoreDetailsPage> {
  late final StoresController controller;
  late final String storeId;
  final InputConverter inputConverter = Get.find<InputConverter>();

  @override
  void initState() {
    super.initState();
    controller = Get.find<StoresController>();
    storeId = Get.arguments as String;
    _loadStore();
  }

  Future<void> _loadStore() async {
    if (controller.selectedStore?.id != storeId) {
      final result =
          await controller.getStoresUseCase.repository.getStoreById(storeId);
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
        (store) {
          controller.selectStore(store);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalhes da Loja',
          style: AppTextStyles.headline3,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            controller.clearSelection();
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Get.toNamed('/stores/form'),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading || controller.selectedStore == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final store = controller.selectedStore!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(
                title: 'Dados principais',
                children: [
                  _buildInfoRow('CNPJ', inputConverter.formatCnpj(store.cnpj)),
                  _buildInfoRow('Razão Social', store.company),
                  _buildInfoRow('Nome Fantasia', store.tradeName),
                  _buildInfoRow(
                      'Telefone', inputConverter.formatPhone(store.phone)),
                  _buildInfoRow('E-mail', store.email),
                  _buildInfoRow('Serial', store.serial),
                  _buildInfoRow('Parceiro', store.partner),
                  _buildInfoRow('Segmento', store.segment),
                  _buildInfoRow('Porte', store.size),
                  _buildInfoRow('Status', store.active ? 'Ativo' : 'Inativo',
                      valueColor:
                          store.active ? AppColors.success : AppColors.error),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                title: 'Endereço',
                children: [
                  _buildInfoRow('Estado', store.address.state),
                  _buildInfoRow('Cidade', store.address.city),
                  _buildInfoRow('Bairro', store.address.neighborhood),
                  _buildInfoRow('Rua', store.address.street),
                  _buildInfoRow('Número', store.address.number),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                title: 'Serviços',
                children: [
                  _buildInfoRow(
                      'Operações', _formatOperations(store.operation)),
                  _buildInfoRow('Offerta', store.offerta ? 'Sim' : 'Não',
                      valueColor: store.offerta
                          ? AppColors.success
                          : AppColors.textTertiary),
                  _buildInfoRow('Oppinar', store.oppinar ? 'Sim' : 'Não',
                      valueColor: store.oppinar
                          ? AppColors.success
                          : AppColors.textTertiary),
                  _buildInfoRow('Prazzo', store.prazzo ? 'Sim' : 'Não',
                      valueColor: store.prazzo
                          ? AppColors.success
                          : AppColors.textTertiary),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                title: 'Scanner de Produtos',
                children: [
                  _buildInfoRow('Ativo', store.scanner.active ? 'Sim' : 'Não',
                      valueColor: store.scanner.active
                          ? AppColors.success
                          : AppColors.textTertiary),
                  _buildInfoRow('Beta', store.scanner.beta ? 'Sim' : 'Não',
                      valueColor: store.scanner.beta
                          ? AppColors.success
                          : AppColors.textTertiary),
                  if (store.scanner.expire > 0)
                    _buildInfoRow(
                        'Expiração',
                        DateTime.fromMillisecondsSinceEpoch(
                                store.scanner.expire)
                            .toString()),
                ],
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Editar Loja',
                icon: Icons.edit,
                onPressed: () => Get.toNamed('/stores/form'),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoCard(
      {required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.subtitle1.copyWith(
                color: AppColors.primary,
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTextStyles.bodyText2.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyText2.copyWith(
                color: valueColor ?? AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatOperations(List<int> operations) {
    final operationsMap = {
      0: 'Atendimento',
      1: 'Estoque',
      2: 'Financeiro',
      3: 'Cadastro',
      4: 'Expedição',
      5: 'Compras',
      6: 'Verificação',
      7: 'Movimento',
      33: 'Loja',
    };

    final operationNames =
        operations.map((id) => operationsMap[id] ?? 'Op. $id').toList();

    return operationNames.join(', ');
  }
}
