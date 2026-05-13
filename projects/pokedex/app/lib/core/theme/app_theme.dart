import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Colors
  static const Color primary = Color(0xFFE3350D);
  static const Color primaryContainer = Color(0xFFFFDAD4);
  static const Color secondary = Color(0xFF1A1A2E);
  static const Color secondaryContainer = Color(0xFFE0E0F0);
  static const Color background = Color(0xFFFAFAFA);
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color outline = Color(0xFF938F99);
  static const Color error = Color(0xFFB3261E);

  static TextTheme _buildTextTheme() {
    return GoogleFonts.notoSansKrTextTheme().copyWith(
      headlineLarge: GoogleFonts.notoSansKr(
          fontSize: 32, fontWeight: FontWeight.w700),
      headlineMedium: GoogleFonts.notoSansKr(
          fontSize: 28, fontWeight: FontWeight.w600),
      headlineSmall: GoogleFonts.notoSansKr(
          fontSize: 24, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.notoSansKr(
          fontSize: 22, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.notoSansKr(
          fontSize: 16, fontWeight: FontWeight.w500),
      titleSmall: GoogleFonts.notoSansKr(
          fontSize: 14, fontWeight: FontWeight.w500),
      bodyLarge: GoogleFonts.notoSansKr(
          fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: GoogleFonts.notoSansKr(
          fontSize: 14, fontWeight: FontWeight.w400),
      bodySmall: GoogleFonts.notoSansKr(
          fontSize: 12, fontWeight: FontWeight.w400),
      labelLarge: GoogleFonts.notoSansKr(
          fontSize: 14, fontWeight: FontWeight.w500),
      labelMedium: GoogleFonts.notoSansKr(
          fontSize: 12, fontWeight: FontWeight.w500),
      labelSmall: GoogleFonts.notoSansKr(
          fontSize: 11, fontWeight: FontWeight.w400),
    );
  }

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: primary,
          onPrimary: Colors.white,
          primaryContainer: primaryContainer,
          onPrimaryContainer: const Color(0xFF410001),
          secondary: secondary,
          onSecondary: Colors.white,
          secondaryContainer: secondaryContainer,
          onSecondaryContainer: const Color(0xFF1A1A2E),
          tertiary: const Color(0xFF7038F8),
          onTertiary: Colors.white,
          tertiaryContainer: const Color(0xFFEADDFF),
          onTertiaryContainer: const Color(0xFF21005D),
          error: error,
          onError: Colors.white,
          errorContainer: const Color(0xFFFFDAD6),
          onErrorContainer: const Color(0xFF410002),
          surface: Colors.white,
          onSurface: const Color(0xFF1C1B1F),
          surfaceContainerHighest: surfaceVariant,
          onSurfaceVariant: const Color(0xFF49454F),
          outline: outline,
          outlineVariant: const Color(0xFFCAC4D0),
          shadow: Colors.black,
          scrim: Colors.black,
          inverseSurface: const Color(0xFF313033),
          onInverseSurface: const Color(0xFFF4EFF4),
          inversePrimary: const Color(0xFFFFB4A9),
        ),
        textTheme: _buildTextTheme(),
        scaffoldBackgroundColor: background,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: primary,
          foregroundColor: Colors.white,
          titleTextStyle: GoogleFonts.notoSansKr(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: primaryContainer,
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: primary);
            }
            return IconThemeData(color: outline);
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return GoogleFonts.notoSansKr(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: primary);
            }
            return GoogleFonts.notoSansKr(
                fontSize: 12, color: outline);
          }),
        ),
        tabBarTheme: TabBarThemeData(
          labelColor: primary,
          unselectedLabelColor: outline,
          indicatorColor: primary,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelStyle: GoogleFonts.notoSansKr(
              fontSize: 14, fontWeight: FontWeight.w600),
          unselectedLabelStyle:
              GoogleFonts.notoSansKr(fontSize: 14),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.dark,
        ),
        textTheme: _buildTextTheme(),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          titleTextStyle: GoogleFonts.notoSansKr(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
}
