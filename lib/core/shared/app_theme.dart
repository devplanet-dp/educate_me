import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:educate_me/core/shared/shared_styles.dart';

import 'app_colors.dart';

final ThemeData themeData = ThemeData(
  fontFamily: 'Poppins',
  brightness: Brightness.light,
  backgroundColor: kcBg,
  dividerColor: Colors.transparent,
  dialogTheme: const DialogTheme(

  ),
  dataTableTheme: DataTableThemeData(
    headingRowHeight: 30
  ),
  expansionTileTheme: const ExpansionTileThemeData(
    tilePadding: EdgeInsets.zero,
    childrenPadding: EdgeInsets.zero,
    iconColor: kcPrimaryColor
  ),
  chipTheme: const ChipThemeData(
    selectedColor: kcPrimaryColor,
    backgroundColor: kAltWhite,
  ),
  appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: kcTextPrimary),
      titleTextStyle: kSubheadingStyle.copyWith(fontWeight: FontWeight.w600)),
  scaffoldBackgroundColor: Colors.white,
  primaryColor: kcPrimaryColor,
);

final ThemeData themeDataDark = ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme(),
  brightness: Brightness.dark,
  backgroundColor: kAltBg,
  scaffoldBackgroundColor: kBlack,
  primaryColor: kcPrimaryColor,
);
