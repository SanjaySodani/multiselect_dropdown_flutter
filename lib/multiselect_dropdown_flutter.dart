library multiselect_dropdown_flutter;

import 'dart:async';

import 'package:flutter/material.dart';

const double tileHeight = 50;
const double selectAllButtonHeight = 40;
const double searchOptionHeight = 40;

class MultiSelectDropdown extends StatefulWidget {
  /// List of options to select from
  final List list;

  /// `label` key in a Map to show as an option. Defaults to 'label'
  final String label;

  /// `id` key in a Map to identify an item. Defaults to 'id'
  final String id;

  /// `onChange` callback, called everytime when
  /// an item is added or removed with the new
  /// list as argument
  ///
  /// {@tool snippet}
  /// ```dart
  /// onChange: (List newList) {
  ///   setState(() {
  ///     selectedList = newList;
  ///   });
  /// }
  /// ```
  /// {@end-tool}
  final Function onChange;

  /// Number of items to show as text,
  /// beyond that it will show `n` selected
  final int numberOfItemsLabelToShow;

  /// Initially selected list
  final List selected;

  /// Decoration for input element
  final Decoration? boxDecoration;

  /// Dropdown size
  final bool isLarge;

  /// If the list is a simple list
  /// or a list of map
  final bool isSimpleList;

  /// Width of the input widget. If this
  /// is null the widget will try to take
  /// full width of the parent.
  ///
  /// When rendering in a Row it needs to have
  /// a strict parent or a fixed width as it grows
  /// horizontally
  final double? width;

  /// Text to show when selected list is empty
  final String whenEmpty;

  /// Includes a select all button when `true`
  final bool includeSelectAll;

  /// Includes a search option when `true`
  final bool includeSearch;

  /// Mutiple selection dropdown for List of Maps.
  MultiSelectDropdown({
    super.key,
    required this.list,
    required initiallySelected,
    this.label = 'label',
    this.id = 'id',
    required this.onChange,
    this.numberOfItemsLabelToShow = 3,
    Decoration? decoration,
    this.width,
    this.whenEmpty = 'Select options',
    this.isLarge = false,
    this.includeSelectAll = false,
    this.includeSearch = false,
  })  : selected = [...initiallySelected],
        isSimpleList = false,
        boxDecoration = decoration ??
            BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            );

  /// Mutiple selection dropdown for simple List.
  MultiSelectDropdown.simpleList({
    super.key,
    required this.list,
    required initiallySelected,
    required this.onChange,
    this.numberOfItemsLabelToShow = 3,
    Decoration? decoration,
    this.width,
    this.whenEmpty = 'Select options',
    this.isLarge = false,
    this.includeSelectAll = false,
    this.includeSearch = false,
  })  : selected = [...initiallySelected],
        label = '',
        id = '',
        isSimpleList = true,
        boxDecoration = decoration ??
            BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            );

  @override
  State<MultiSelectDropdown> createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  List filteredOptions = [];

  late final TextEditingController filterController;
  Timer? debounce;

  bool isSelected(data) {
    if (widget.isSimpleList) {
      return widget.selected.contains(data);
    } else {
      for (Map obj in widget.selected) {
        if (obj[widget.id] == data) {
          return true;
        }
      }
      return false;
    }
  }

  void handleOnChange(bool newValue, dynamic data) {
    if (newValue) {
      setState(() {
        widget.selected.add(data);
      });
    } else {
      if (widget.isSimpleList) {
        setState(() {
          widget.selected.remove(data);
        });
      } else {
        int itemIndex = widget.selected.indexWhere(
          (obj) => obj[widget.id] == data[widget.id],
        );
        if (itemIndex == -1) {
          return;
        } else {
          setState(() {
            widget.selected.removeAt(itemIndex);
          });
        }
      }
    }

    widget.onChange(widget.selected);
  }

  Widget buildTile(data) {
    if (widget.isSimpleList) {
      return _CustomTile(
        value: isSelected(data),
        onChanged: (bool newValue) {
          handleOnChange(newValue, data);
        },
        title: '$data',
      );
    } else {
      return _CustomTile(
        value: isSelected(data[widget.id]),
        onChanged: (bool newValue) {
          handleOnChange(newValue, data);
        },
        title: '${data[widget.label]}',
      );
    }
  }

  void onSearchTextChanged(String searchText) {
    if (debounce?.isActive ?? false) debounce?.cancel();

    debounce = Timer(const Duration(milliseconds: 300), () {
      if (searchText.isEmpty) {
        setState(() {
          filteredOptions = widget.list;
        });
      } else {
        searchText = searchText.toLowerCase();
        if (widget.isSimpleList) {
          List newList = widget.list.where((text) {
            return '$text'.toLowerCase().contains(searchText);
          }).toList();
          setState(() {
            filteredOptions = newList;
          });
        } else {
          List newList = widget.list.where((objData) {
            return '${objData[widget.label]}'
                .toLowerCase()
                .contains(searchText);
          }).toList();
          setState(() {
            filteredOptions = newList;
          });
        }
      }
    });
  }

  Widget buildSearchOption() {
    return TextField(
      controller: filterController,
      onChanged: onSearchTextChanged,
      textAlignVertical: TextAlignVertical.center,
      decoration: const InputDecoration(
        isDense: true,
        border: OutlineInputBorder(),
        hintText: 'filter...',
        constraints: BoxConstraints(
          minHeight: searchOptionHeight,
          maxHeight: searchOptionHeight,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
      ),
    );
  }

  Widget buildSelectAllButton() {
    return InkWell(
      onTap: () {
        if (widget.selected.length == widget.list.length) {
          widget.selected.clear();
        } else {
          widget.selected.clear();
          widget.selected.addAll(widget.list);
        }
        widget.onChange(widget.selected);
        setState(() {});
      },
      child: Container(
        height: selectAllButtonHeight,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey),
          ),
        ),
        child: const Text('Select all'),
      ),
    );
  }

  double getWidth(BoxConstraints boxConstraints) {
    if (widget.width != null &&
        widget.width != double.infinity &&
        widget.width != double.maxFinite) {
      return widget.width!;
    }
    if (boxConstraints.maxWidth == double.infinity ||
        boxConstraints.maxWidth == double.maxFinite) {
      debugPrint(
          "Invalid width given, MultiSelectDropdown's width will fallback to 250.");
      return 250;
    }
    return boxConstraints.maxWidth;
  }

  double getModalHeight() {
    double height = filteredOptions.length > 4
        ? widget.isLarge
            ? filteredOptions.length > 6
                ? 7 * tileHeight
                : filteredOptions.length * tileHeight
            : 5 * tileHeight
        : filteredOptions.length * tileHeight;

    if (widget.includeSelectAll) {
      height += selectAllButtonHeight;
    }

    if (widget.includeSearch) {
      height += searchOptionHeight;
    }

    return height;
  }

  String buildText() {
    if (widget.selected.isEmpty) {
      return widget.whenEmpty;
    }

    if (widget.numberOfItemsLabelToShow < widget.selected.length) {
      return '${widget.selected.length} selected';
    }

    if (widget.isSimpleList) {
      final int itemsToShow = widget.selected.length;
      String finalString = "";
      for (int i = 0; i < itemsToShow; i++) {
        finalString = '$finalString ${widget.selected[i]}, ';
      }
      return finalString.substring(0, finalString.length - 2);
    } else {
      final int itemsToShow = widget.selected.length;
      String finalString = "";
      for (int i = 0; i < itemsToShow; i++) {
        finalString = '$finalString ${widget.selected[i][widget.label]}, ';
      }
      return finalString.substring(0, finalString.length - 2);
    }
  }

  @override
  void initState() {
    super.initState();
    filterController = TextEditingController();
    filteredOptions = widget.list;
  }

  @override
  void dispose() {
    filterController.dispose();
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String textToShow = buildText();
    double modalHeight = getModalHeight();

    return LayoutBuilder(
      builder: (ctx, boxConstraints) {
        double modalWidth = getWidth(boxConstraints);

        return ConstrainedBox(
          constraints: BoxConstraints.expand(
            height: tileHeight,
            width: modalWidth,
          ),
          child: MenuAnchor(
            crossAxisUnconstrained: false,
            style: MenuStyle(
              fixedSize: MaterialStateProperty.resolveWith((states) {
                return Size(modalWidth, modalHeight);
              }),
              padding: MaterialStateProperty.resolveWith((states) {
                return EdgeInsets.zero;
              }),
            ),
            builder: (context, controller, _) {
              return InkWell(
                onTap: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: widget.boxDecoration,
                  width: modalWidth,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          textToShow,
                          style: const TextStyle(fontSize: 15),
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down_sharp),
                    ],
                  ),
                ),
              );
            },
            menuChildren: [
              if (widget.includeSearch) buildSearchOption(),
              if (widget.includeSelectAll) buildSelectAllButton(),
              ...filteredOptions.map((data) {
                return buildTile(data);
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}

class _CustomTile extends StatelessWidget {
  const _CustomTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  void handleOnChange() {
    if (value) {
      onChanged(false);
    } else {
      onChanged(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return InkWell(
      splashColor: themeData.primaryColor,
      hoverColor: Colors.black12,
      onTap: handleOnChange,
      child: SizedBox(
        height: tileHeight,
        child: Row(
          children: [
            const SizedBox(width: 6),
            Checkbox(
              fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                return themeData.primaryColor;
              }),
              value: value,
              onChanged: null,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(title),
            ),
          ],
        ),
      ),
    );
  }
}
