import 'package:flutter/material.dart';

import '../shared/ui_helpers.dart';
import 'app_info.dart';
import 'loading_anim.dart';

class AppStreamList extends StatelessWidget {
  final Stream stream;
  final Widget Function(int, dynamic) itemBuilder;
  final IconData emptyIcon;
  final String emptyText;
  final bool isDark;
  final Widget separator;

  const AppStreamList(
      {Key? key,
      required this.stream,
      required this.itemBuilder,
      this.emptyIcon = Icons.error_outline,
      this.emptyText = 'no_request',
      this.isDark = false,
      this.separator = vSpaceSmall})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: stream,
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: LoadingAnim());
          }
          List<dynamic> data = snapshot.data as List<dynamic>;
          if (data.isEmpty) {
            return AppInfoWidget(
              translateKey: emptyText,
              iconData: emptyIcon,
              isDark: isDark,
              icon: null,
            );
          }
          return ListView.separated(
            itemCount: data.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) => itemBuilder(index, data[index]),
            separatorBuilder: (_, index) => separator,
          );
        });
  }
}
