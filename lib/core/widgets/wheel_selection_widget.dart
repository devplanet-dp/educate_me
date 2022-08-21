import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/utils/constants/app_assets.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import 'cutsom_check_tile.dart';

class WheelSelectionWidget extends StatelessWidget {
  final List<String> items;
  final Function(String) onItemSelected;
  final VoidCallback showOnProfileToggle;
  final bool showOnProfile;

  const WheelSelectionWidget(
      {Key? key,
      required this.items,
      required this.onItemSelected,
      required this.showOnProfileToggle,
      required this.showOnProfile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Picker(
                selectionOverlay: Image.asset(
                  kImgSectionOverlay,
                ),
                hideHeader: true,
                columnPadding: fieldPaddingAll,
                itemExtent: 60,
                looping: false,
                onSelect: (picker, __, ___) {
                 return onItemSelected((picker.adapter as PickerDataAdapter)
                      .getSelectedValues()[0]);
                },
                textAlign: TextAlign.center,
                adapter: PickerDataAdapter(
                    data: List.generate(
                        items.length,
                        (index) => PickerItem(
                            text: Text(items[index]).center(),
                            value: items[index]))),
                height: 200)
            .makePicker(),
        vSpaceMedium,
        CustomCheckTile(
            isSelected: showOnProfile,
            onToggle: showOnProfileToggle,
            title: 'text027'.tr)
      ],
    );
  }
}
