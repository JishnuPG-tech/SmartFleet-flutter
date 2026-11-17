import "dart:math";
import "dart:io";

double _srgbToLin(double c) {
  final val = c / 255.0;
  return val <= 0.04045 ? val / 12.92 : pow((val + 0.055) / 1.055, 2.4).toDouble();
}

double luminance(int hex) {
  final r = (hex >> 16) & 0xFF;
  final g = (hex >> 8) & 0xFF;
  final b = hex & 0xFF;
  return 0.2126 * _srgbToLin(r.toDouble()) +
         0.7152 * _srgbToLin(g.toDouble()) +
         0.0722 * _srgbToLin(b.toDouble());
}

double contrast(int c1, int c2) {
  var l1 = luminance(c1);
  var l2 = luminance(c2);
  if (l1 < l2) {
    final t = l1;
    l1 = l2;
    l2 = t;
  }
  return (l1 + 0.05) / (l2 + 0.05);
}

String hexString(int c) {
  final h = c.toRadixString(16).padLeft(6, "0").toUpperCase();
  return "#$h";
}

class TokenPair {
  final String theme;
  final String name;
  final int foreground;
  final int background;

  const TokenPair(this.theme, this.name, this.foreground, this.background);
}

void main() {
  final pairs = [
    // Light Theme
    const TokenPair("Light", "Text on Background", 0x0E1116, 0xF6F7F9),
    const TokenPair("Light", "Text on Surface", 0x0E1116, 0xFFFFFF),
    const TokenPair("Light", "TextSecondary on Background", 0x46505C, 0xF6F7F9),
    const TokenPair("Light", "TextSecondary on Surface", 0x46505C, 0xFFFFFF),
    const TokenPair("Light", "onBrand on Brand", 0xFFFFFF, 0x1F4BDB),
    const TokenPair("Light", "Success on Container", 0x0B6E3A, 0xE7F7EE),
    const TokenPair("Light", "Brand on Container", 0x1F4BDB, 0xEDF2FE),
    const TokenPair("Light", "Waiting on Container", 0x8D5300, 0xFEF6E7),
    const TokenPair("Light", "Danger on Container", 0xC62828, 0xFDE8E8),

    // Dark Theme
    const TokenPair("Dark", "Text on Background", 0xF2F4F7, 0x0E1116),
    const TokenPair("Dark", "Text on Surface", 0xF2F4F7, 0x161B22),
    const TokenPair("Dark", "TextSecondary on Background", 0xAAB3BF, 0x0E1116),
    const TokenPair("Dark", "TextSecondary on Surface", 0xAAB3BF, 0x161B22),
    const TokenPair("Dark", "onBrand on Brand", 0x0A0F1F, 0x6C8DFF),
    const TokenPair("Dark", "Success on Container", 0x3DD68C, 0x0C2B1C),
    const TokenPair("Dark", "Brand on Container", 0x6C8DFF, 0x162244),
    const TokenPair("Dark", "Waiting on Container", 0xFFB84D, 0x362100),
    const TokenPair("Dark", "Danger on Container", 0xFF6B6B, 0x3B0D0D),
  ];

  print("================================================================================");
  print(" SMARTFLEET UI v2 - WCAG AAA/AA CONTRAST RATIO VERIFICATION (TARGET >= 4.5:1) ");
  print("================================================================================");
  print("THEME | TOKEN PAIR                | FOREGROUND | BACKGROUND | RATIO    | RESULT ");
  print("------+---------------------------+------------+------------+----------+--------");

  bool allPassed = true;
  for (final p in pairs) {
    final ratio = contrast(p.foreground, p.background);
    final passed = ratio >= 4.5;
    if (!passed) allPassed = false;

    final themeStr = p.theme.padRight(5);
    final nameStr = p.name.padRight(25);
    final fgStr = hexString(p.foreground).padRight(10);
    final bgStr = hexString(p.background).padRight(10);
    final ratioStr = "${ratio.toStringAsFixed(2)}:1".padRight(8);
    final statusStr = passed ? "PASS" : "FAIL (< 4.5:1)";

    print("$themeStr | $nameStr | $fgStr | $bgStr | $ratioStr | $statusStr");
  }

  print("================================================================================");
  if (allPassed) {
    print("SUCCESS: All 18 color token pairs meet or exceed WCAG AA/AAA (>= 4.5:1).");
    exit(0);
  } else {
    print("ERROR: One or more token pairs failed the 4.5:1 contrast requirement!");
    exit(1);
  }
}
