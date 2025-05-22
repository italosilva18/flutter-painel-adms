import 'package:flutter/material.dart';
import '../controllers/stores_controller.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_button.dart';

class StoreFilter extends StatelessWidget {
  final StoresController controller;
  final VoidCallback? onAddStore;

  const StoreFilter({
    super.key,
    required this.controller,
    this.onAddStore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: SearchTextField(
              controller: controller.cnpjSearchController,
              hint: 'Insira o CNPJ da loja',
              onChanged: (_) {},
              onClear: () {
                controller.cnpjSearchController.clear();
                controller.fetchStores();
              },
            ),
          ),
          const SizedBox(width: 16),
          CustomButton(
            text: 'Buscar',
            icon: Icons.search,
            isFullWidth: false,
            width: 120,
            onPressed: controller.searchStoreByCnpj,
          ),
          const SizedBox(width: 16),
          CustomButton(
            text: 'Nova loja',
            icon: Icons.add,
            isFullWidth: false,
            width: 120,
            onPressed: () {
              controller.clearSelection();
              if (onAddStore != null) {
                onAddStore!();
              }
            },
          ),
        ],
      ),
    );
  }
}
