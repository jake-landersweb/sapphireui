import 'package:flutter/material.dart';
import 'dart:math' as math;

extension CustomColors on Colors {
  static Color lightList = const Color.fromRGBO(242, 242, 248, 1);

  static Color darkList = const Color.fromRGBO(48, 48, 50, 1);

  static Color textColor(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  static Color plainBackground(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  static Color cellColor(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return Colors.white;
    } else {
      return CustomColors.darkList;
    }
  }

  static Color sheetBackground(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return lightList;
    } else {
      return darkList;
    }
  }

  static Color sheetCell(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return Colors.black.withOpacity(0.1);
    } else {
      return Colors.white.withOpacity(0.1);
    }
  }

  static Color backgroundColor(BuildContext context, {bool? inverted}) {
    if (Theme.of(context).brightness == Brightness.light) {
      if (inverted ?? false) {
        return const Color.fromRGBO(30, 30, 33, 1);
      } else {
        return lightList;
      }
    } else {
      if (inverted ?? false) {
        return lightList;
      } else {
        return const Color.fromRGBO(30, 30, 33, 1);
      }
    }
  }

  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static Color random(String seed) {
    int num = 0;
    for (int i = 0; i < seed.length; i++) {
      num += seed[i].codeUnitAt(0);
    }
    // add lightness to make it look better overall
    Color col = Color((math.Random(num).nextDouble() * 0xFFFFFF).toInt())
        .withOpacity(1.0);
    HSLColor hsl = HSLColor.fromColor(col);
    return hsl.withLightness(0.75).toColor();
  }
}
