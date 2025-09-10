import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primaryGold = Color(0xFFD4AF37);
  static const darkGold = Color(0xFFB8941F);
  static const lightGold = Color(0xFFF4E4BC);
  static const roseGold = Color(0xFFE8B4A0);

  static const cream = Color(0xFFFAF7F0);
  static const ivory = Color(0xFFF5F5DC);
  static const pearl = Color(0xFFF8F6F0);
  static const champagne = Color(0xFFF7E7CE);

  static const deepBurgundy = Color(0xFF722F37);
  static const wine = Color(0xFF722544);
  static const navyBlue = Color(0xFF2C3E50);
  static const charcoal = Color(0xFF36454F);
  static const graphite = Color(0xFF41424C);

  static const forestGreen = Color(0xFF355E3B);
  static const emerald = Color(0xFF50C878);

  // ✅ Added for HomePage usage
  static const warmWhite = Color(0xFFFEFEFE);
  static const textSecondary = Color(0xFF5D6D7E);
}

final goldGradient = const LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [AppColors.primaryGold, AppColors.darkGold, AppColors.roseGold],
);

final royalGradient = const LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [AppColors.navyBlue, AppColors.deepBurgundy, AppColors.wine],
);

ThemeData buildTheme() {
  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryGold,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.cream,
    useMaterial3: true,
  );

  return base.copyWith(
    textTheme: GoogleFonts.playfairDisplayTextTheme(base.textTheme).copyWith(
      displayLarge: GoogleFonts.cinzel(
        fontSize: 56,
        fontWeight: FontWeight.w900,
        color: AppColors.deepBurgundy,
      ),
      displayMedium: GoogleFonts.cinzel(
        fontSize: 42,
        fontWeight: FontWeight.w800,
        color: AppColors.deepBurgundy,
      ),
      titleLarge: GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.deepBurgundy,
      ),
      bodyLarge: GoogleFonts.crimsonText(
        fontSize: 18,
        height: 1.5,
        color: AppColors.navyBlue,
      ),
      bodyMedium: GoogleFonts.crimsonText(
        fontSize: 16,
        height: 1.6,
        color: AppColors.textSecondary, // ✅ use the constant
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 3,
      shadowColor: Color(0x1A000000),
      surfaceTintColor: Colors.white,
    ),
    // (Optional, but nice) unified input style used in newsletter/contact forms
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryGold, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    ),
  );
}
