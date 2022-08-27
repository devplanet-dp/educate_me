import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../../core/shared/shared_styles.dart';
import '../qns_view_model.dart';

class QnsTypeSelector extends ViewModelWidget<QnsViewModel> {
  const QnsTypeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, QnsViewModel model) {
    return [
      Text('Question type',style: kBody1Style.copyWith(fontWeight: FontWeight.bold),),
      const Expanded(child: SizedBox()),
      ChoiceChip(
        label: const Text('Multiple Choice'),
        selected: model.isMultipleChoice,
        onSelected: (value) => model.isMultipleChoice = true,
      ),
      ChoiceChip(
        label: const Text('Input'),
        selected: !model.isMultipleChoice,
        onSelected: (value) => model.isMultipleChoice = false,
      )
    ].toRow();
  }
}
