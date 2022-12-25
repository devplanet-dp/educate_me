import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/features/student/navigation/navigation_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/shared/shared_styles.dart';
import '../../../core/widgets/two_row_button.dart';
import '../../signin/components/custom_app_bar.dart';

class LanChangeView extends StatelessWidget {
  const LanChangeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NavigationViewModel>.reactive(
      builder: (context, vm, child) => ResponsiveBuilder(
        builder: (context,_) {
          return Scaffold(
            backgroundColor: kcBg,
            bottomNavigationBar: TwoRowButton(
              onPositiveTap: () =>vm.updateChildAccountDetails(),
              onNegativeTap: () => Get.back(),
              negativeText: 'text043'.tr,
              positiveText: 'text065'.tr,
              isBusy: vm.isBusy,
            ).paddingSymmetric(horizontal: _.isTablet?kTabPaddingHorizontal:0),
            appBar: PreferredSize(
              preferredSize:  const Size.fromHeight(kAppToolbarHeight),
              child: SwitchUserAppBar(
                title: 'text063'.tr,
                onUserUpdated: (){
                  vm.initChildAccountDetails();
                },
              ),
            ),
            body: [
              vSpaceMedium,
              _.isTablet?vSpaceSmall:emptyBox(),
              Text(
                'text063'.tr,
                style: kBodyStyle,
              ),
              vSpaceSmall,
              _buildLangCard(vm),
            ]
                .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
                .paddingSymmetric(horizontal: _.isTablet?kTabPaddingHorizontal: 16),
          );
        }
      ),
      viewModelBuilder: () => NavigationViewModel(),
    );
  }

  Widget _buildLangCard(NavigationViewModel model) => InkWell(
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
        ].toRow().paddingSymmetric(horizontal: 16, vertical: 14).decorated(
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
    return ViewModelBuilder<NavigationViewModel>.reactive(
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
      viewModelBuilder: () => NavigationViewModel(),
    );
  }
}
