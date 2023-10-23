import 'dart:ui';

abstract class BasePalette {

  Color get primaryColor;
  Color get primaryColorLighter;
  Color get secondaryColor;
  Color get secondaryColorLighter;
  Color get tertiaryColor;
  Color get tertiaryColorLighter;
  Color get contrastingColor;
}

class PurplePalette extends BasePalette {
  @override Color get primaryColor => const Color.fromARGB(255, 111, 53, 165);
  @override Color get primaryColorLighter => const Color.fromARGB(255, 139, 84, 186);
  @override Color get secondaryColor => const Color.fromARGB(255, 149, 70, 196);
  @override Color get secondaryColorLighter => const Color.fromARGB(255, 170, 100, 215);
  @override Color get tertiaryColor => const Color.fromARGB(255, 181, 42, 200);
  @override Color get tertiaryColorLighter => const Color.fromARGB(255, 200, 75, 220);
  @override Color get contrastingColor => const Color.fromARGB(255, 255, 255, 255); // White for Purple Theme
}
class GreenPalette extends BasePalette {
  @override Color get primaryColor => const Color.fromARGB(255, 0, 100, 0);
  @override Color get primaryColorLighter => const Color.fromARGB(255, 50, 150, 50);
  @override Color get secondaryColor => const Color.fromARGB(255, 0, 150, 50);
  @override Color get secondaryColorLighter => const Color.fromARGB(255, 50, 200, 50);
  @override Color get tertiaryColor => const Color.fromARGB(255, 0, 100, 50);
  @override Color get tertiaryColorLighter => const Color.fromARGB(255, 50, 150, 100);
  @override Color get contrastingColor => const Color.fromARGB(255, 255, 255, 255); // White for Green Theme
}
class BluePalette extends BasePalette {
  @override Color get primaryColor => const Color.fromARGB(255, 0, 0, 100);
  @override Color get primaryColorLighter => const Color.fromARGB(255, 50, 50, 150);
  @override Color get secondaryColor => const Color.fromARGB(255, 0, 50, 150);
  @override Color get secondaryColorLighter => const Color.fromARGB(255, 50, 100, 200);
  @override Color get tertiaryColor => const Color.fromARGB(255, 0, 50, 100);
  @override Color get tertiaryColorLighter => const Color.fromARGB(255, 50, 100, 150);
  @override Color get contrastingColor => const Color.fromARGB(255, 255, 220, 0); // Gold for Blue Theme
}
class OrangePalette extends BasePalette {
  @override Color get primaryColor => const Color.fromARGB(255, 200, 80, 0);
  @override Color get primaryColorLighter => const Color.fromARGB(255, 230, 110, 30);
  @override Color get secondaryColor => const Color.fromARGB(255, 255, 130, 0);
  @override Color get secondaryColorLighter => const Color.fromARGB(255, 255, 160, 50);
  @override Color get tertiaryColor => const Color.fromARGB(255, 200, 60, 10);
  @override Color get tertiaryColorLighter => const Color.fromARGB(255, 230, 90, 40);
  @override Color get contrastingColor => const Color.fromARGB(255, 0, 0, 0); // Black for Orange Theme
}

// Font Palettes
abstract class BaseFontPalette {
  String get primaryFont;
  String get secondaryFont;
  double get baseFontSize;
  double get titleFontSize;
}

class RobotoFontPalette extends BaseFontPalette {
  @override
  String get primaryFont => 'Roboto';
  @override
  String get secondaryFont => 'Arial';
  @override
  double get baseFontSize => 16.0;
  @override
  double get titleFontSize => 24.0;
}

class OpenSansFontPalette extends BaseFontPalette {
  @override
  String get primaryFont => 'OpenSans';
  @override
  String get secondaryFont => 'Lato';
  @override
  double get baseFontSize => 15.0;
  @override
  double get titleFontSize => 23.0;
}

class NotoSansFontPalette extends BaseFontPalette {
  @override
  String get primaryFont => 'NotoSans';
  @override
  String get secondaryFont => 'Raleway';
  @override
  double get baseFontSize => 16.5;
  @override
  double get titleFontSize => 25.0;
}

class MontserratFontPalette extends BaseFontPalette {
  @override
  String get primaryFont => 'Montserrat';
  @override
  String get secondaryFont => 'Poppins';
  @override
  double get baseFontSize => 17.0;
  @override
  double get titleFontSize => 26.0;
}

class PlayfairFontPalette extends BaseFontPalette {
  @override
  String get primaryFont => 'PlayfairDisplay';
  @override
  String get secondaryFont => 'Dosis';
  @override
  double get baseFontSize => 16.0;
  @override
  double get titleFontSize => 24.5;
}



