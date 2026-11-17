import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartfleet_flutter/core/theme/app_theme.dart';

double _linearize(double c) {
  return c <= 0.04045 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4).toDouble();
}

double _relativeLuminance(Color color) {
  final r = _linearize(color.red / 255.0);
  final g = _linearize(color.green / 255.0);
  final b = _linearize(color.blue / 255.0);
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

double _contrastRatio(Color c1, Color c2) {
  final l1 = _relativeLuminance(c1);
  final l2 = _relativeLuminance(c2);
  final lighter = max(l1, l2);
  final darker = min(l1, l2);
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  test('WCAG Token Contrast Compliance Test', () {
    final pairs = [
      {'name': 'TextPrimary on Background', 'fg': AppColors.textPrimary, 'bg': AppColors.background, 'minRatio': 7.0},
      {'name': 'TextPrimary on SurfaceCard', 'fg': AppColors.textPrimary, 'bg': AppColors.surfaceCard, 'minRatio': 7.0},
      {'name': 'TextSecondary on SurfaceCard', 'fg': AppColors.textSecondary, 'bg': AppColors.surfaceCard, 'minRatio': 4.5},
      {'name': 'TextOnAccent on Accent', 'fg': AppColors.textOnAccent, 'bg': AppColors.accent, 'minRatio': 4.5},
      {'name': 'Status Done Text on Bg', 'fg': AppColors.statusDoneText, 'bg': AppColors.statusDoneBg, 'minRatio': 4.5},
      {'name': 'Status Running Text on Bg', 'fg': AppColors.statusRunningText, 'bg': AppColors.statusRunningBg, 'minRatio': 4.5},
      {'name': 'Status Waiting Text on Bg', 'fg': AppColors.statusWaitingText, 'bg': AppColors.statusWaitingBg, 'minRatio': 4.5},
      {'name': 'Status Problem Text on Bg', 'fg': AppColors.statusProblemText, 'bg': AppColors.statusProblemBg, 'minRatio': 4.5},
    ];

    print('\n========================================================================================');
    print('                      SMARTFLEET 2.0 TOKEN CONTRAST RATIO TABLE');
    print('========================================================================================');
    print(String.fromCharCodes(List.filled(88, 45)));
    print('${"Token Pair".padRight(34)} | ${"FG Color".padRight(10)} | ${"BG Color".padRight(10)} | ${"Ratio".padRight(8)} | WCAG Status');
    print(String.fromCharCodes(List.filled(88, 45)));

    for (final p in pairs) {
      final fg = p['fg'] as Color;
      final bg = p['bg'] as Color;
      final ratio = _contrastRatio(fg, bg);
      final minRequired = p['minRatio'] as double;
      final pass = ratio >= minRequired;
      final status = pass ? 'PASS (>= ${minRequired.toInt()}:1)' : 'FAIL';

      final fgHex = '#${fg.value.toRadixString(16).substring(2).toUpperCase()}';
      final bgHex = '#${bg.value.toRadixString(16).substring(2).toUpperCase()}';

      print('${(p['name'] as String).padRight(34)} | ${fgHex.padRight(10)} | ${bgHex.padRight(10)} | ${ratio.toStringAsFixed(2).padRight(8)} | $status');
      expect(ratio, greaterThanOrEqualTo(minRequired), reason: '${p['name']} failed contrast requirement');
    }
    print(String.fromCharCodes(List.filled(88, 45)));
  });
}
