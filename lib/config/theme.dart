import 'package:flutter/material.dart';

ColorScheme appColor([bool? isDark]) => ColorScheme.fromSeed(
    seedColor: Color(0xFF4B39EF),
    primary: Color(0xFF4B39EF),
    secondary: Color(0xFFEE8B60),
    dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    brightness: isDark == null
        ? Brightness.light
        : isDark
            ? Brightness.dark
            : Brightness.light);

ThemeData appTheme(BuildContext context, {bool? isDark}) {
  ColorScheme themeColor = appColor(isDark);
  return ThemeData(
      primaryColor: Color(0xFF4B39EF),
      colorScheme: themeColor,
      fontFamily: 'Outfit',
      useMaterial3: true,
      iconTheme: IconThemeData(
        color: (isDark ?? true) ? Colors.white : Color(0xFF4B39EF),
      ),
      tabBarTheme: TabBarTheme(
        labelStyle: TextStyle(
            color: (isDark ?? true) ? Colors.white : themeColor.primary,
            fontFamily: 'Outfit'),
        unselectedLabelColor:
            (isDark ?? true) ? themeColor.primary : Colors.black,
      ),
      scaffoldBackgroundColor:
          (isDark ?? true) ? themeColor.surfaceContainer : Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )),
            // minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
            backgroundColor: WidgetStatePropertyAll(themeColor.primary),
            overlayColor:
                WidgetStatePropertyAll(themeColor.onPrimaryContainer)),
      ));
}
