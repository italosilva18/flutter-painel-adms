import 'package:flutter/material.dart';
import '../../presentation/shared/theme/app_colors.dart';
import '../../presentation/shared/theme/app_text_styles.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final String? hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?) onChanged;
  final String? Function(T?)? validator;
  final bool isEnabled;

  const CustomDropdown({
    Key? key,
    required this.label,
    this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.label,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: isEnabled ? onChanged : null,
          validator: validator,
          isExpanded: true,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: AppColors.textSecondary,
          ),
          style: AppTextStyles.bodyText2.copyWith(
            color: isEnabled ? AppColors.textPrimary : AppColors.textTertiary,
          ),
          hint: hint != null
              ? Text(
                  hint!,
                  style: AppTextStyles.bodyText2.copyWith(
                    color: AppColors.textTertiary,
                  ),
                )
              : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: isEnabled ? Colors.white : AppColors.backgroundLight,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.border,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.border,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1.5,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.border,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Dropdown com suporte a pesquisa
class SearchableDropdown<T> extends StatefulWidget {
  final String label;
  final String? hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?) onChanged;
  final String? Function(T?)? validator;
  final bool isEnabled;
  final String searchHint;
  final Function(String)? onSearch;

  const SearchableDropdown({
    Key? key,
    required this.label,
    this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.isEnabled = true,
    this.searchHint = 'Pesquisar...',
    this.onSearch,
  }) : super(key: key);

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  final TextEditingController _searchController = TextEditingController();
  List<DropdownMenuItem<T>> _filteredItems = [];
  bool _isOpen = false;
  final LayerLink _layerLink = LayerLink();
  late OverlayEntry _overlayEntry;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(widget.items);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _isOpen) {
        _closeDropdown();
      }
    });
  }

  @override
  void didUpdateWidget(SearchableDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _filteredItems = List.from(widget.items);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    if (_isOpen) {
      _overlayEntry.remove();
    }
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = List.from(widget.items);
      } else {
        _filteredItems = widget.items.where((item) {
          final String itemText = item.child.toString().toLowerCase();
          return itemText.contains(query.toLowerCase());
        }).toList();
      }
    });

    if (widget.onSearch != null) {
      widget.onSearch!(query);
    }

    _updateOverlay();
  }

  void _openDropdown() {
    _focusNode.requestFocus();
    _isOpen = true;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry);
  }

  void _closeDropdown() {
    _isOpen = false;
    _overlayEntry.remove();
    _searchController.clear();
    _filterItems('');
  }

  void _updateOverlay() {
    if (_isOpen) {
      _overlayEntry.markNeedsBuild();
    }
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: 300,
                  minWidth: size.width,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: widget.searchHint,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.textTertiary,
                            size: 20,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: AppColors.textTertiary,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    _filterItems('');
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        onChanged: _filterItems,
                      ),
                    ),
                    const Divider(height: 1),
                    Flexible(
                      child: _filteredItems.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  'Nenhum item encontrado',
                                  style: TextStyle(
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: _filteredItems.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: _filteredItems[index].child,
                                  selected: _filteredItems[index].value ==
                                      widget.value,
                                  selectedTileColor: AppColors.backgroundLight,
                                  onTap: () {
                                    widget
                                        .onChanged(_filteredItems[index].value);
                                    _closeDropdown();
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String selectedText = widget.value != null
        ? widget.items
            .firstWhere(
              (item) => item.value == widget.value,
              orElse: () => DropdownMenuItem<T>(
                value: null,
                child: Text(
                  widget.hint ?? '',
                  style: AppTextStyles.bodyText2.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            )
            .child
            .toString()
        : widget.hint ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.label,
        ),
        const SizedBox(height: 8),
        CompositedTransformTarget(
          link: _layerLink,
          child: InkWell(
            onTap: widget.isEnabled
                ? () {
                    if (_isOpen) {
                      _closeDropdown();
                    } else {
                      _openDropdown();
                    }
                  }
                : null,
            child: FormField<T>(
              validator: widget.validator,
              builder: (FormFieldState<T> state) {
                return InputDecorator(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: widget.isEnabled
                        ? Colors.white
                        : AppColors.backgroundLight,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.border,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.border,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.error,
                        width: 1,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.error,
                        width: 1.5,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.border,
                        width: 1,
                      ),
                    ),
                    errorText: state.errorText,
                    suffixIcon: const Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  isEmpty: selectedText.isEmpty,
                  child: Text(
                    selectedText,
                    style: AppTextStyles.bodyText2.copyWith(
                      color: widget.isEnabled
                          ? AppColors.textPrimary
                          : AppColors.textTertiary,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
