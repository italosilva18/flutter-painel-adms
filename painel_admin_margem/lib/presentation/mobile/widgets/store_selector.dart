import 'package:flutter/material.dart';
import '../../../domain/entities/store.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_text_styles.dart';
import '../../../core/widgets/custom_text_field.dart';

class StoreSelector extends StatefulWidget {
  final List<Store> stores;
  final List<Store> selectedStores;
  final Function(Store) onStoreSelected;
  final Function(Store) onStoreRemoved;
  final bool isLoading;

  const StoreSelector({
    super.key,
    required this.stores,
    required this.selectedStores,
    required this.onStoreSelected,
    required this.onStoreRemoved,
    this.isLoading = false,
  });

  @override
  State<StoreSelector> createState() => _StoreSelectorState();
}

class _StoreSelectorState extends State<StoreSelector> {
  final TextEditingController _searchController = TextEditingController();
  List<Store> _filteredStores = [];

  @override
  void initState() {
    super.initState();
    _filteredStores = List.from(widget.stores);
    _searchController.addListener(_filterStores);
  }

  @override
  void didUpdateWidget(StoreSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stores != widget.stores) {
      _filteredStores = List.from(widget.stores);
      _filterStores();
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterStores);
    _searchController.dispose();
    super.dispose();
  }

  void _filterStores() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredStores = List.from(widget.stores);
      } else {
        _filteredStores = widget.stores.where((store) {
          return store.tradeName.toLowerCase().contains(query) ||
              store.company.toLowerCase().contains(query) ||
              store.cnpj.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Campo de busca
        SearchTextField(
          controller: _searchController,
          hint: 'Buscar loja por nome ou CNPJ',
          onChanged: (_) => _filterStores(),
        ),
        const SizedBox(height: 16),

        // Lista de lojas disponíveis
        Text(
          'Lojas disponíveis',
          style: AppTextStyles.subtitle2,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: widget.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _filteredStores.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhuma loja encontrada',
                        style: AppTextStyles.bodyText2.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _filteredStores.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final store = _filteredStores[index];
                        final isSelected =
                            widget.selectedStores.any((s) => s.id == store.id);

                        return ListTile(
                          title: Text(
                            store.tradeName,
                            style: AppTextStyles.bodyText2,
                          ),
                          subtitle: Text(
                            '${store.cnpj} - ${store.address.city}, ${store.address.state}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                          trailing: isSelected
                              ? OutlinedButton(
                                  onPressed: () => widget.onStoreRemoved(store),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.error,
                                    side: const BorderSide(
                                      color: AppColors.error,
                                    ),
                                  ),
                                  child: const Text('Remover'),
                                )
                              : OutlinedButton(
                                  onPressed: () =>
                                      widget.onStoreSelected(store),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.primary,
                                    side: const BorderSide(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  child: const Text('Adicionar'),
                                ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
