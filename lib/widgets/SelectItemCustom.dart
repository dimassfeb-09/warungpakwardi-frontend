import 'package:flutter/material.dart';

import '../constant/color.dart';

class ItemSelected<T> {
  final T? key;
  final String? value;
  final String? subtitle;
  final String? trailing;
  final bool disabled;

  ItemSelected({
    required this.key,
    required this.value,
    this.subtitle,
    this.trailing,
    this.disabled = false,
  });
}

class SelectItemCustom<T> extends StatefulWidget {
  final String? title;
  final List<ItemSelected<T>> items;
  final ItemSelected<T>? selectedItem;
  final Function(ItemSelected<T> selectedItem) onSelect;
  final String hint;
  final Color? color;
  final bool searchable;
  final bool isLoading;

  const SelectItemCustom({
    super.key,
    required this.items,
    required this.onSelect,
    this.color,
    required this.hint,
    this.selectedItem,
    this.title,
    this.searchable = true,
    this.isLoading = false,
  });

  @override
  State<SelectItemCustom<T>> createState() => _SelectItemCustomState<T>();
}

class _SelectItemCustomState<T> extends State<SelectItemCustom<T>> {
  void _showSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SelectionSheet<T>(
        items: widget.items,
        onSelect: widget.onSelect,
        hint: widget.hint,
        searchable: widget.searchable,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Text(
            widget.title!,
            style: AppTypography.subHeader(context).copyWith(fontSize: 14),
          ),
          const SizedBox(height: 8),
        ],
        GestureDetector(
          onTap: () => _showSelectionSheet(context),
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? kBlack2Color : kWhiteColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.black.withOpacity(0.08),
              ),
              boxShadow: AppColors.softShadow(context).map((s) => s.copyWith(blurRadius: 5)).toList(),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: isDark ? Colors.white70 : Colors.black45,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.selectedItem?.value ?? widget.hint,
                    style: AppTypography.body(context).copyWith(
                      color: widget.selectedItem != null
                          ? (isDark ? kWhiteColor : kBlackColor)
                          : (isDark ? Colors.white38 : Colors.black38),
                      fontWeight: widget.selectedItem != null ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
                if (widget.isLoading)
                  const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectionSheet<T> extends StatefulWidget {
  final List<ItemSelected<T>> items;
  final Function(ItemSelected<T>) onSelect;
  final String hint;
  final bool searchable;

  const _SelectionSheet({
    required this.items,
    required this.onSelect,
    required this.hint,
    required this.searchable,
  });

  @override
  State<_SelectionSheet<T>> createState() => _SelectionSheetState<T>();
}

class _SelectionSheetState<T> extends State<_SelectionSheet<T>> {
  late List<ItemSelected<T>> filteredItems;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
    searchController.addListener(() {
      if (searchController.text.isEmpty && filteredItems.length != widget.items.length) {
        setState(() {
          filteredItems = widget.items;
        });
      }
    });
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = widget.items.where((item) {
        final matchesName = item.value?.toLowerCase().contains(query.toLowerCase()) ?? false;
        final matchesSubtitle = item.subtitle?.toLowerCase().contains(query.toLowerCase()) ?? false;
        return matchesName || matchesSubtitle;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: const EdgeInsets.only(top: 100),
      decoration: BoxDecoration(
        color: isDark ? kBlack2Color : kWhiteColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          if (widget.searchable)
            TextField(
              controller: searchController,
              autofocus: true,
              onChanged: _filterItems,
              style: AppTypography.body(context),
              decoration: InputDecoration(
                hintText: widget.hint,
                prefixIcon: const Icon(Icons.search_rounded, size: 22),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 20),
                        onPressed: () {
                          searchController.clear();
                          _filterItems('');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                filled: true,
                fillColor: isDark ? kBlackColor : kLightGreyColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          const SizedBox(height: 20),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: filteredItems.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: isDark ? Colors.white10 : Colors.black.withOpacity(0.04),
              ),
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return ListTile(
                  onTap: item.disabled
                      ? null
                      : () {
                          widget.onSelect(item);
                          Navigator.pop(context);
                        },
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  title: Text(
                    item.value ?? '',
                    style: AppTypography.title(context).copyWith(
                      color: item.disabled ? (isDark ? Colors.white24 : Colors.black26) : null,
                    ),
                  ),
                  subtitle: item.subtitle != null
                      ? Text(
                          item.subtitle!,
                          style: AppTypography.caption(context).copyWith(
                            color: item.disabled ? (isDark ? Colors.white10 : Colors.black12) : kGreenColor,
                          ),
                        )
                      : null,
                  trailing: item.trailing != null
                      ? Text(
                          item.trailing!,
                          style: AppTypography.title(context).copyWith(
                            fontSize: 14,
                            color: item.disabled ? (isDark ? Colors.white38 : Colors.black45) : kBluePrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                );
              },
            ),
          ),
          if (filteredItems.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Icon(Icons.search_off_rounded, size: 48, color: isDark ? Colors.white10 : Colors.black12),
                  const SizedBox(height: 16),
                  Text(
                    "Produk tidak ditemukan",
                    style: AppTypography.body(context).copyWith(color: kGreyDarkColor),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
