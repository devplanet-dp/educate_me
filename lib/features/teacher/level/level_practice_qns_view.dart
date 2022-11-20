// import 'package:educate_me/features/teacher/level/teacher_qns_view.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:stacked/stacked.dart';
// import 'package:styled_widget/styled_widget.dart';
//
// import '../../../core/utils/device_utils.dart';
// import '../../../core/widgets/app_info.dart';
// import '../../../core/widgets/busy_overlay.dart';
// import 'teacher_level_view_model.dart';
//
// class LevelPracticeQnsView extends StatelessWidget {
//   const LevelPracticeQnsView(
//       {Key? key,
//       required this.levelId,
//       this.topicId,
//       this.subTopicId,
//       this.lessonId})
//       : super(key: key);
//   final String levelId;
//   final String? topicId;
//   final String? subTopicId;
//   final String? lessonId;
//
//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<TeacherLevelViewModel>.reactive(
//       builder: (context, vm, child) => GestureDetector(
//         onTap: () => DeviceUtils.hideKeyboard(context),
//         child: BusyOverlay(
//           show: vm.isBusy,
//           child: Scaffold(
//             appBar: AppBar(
//               elevation: 0,
//               title: const Text('Add Questions here'),
//             ),
//             body: .isEmpty
//                 ? const AppInfoWidget(
//                         translateKey: 'No questions found',
//                         iconData: Iconsax.message_question)
//                     .center()
//                 : QuestionsGrid(
//                     levelId: levelId,
//                     topicId: topicId,
//                     subTopicId: subTopicId,
//                     lessonId: lessonId,
//                     isStartUp: false,
//                   ),
//           ),
//         ),
//       ),
//       viewModelBuilder: () => TeacherLevelViewModel(),
//     );
//   }
// }
///todo add practice question edit