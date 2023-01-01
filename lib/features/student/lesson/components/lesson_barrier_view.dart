import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/data/lesson.dart';
import 'package:educate_me/features/student/lesson/components/practice_question_view.dart';
import 'package:educate_me/features/student/lesson/lesson_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../core/shared/app_colors.dart';
import '../../../../core/widgets/busy_button.dart';
import '../../../../core/widgets/image_app_bar.dart';

class LessonContentPageView extends ViewModelWidget<LessonViewModel> {
  const LessonContentPageView({
    Key? key,
    required this.lesson,
    required this.levelId,
    required this.topicId,
    required this.subTopicId,
  }) : super(key: key);
  final String levelId;
  final String topicId;
  final String subTopicId;
  final LessonModel lesson;

  @override
  Widget build(BuildContext context, LessonViewModel model) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return Scaffold(
      backgroundColor: kcBg,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.h),
        child: ImageSliderAppBarNonFloating(
          images: lesson.cover ?? '',
          title: lesson.title ?? '',
          onTap: () {
            model.goToPrv();
          },
        ),
      ),
      body: ResponsiveBuilder(builder: (context, _) {
        return PageView(
          controller: model.barrierController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            model.resetScroll();
          },
          children: List.generate(
              lesson.content?.length ?? 0,
              (index) => Stack(
                    children: [
                      SingleChildScrollView(
                        padding: fieldPadding,
                        child: Column(
                          children: [
                            index == 0
                                ? Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'text100'.tr,
                                      style: kBodyStyle.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ).paddingOnly(top: 12))
                                : emptyBox(),
                            vSpaceSmall,
                            LessonBarrierView(
                                content: lesson.content?[index] ?? ''),
                            vSpaceMedium,
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: Colors.white,
                          child: BoxButtonWidget(
                            radius: _.isTablet ? 17 : 8,
                            fontSize: _.isTablet ? 24 : 14,
                            buttonText:
                                '${'text093'.tr} (${index + 1}/${lesson.content?.length})',
                            onPressed: () => model.goToNextBarrier(),
                          ).paddingOnly(
                              top: 16,
                              left:
                                  _.isTablet ? kTabPaddingHorizontal * 1.2 : 16,
                              bottom: 16,
                              right: _.isTablet
                                  ? kTabPaddingHorizontal * 1.2
                                  : 16),
                        ),
                      )
                    ],
                  ))
            ..add(PracticeQuestionView(
                levelId: levelId,
                topicId: topicId,
                subTopicId: subTopicId,
                lesson: lesson)),
        );
      }),
    );
  }
}

class LessonBarrierView extends StatelessWidget {
  const LessonBarrierView({Key? key, required this.content}) : super(key: key);
  final String content;

  @override
  Widget build(BuildContext context) {
    return Html(
      data: content,
      customRenders: {
        tagMatcher("video"): CustomRender.widget(
          widget: (context, buildChildren) {
            var element = context.tree.element?.outerHtml ?? '';
            var trimmed = element.substring(24);
            var trimmedLast = trimmed.substring(0, trimmed.length - 10);

            YoutubePlayerController controller = YoutubePlayerController(
              initialVideoId: YoutubePlayer.convertUrlToId(trimmedLast) ?? '',
              flags: const YoutubePlayerFlags(
                autoPlay: false,
                mute: false,
              ),
            );

            return YoutubePlayer(
              controller: controller,
              showVideoProgressIndicator: true,
            );
          },
        )
      },
    );
  }
}
