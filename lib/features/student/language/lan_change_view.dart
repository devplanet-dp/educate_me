import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/features/student/language/language_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/shared/shared_styles.dart';

class LanChangeView extends StatelessWidget {
  const LanChangeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LangViewModel>.reactive(
      builder: (context, vm, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: true,
          title: Text(
            'text063'.tr,
            style: kSubheadingStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: [
          vSpaceSmall,
          Text(
            'text063'.tr,
            style: kBodyStyle,
          ),
          vSpaceSmall,
          _buildLangCard(vm),
        ]
            .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
            .paddingSymmetric(horizontal: 16),
      ),
      viewModelBuilder: () => LangViewModel(),
    );
  }

  Widget _buildLangCard(LangViewModel model) => InkWell(
        onTap: () => Get.bottomSheet(
            LanguageSelectorSheet(
              onLanSelected: () => model.notifyListeners(),
            ),
            isScrollControlled: true),
        child: [
          Text(
            model.languageName ?? '',
            style: kBody1Style.copyWith(color: kcTextGrey),
          ),
          const Expanded(child: SizedBox()),
          const Icon(
            Icons.chevron_right,
            color: kcTextGrey,
          )
        ].toRow().paddingSymmetric(horizontal: 16, vertical: 8).decorated(
          boxShadow: [
            BoxShadow(
              color: kcTextGrey.withOpacity(0.1),
              spreadRadius: 4,
              blurRadius: 4,
              offset: const Offset(2, 3), // changes position of shadow
            ),
          ],
          color: Colors.white,
        ),
      );
}

class LanguageSelectorSheet extends StatelessWidget {
  const LanguageSelectorSheet({Key? key, required this.onLanSelected})
      : super(key: key);
  final VoidCallback onLanSelected;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LangViewModel>.reactive(
      builder: (context, model, child) => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: kBorderMedium),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
              model.languages.length,
              (index) => ListTile(
                    onTap: () {
                      model.onLanguageSelected(model.languages[index]['code']);
                      onLanSelected();
                      Get.back();
                    },
                    title: Text(
                      model.languages[index]['name'],
                      style: kBodyStyle.copyWith(
                          color: model.languages[index]['name'] ==
                                  model.languageName
                              ? kcPrimaryColor
                              : Colors.black),
                    ),
                  )),
        ),
      ),
      viewModelBuilder: () => LangViewModel(),
    );
  }
}
