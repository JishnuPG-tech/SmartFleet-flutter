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
    const TokenPair("Light", "Text on Background", 0x111111, 0xFFFFFF),
    const TokenPair("Light", "Text on Surface", 0x111111, 0xF5F6F2),
    const TokenPair("Light", "TextSecondary on Background", 0x555B52, 0xFFFFFF),
    const TokenPair("Light", "TextSecondary on Surface", 0x555B52, 0xF5F6F2),
    const TokenPair("Light", "onBrand on Brand", 0xFFFFFF, 0x526B00),
    const TokenPair("Light", "Success on Container", 0x385800, 0xEBF5D8),
    const TokenPair("Light", "Brand on Container", 0x526B00, 0xEBF5D8),
    const TokenPair("Light", "Waiting on Container", 0x895000, 0xFDF1D8),
    const TokenPair("Light", "Danger on Container", 0xB42318, 0xFEE4E2),

    // Dark Theme
    const TokenPair("Dark", "Text on Background", 0xFFFFFF, 0x080A08),
    const TokenPair("Dark", "Text on Surface", 0xFFFFFF, 0x111411),
    const TokenPair("Dark", "TextSecondary on Background", 0xB4BBB0, 0x080A08),
    const TokenPair("Dark", "TextSecondary on Surface", 0xB4BBB0, 0x111411),
    const TokenPair("Dark", "onBrand on Brand", 0x080A08, 0xC6FF00),
    const TokenPair("Dark", "Success on Container", 0xC6FF00, 0x182604),
    const TokenPair("Dark", "Brand on Container", 0xC6FF00, 0x182604),
    const TokenPair("Dark", "Waiting on Container", 0xFFB84D, 0x2E1E05),
    const TokenPair("Dark", "Danger on Container", 0xFFFF6565, 0x2D0F0F),
  ];

  print("================================================================================");
  print(" SMARTFLEET MIDNIGHT & ACID LIME - WCAG AAA/AA CONTRAST VERIFICATION ");
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
