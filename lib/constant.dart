import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


// ThemeData _buildShrineTheme() {
//   final ThemeData base = ThemeData.light();
//   return base.copyWith(
//     toggleableActiveColor: shrinePink400,
//     primaryColor: shrinePink100,
// //    buttonColor: shrinePink100,
//     scaffoldBackgroundColor: shrineBackgroundWhite,
//     cardColor: shrineBackgroundWhite,
// //    textSelectionColor: shrinePink100,
//     errorColor: shrineErrorRed,
//     primaryIconTheme: _customIconTheme(base.iconTheme),
//     textTheme: _buildShrineTextTheme(base.textTheme),
//     primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
// //    accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
//     iconTheme: _customIconTheme(base.iconTheme), colorScheme: _shrineColorScheme.copyWith(secondary: shrineBrown900),
//   );
// }

// IconThemeData _customIconTheme(IconThemeData original) {
//   return original.copyWith(color: shrineBrown900);
// }

// TextTheme _buildShrineTextTheme(TextTheme base) {
//   return base.apply(
//     fontFamily: 'Rubik',
//     displayColor: shrineBrown900,
//     bodyColor: shrineBrown900,
//   );
// }

// const ColorScheme _shrineColorScheme = ColorScheme(
//   primary: shrinePink100,
// //  primaryVariant: shrineBrown900,
//   secondary: shrinePink50,
// //  secondaryVariant: shrineBrown900,
//   surface: shrineSurfaceWhite,
//   background: shrineBackgroundWhite,
//   error: shrineErrorRed,
//   onPrimary: shrineBrown900,
//   onSecondary: shrineBrown900,
//   onSurface: shrineBrown900,
//   onBackground: shrineBrown900,
//   onError: shrineSurfaceWhite,
//   brightness: Brightness.light,
// );

const Color shrinePink50 = Color(0xFFFEEAE6);
const Color shrinePink100 = Color(0xFFFEDBD0);
const Color shrinePink300 = Color(0xFFFBB8AC);
const Color shrinePink400 = Color(0xFFEAA4A4);

const Color shrineBrown900 = Color(0xFF442B2D);
const Color shrineBrown600 = Color(0xFF7D4F52);

const Color shrineErrorRed = Color(0xFFC5032B);

const Color shrineSurfaceWhite = Color(0xFFFFFBFA);
const Color shrineBackgroundWhite = Colors.white;


const kSpacingUnit = 10;

const kDarkPrimaryColor = Color(0xFF212121);
const kDarkSecondaryColor = Color(0xFF373737);
const kLightPrimaryColor = Color(0xFFFFFFFF);
const kLightSecondaryColor = Color(0xFFF3F7FB);
const kAccentColor = Color(0xFFFFC107);

final kTitleTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.7),
  fontWeight: FontWeight.w600,
);

final kCaptionTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.3),
  fontWeight: FontWeight.w100,
);

final kButtonTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
  fontWeight: FontWeight.w400,
  color: kDarkPrimaryColor,
);

final kDarkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'SFProText',
  primaryColor: kDarkPrimaryColor,
  canvasColor: kDarkPrimaryColor,
  backgroundColor: kDarkSecondaryColor,
  iconTheme: ThemeData.dark().iconTheme.copyWith(
    color: kLightSecondaryColor,
  ),
  textTheme: ThemeData.dark().textTheme.apply(
    fontFamily: 'SFProText',
    bodyColor: kLightSecondaryColor,
    displayColor: kLightSecondaryColor,
  ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kAccentColor),
);

final kLightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'SFProText',
  primaryColor: kLightPrimaryColor,
  canvasColor: kLightPrimaryColor,
  backgroundColor: kLightSecondaryColor,
  iconTheme: ThemeData.light().iconTheme.copyWith(
    color: kDarkSecondaryColor,
  ),
  textTheme: ThemeData.light().textTheme.apply(
    fontFamily: 'SFProText',
    bodyColor: kDarkSecondaryColor,
    displayColor: kDarkSecondaryColor,
  ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kAccentColor),
);


var kBackgroundColor = const Color(0xffF9F9F9);
var kWhiteColor = const Color(0xffffffff);
var kOrangeColor = const Color(0xffEF716B);
var kBlueColor = const Color(0xff4B7FFB);
var kYellowColor = const Color(0xffFFB167);
var kTitleTextColor = const Color(0xff1E1C61);
var kSearchBackgroundColor = const Color(0xffF2F2F2);
var kSearchTextColor = const Color(0xffC0C0C0);
var kCategoryTextColor = const Color(0xff292685);
var kLightPink = const Color(0xffF8AFA6);