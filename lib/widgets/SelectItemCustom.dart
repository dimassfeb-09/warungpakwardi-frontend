import 'package:flutter/material.dart';

import '../constant/color.dart';

class ItemSelected<T> {
  final T? key;
  final String? value;
  final bool disabled;

  ItemSelected({required this.key, required this.value, this.disabled = false});
}

class SelectItemCustom<T> extends StatefulWidget {
  final String? title;
  final List<ItemSelected<T>> items;
  final ItemSelected<T>? selectedItem;
  final Function(ItemSelected<T> selectedItem) onSelect;
  final String hint;
  final Color? color;
  final Color? selectedColor;
  final bool? searchable;
  final bool isLoading;

  const SelectItemCustom({
    super.key,
    required this.items,
    required this.onSelect,
    this.color,
    required this.hint,
    this.selectedItem,
    this.selectedColor = kGreyColor,
    this.title,
    this.searchable = true,
    this.isLoading = false,
  });

  @override
  State<SelectItemCustom<T>> createState() => _SelectItemCustomState<T>();
}

class _SelectItemCustomState<T> extends State<SelectItemCustom<T>> {
  bool isDropdownOpen = false;
  ItemSelected<T>? selectedItem;
  List<ItemSelected<T>> filteredItems = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedItem = widget.selectedItem;
    filteredItems = widget.items;
  }

  @override
  void didUpdateWidget(covariant SelectItemCustom<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      setState(() {
        filteredItems = widget.items;
      });
    }

    if (widget.selectedItem != oldWidget.selectedItem) {
      setState(() {
        selectedItem = widget.selectedItem;
      });
    }
  }

  void toggleDropdown() {
    if (widget.isLoading) return;
    setState(() {
      isDropdownOpen = !isDropdownOpen;
      if (!isDropdownOpen) {
        searchController.clear();
        filteredItems = widget.items;
      }
    });
  }

  void selectItem(ItemSelected<T> item) {
    if (widget.isLoading) return;
    setState(() {
      selectedItem = item;
      isDropdownOpen = false;
      searchController.clear();
      filteredItems = widget.items;
      widget.onSelect(item);
    });
  }

  void filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = widget.items;
      } else {
        filteredItems =
            widget.items.where((item) {
              return item.value?.toLowerCase().contains(query.toLowerCase()) ??
                  false;
            }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        if (widget.title != null)
          Text(
            widget.title!,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        GestureDetector(
          onTap: toggleDropdown,
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            width: mediaQueryWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            alignment: Alignment.center,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.hint,
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                if (!widget.isLoading)
                  Icon(
                    isDropdownOpen
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                  ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: mediaQueryWidth,
          constraints: BoxConstraints(
            maxHeight:
                isDropdownOpen ? MediaQuery.of(context).size.height * 0.3 : 0,
          ),
          decoration: BoxDecoration(
            border:
                isDropdownOpen
                    ? Border.all(color: Colors.grey)
                    : Border.all(color: Colors.transparent),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          child:
              isDropdownOpen
                  ? SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.searchable == true)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: TextField(
                              controller: searchController,
                              onChanged: filterItems,
                              decoration: InputDecoration(
                                hintText: "Search...",
                                prefixIcon: const Icon(Icons.search),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            return InkWell(
                              onTap:
                                  item.disabled ? null : () => selectItem(item),
                              child: Container(
                                color:
                                    item.disabled
                                        ? kGreyColor.withAlpha(50)
                                        : null,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 16,
                                ),
                                child: Text(
                                  '${item.value}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: kBlackColor,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                  : null,
        ),
      ],
    );
  }
}
