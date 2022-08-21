import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import '../../../core/shared/ui_helpers.dart';
import 'package:educate_me/core/utils/constants/app_assets.dart';

import '../shared/shared_styles.dart';

class MultiSelectionCard extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;
  final String title;

  const MultiSelectionCard(
      {Key? key,
      required this.items,
      required this.title,
      required this.selectedItems})
      : super(key: key);

  @override
  State<MultiSelectionCard> createState() => _MultiSelectionCardState();
}

class _MultiSelectionCardState extends State<MultiSelectionCard> {
  @override
  Widget build(BuildContext context) {
    return [
      vSpaceSmall,
      Text(
        widget.title,
        style: kBodyStyle.copyWith(fontWeight: FontWeight.w700),
      ),
      vSpaceSmall,
      Image.asset(
        kIcDivider,
        height: 2,
      ),
      _buildWrap(),
    ]
        .toColumn(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center)
        .card(
            clipBehavior: Clip.antiAlias,
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: kBorderMedium));
  }

  Widget _buildWrap() {
    return Wrap(
      spacing: 4,
      runSpacing: 3,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: List.generate(widget.items.length, (index) {
        var item = widget.items[index];
        return ChoiceChip(
            labelStyle: kBodyStyle.copyWith(
                color: widget.selectedItems.contains(item)
                    ? Colors.white
                    : Colors.black),
            label: AutoSizeText(item),
            onSelected: (value) {
              setState(() {
                widget.selectedItems.contains(item)
                    ? widget.selectedItems.remove(item)
                    : widget.selectedItems.add(item);
              });
            },
            selected: widget.selectedItems.contains(item));
      }),
    );
  }
}
