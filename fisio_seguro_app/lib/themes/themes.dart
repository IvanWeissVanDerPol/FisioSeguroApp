import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
        // General Configurations
        primaryColor: AppGeneric.primaryColor,
        scaffoldBackgroundColor: AppGeneric.background,
        colorScheme: const ColorScheme.light(
          background: AppGeneric.tertiaryColor,
          primary: AppGeneric.primaryColor,
          secondary: AppGeneric.secondaryColor,
          onPrimary: AppGeneric.text,
          onSecondary: AppGeneric.text,
        ),
        brightness: Brightness.light, // Set to Brightness.dark for dark theme
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: GoogleFonts.montserratAlternates().fontFamily,

        // AppBar Configurations
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.montserratAlternates(
            fontSize: 20.0,
            color: AppGeneric.text,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(
            color: AppGeneric.primaryDarker,
          ),
          elevation: 0,
          centerTitle: true,
          backgroundColor: AppGeneric.primaryColor,
        ),
        //textfield theme
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppGeneric.cursorColor,
          selectionColor: AppGeneric.primaryColor,
          selectionHandleColor: AppGeneric.primaryColor,
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.montserratAlternates(fontSize: 96, fontWeight: FontWeight.w300, letterSpacing: -1.5),
          displayMedium: GoogleFonts.montserratAlternates(fontSize: 60, fontWeight: FontWeight.w300, letterSpacing: -0.5),
          displaySmall: GoogleFonts.montserratAlternates(fontSize: 48, fontWeight: FontWeight.w400),
          headlineMedium: GoogleFonts.montserratAlternates(fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
          headlineSmall: GoogleFonts.montserratAlternates(fontSize: 24, fontWeight: FontWeight.w400),
          titleLarge: GoogleFonts.montserratAlternates(fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
          titleMedium: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
          titleSmall: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
          bodyLarge: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
          bodyMedium: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
          labelLarge: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
          bodySmall: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
          labelSmall: GoogleFonts.roboto(fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
        ),

        // Button Theme Configurations
        buttonTheme: const ButtonThemeData(
          colorScheme: ColorScheme.light(
            primary: AppGeneric.primaryColor,
            secondary: AppGeneric.secondaryColor,
            surface: AppGeneric.background,
            background: AppGeneric.background,
            error: AppGeneric.elementsError,
            onPrimary: AppGeneric.text,
            onSecondary: AppGeneric.text,
            onSurface: AppGeneric.text,
            onBackground: AppGeneric.text,
            onError: AppGeneric.text,
            brightness: Brightness.light,
          ),
          buttonColor: AppGeneric.primaryColor,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),

        // Input Decoration Configurations
        inputDecorationTheme: InputDecorationTheme(
          filled: true,

        ),

        // Icon Theme Configurations
        iconTheme: const IconThemeData(
          color: AppGeneric.iconColor,
          size: 24,
        ),

        cardTheme: CardTheme(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        // Button Theme Configurations
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return AppGeneric.primaryColor.withOpacity(0.5);
                }
                return AppGeneric.primaryColor; // Use the component's default.
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),

        // TextButton Theme Configuration
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppGeneric.primaryColor,
          ),
        ),
      );
  InputDecoration getPasswordInputDecoration(bool obscureText) {
    return InputDecoration(
      prefixIcon: const Icon(
        Icons.lock_outline,
        color: AppGeneric.iconColor,
      ),
      suffixIcon: IconButton(
        icon: Icon(
          obscureText ? Icons.visibility : Icons.visibility_off,
          color: AppGeneric.iconColor,
        ),
        onPressed: () {}, // This should be handled in the widget
      ),
      hintText: "Enter Password",
      labelText: "Enter Password",
      filled: true,
      fillColor: AppGeneric.boxfillColor,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      // border: const OutlineInputBorder(
      //   borderRadius: BorderRadius.all(Radius.circular(8)),
      //   borderSide: BorderSide(
      //     color: AppGeneric.primaryColor,
      //   ),
      // ),
      // focusedBorder: const OutlineInputBorder(
      //   borderRadius: BorderRadius.all(Radius.circular(8)),
      //   borderSide: BorderSide(
      //     color: AppGeneric.primaryColor,
      //   ),
      // ),
    );
  }
}

class AppGeneric {
  static const Color primaryColorDarker = Color.fromARGB(255, 63, 31, 94);
  static const Color primaryColor = Color.fromARGB(255, 111, 53, 165);
  static const Color secondaryColor = Color.fromARGB(255, 149, 70, 196);
  static const Color tertiaryColor = Color.fromARGB(255, 181, 42, 200);
  static const Color text = AppGeneric.tertiaryColor;
  static const Color background = Colors.white;
  static const Color elementsNormal = Colors.white;
  static const Color elementsError = Colors.red;
  static const Color elementsHint = Colors.white70;
  static const Color cursorColor = Colors.white;
  static const Color iconColor = AppGeneric.text;
  static const Color textFileInitialTextColor = AppGeneric.text;
  static const Color textFileInputTextColor = AppGeneric.text;
  static const Color textFieldTextColor = AppGeneric.text;
  static const Color buttonTextColor = AppGeneric.text;
  static const Color buttonIconColor = AppGeneric.text;
  static const Color buttonBackgroundColor = AppGeneric.background;
  static const Color textFileborders = Color.fromARGB(255, 164, 0, 179);
  static Color boxfillColor = Colors.pink;
  static const Color primaryDarker = Colors.black;
  //make a linear gradient for the background of the app using the primary and secondary colors and the tertiary color
  static const LinearGradient linearGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppGeneric.primaryColor,
      AppGeneric.secondaryColor,
      AppGeneric.tertiaryColor,
    ],
  );
}
