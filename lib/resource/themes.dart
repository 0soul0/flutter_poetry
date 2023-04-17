import 'package:flutter/material.dart';
import 'package:flutter_poetry/resource/style.dart';

import 'colors.dart';

class Themes {
  final darkTheme = ThemeData.dark().copyWith(
      canvasColor: AppColor.white ,
      textTheme: const TextTheme(
          displayMedium:Styles.textStyleWhite,
          bodyMedium: Styles.textStyleShowWhite,
          displaySmall: Styles.helperStyleShowWhite,
          titleMedium: Styles.subTitleStyleWhite,
      ),
      colorScheme: const ColorScheme.dark(
        background: AppColor.dark
      ));

  final lightTheme = ThemeData.light().copyWith(
      canvasColor: AppColor.black ,
      textTheme: const TextTheme(
          displayMedium:Styles.textStyleBlack,
        displaySmall: Styles.helperStyle,
        bodyMedium: Styles.textStyleGray,
        titleMedium: Styles.subTitleStyleBlack,
      ),
      colorScheme: const ColorScheme.light(
          background: AppColor.backgroundColor
      )
  );
}


