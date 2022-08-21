// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:stacked/stacked.dart';
// import 'package:styled_widget/styled_widget.dart';
// import 'package:sugu/ui/shared/app_colors.dart';
// import 'package:sugu/ui/shared/shared_styles.dart';
// import 'package:sugu/ui/shared/ui_helpers.dart';
// import 'package:sugu/ui/view/signin/components/fgt_pwd_button.dart';
// import 'package:sugu/ui/view/signin/components/google_button.dart';
// import 'package:sugu/ui/view/signin/components/or_separator.dart';
// import 'package:sugu/ui/widgets/background_overlay.dart';
// import 'package:sugu/ui/widgets/brand_bg_widget.dart';
// import 'package:sugu/ui/widgets/busy_button.dart';
// import 'package:sugu/ui/widgets/busy_overlay.dart';
// import 'package:sugu/ui/widgets/rich_text.dart';
// import 'package:sugu/ui/widgets/text_field_widget.dart';
// import 'package:sugu/utils/constants/app_assets.dart';
// import 'package:sugu/utils/constants/app_constants.dart';
// import 'package:sugu/utils/device_utils.dart';
// import 'package:sugu/viewmodel/signin/signin_view_model.dart';
// import 'package:the_apple_sign_in/apple_sign_in_button.dart' as apple;
//
// import '../signup/signup_view.dart';
//
// class SignInView extends StatelessWidget {
//   const SignInView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<SignInViewModel>.reactive(
//       onModelReady: (model) {
//         model.checkAppleSignAvailable();
//       },
//       builder: (context, vm, child) => GestureDetector(
//         onTap: () => DeviceUtils.hideKeyboard(context),
//         child: SafeArea(
//           child: Scaffold(
//             body: Stack(
//               children: [
//                 const BrandBgWidget(imgName: kImgBg),
//                 const Align(
//                   alignment: Alignment.bottomCenter,
//                   child: BackgroundOverlayWidget(
//                     isDark: true,
//                   ),
//                 ),
//                 _buildBody(vm, context),
//
//               ],
//             ),
//           ),
//         ),
//       ),
//       viewModelBuilder: () => SignInViewModel(),
//     );
//   }
//
//   SingleChildScrollView _buildBody(SignInViewModel vm, BuildContext context) {
//     return SingleChildScrollView(
//       padding: fieldPadding,
//       child: Form(
//         key: vm.formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             vSpaceMedium,
//             Text(
//               kAppName,
//               style: GoogleFonts.nunitoSans(
//                   wordSpacing: 8,
//                   fontSize: 32,
//                   color: kcPrimaryColor,
//                   fontWeight: FontWeight.bold),
//             ),
//             vSpaceMedium,
//             Text(
//               'sign_in'.tr,
//               style: kHeading3Style.copyWith(fontWeight: FontWeight.w600),
//             ),
//             vSpaceSmall,
//             vSpaceMedium,
//             AppTextField(
//               controller: vm.usernameTEC,
//               hintText: 'email.hint'.tr,
//               isEmail: true,
//               isDark: true,
//               textColor: kcPrimaryColor,
//               fillColor: Colors.transparent,
//               borderColor: kcStroke,
//               label: 'email',
//               validator: (value) {
//                 if (!GetUtils.isEmail(value!)) {
//                   return 'email.hint'.tr;
//                 }
//                 return null;
//               },
//             ),
//             vSpaceSmall,
//             AppTextField(
//                 controller: vm.passwordTEC,
//                 hintText: 'pwd.hint'.tr,
//                 isPassword: vm.isObscure,
//                 isDark: true,
//                 fillColor: Colors.transparent,
//                 suffix: InkWell(
//                   onTap: () => vm.toggleObscure(),
//                   child: Icon(
//                     vm.isObscure
//                         ? Icons.visibility_off_outlined
//                         : Icons.visibility_outlined,
//                     color: kcPrimaryColor,
//                     size: 18,
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'pwd.hint'.tr;
//                   }
//                   return null;
//                 },
//                 label: 'pwd'),
//             vSpaceSmall,
//             const Align(
//               alignment: Alignment.topRight,
//               child: ForgotPwdButton(),
//             ),
//             vSpaceMedium,
//             BoxButtonWidget(
//               buttonText: 'sign_in'.tr,
//               isLoading: vm.isBusy,
//               onPressed: () {
//                 DeviceUtils.hideKeyboard(context);
//                 vm.doSignIn();
//               },
//             ),
//             vSpaceMedium,
//             RichTextWidget(
//                 firstTxt: 'dont_account',
//                 secondTxt: 'signup',
//                 onTap: () => Get.to(() => const SignUpView())).center(),
//             vSpaceMedium,
//             const OrSeperator(isDark: true,),
//             if (vm.isAppleSignAvailable)
//               apple.AppleSignInButton(
//                   onPressed: () => vm.doAppleSignIn(),
//                   cornerRadius: 8,
//                   style: apple.ButtonStyle.black)
//             else
//               emptyBox(),
//             vSpaceSmall,
//             GoogleSignInButton(
//               onTap: () => vm.doSGoogleSignIn(),
//               isBusy: vm.busy(vm.googleSignIn),
//             ),
//
//             vSpaceMedium
//           ],
//         ),
//       ),
//     );
//   }
// }
