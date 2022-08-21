import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

import '../shared/app_colors.dart';
import '../widgets/app_dialog.dart';




String removeFirstWord(String word) {
  if (word.isNotEmpty) {
    int i = word.indexOf(" ") + 1;
    String str = word.substring(i);
    return str;
  }
  return word;
}

extension ParseToString on Object {
  String toShortString() {
    return toString().split('.').last;
  }
}

final kFormatCurrency = NumberFormat.compactCurrency(
    decimalDigits: 0, locale: 'en_US', symbol: "€");

Future<bool> launchURL(String url) async =>
    await canLaunchUrl(Uri.parse(url)) ? await launchUrl(Uri.parse(url)) : throw 'Could not launch $url';

extension CurrencyExtentions on String {
  String formatCurrency(currency) {
    var value = isEmpty ? 0 : double.parse(this);
    return NumberFormat.simpleCurrency(name: currency).format(value);
  }
}

String getFormattedHtml(String preview) {
  final String formattedHtml = preview.replaceAll(r'', '');
  final String addHttpToImage =
      formattedHtml.replaceAll(r'img src="', 'img src="https:');
  return '<div>$addHttpToImage</div>';
}

showErrorMessage({required String message, title = 'Info!'}) {
  if (message.isEmpty) return;

  Get.snackbar(title, message,
      backgroundColor: kcTextSecondary,
      colorText: kAltWhite,
      icon: const Icon(
        Iconsax.warning_2,
        color: kAltWhite,
      ));
}

showMessage({String title = 'Info', required String message}) {
  if (message.isEmpty) return;

  Get.dialog(AppDialog(title: title, desc: message));
}

showInfoMessage({required message, title = 'Info!'}) {
  Get.snackbar(title, message,
      backgroundColor: kcPrimaryColor,
      colorText: kAltWhite,
      snackPosition: SnackPosition.BOTTOM,
      icon: const Icon(
        Iconsax.password_check,
        size: 18,
        color: kAltWhite,
      ));
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

launchEmail() async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'sugulication@gmail.com',
    query:
        encodeQueryParameters(<String, String>{'subject': 'Help and Support'}),
  );
  launchURL(emailLaunchUri.toString());
}

PreferredSizeWidget customAppBar({String? title}) => PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        title: Text(title ?? ''),
      ),
    );

lg(message) {
  var logger = Logger(
    printer: PrettyPrinter(
        methodCount: 2,
        // number of method calls to be displayed
        errorMethodCount: 8,
        // number of method calls if stacktrace is provided
        lineLength: 120,
        // width of the output
        colors: true,
        // Colorful log messages
        printEmojis: true,
        // Print an emoji for each log message
        printTime: false // Should each log print contain a timestamp
        ),
  );
  logger.wtf(message);
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
