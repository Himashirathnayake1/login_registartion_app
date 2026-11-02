import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// main titles and app colors
class AppBrand {
  AppBrand._();
  static const name = 'My App';
  static const tagline = 'Looking for a solution? We have it!';
}

class AppColors {
  AppColors._();
  static const primary = Color(0xFF5B8DEF);
  static const primaryDark = Color(0xFF3F6FD8);
  static const primarySoft = Color(0xFFDCE8FD);
}

class AppTheme {
  static bool useGoogleFonts = true;

  AppTheme._();

  static TextStyle script({double size = 40, Color color = Colors.white}) =>
      GoogleFonts.lobster(fontSize: size.sp, color: color, height: 1.1);

  static OutlineInputBorder _pill(Color color, [double width = 1.4]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.r),
        borderSide: BorderSide(color: color, width: width.w),
      );

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: GoogleFonts.poppinsTextTheme(),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
            fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13.sp),
        errorMaxLines: 2,
        prefixIconColor: AppColors.primary,
        suffixIconColor: AppColors.primary,
        border: _pill(AppColors.primary),
        enabledBorder: _pill(AppColors.primary),
        focusedBorder: _pill(AppColors.primaryDark, 2),
        disabledBorder: _pill(Colors.grey.shade300),
        errorBorder: _pill(scheme.error),
        focusedErrorBorder: _pill(scheme.error, 2),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: Size(0, 50.h),
          shape: const StadiumBorder(),
          textStyle:
              GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          textStyle: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
        side: BorderSide(color: AppColors.primary, width: 1.5.w),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.primarySoft.withAlpha(120),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      ),
    );
  }
}
