// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : app_theme.dart
// Created on : 21/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by:
// ------------------------------------------------------------
// Changelog:
//   [001] 21/04/2026 - Dev - Definicion del tema institucional de la app
// ============================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class AppTheme
{
  AppTheme._();

  static ThemeData get lightTheme
  {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.baseSurface,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryCoral,
        primary: AppColors.primaryCoral,
        secondary: AppColors.headingDark,
        error: AppColors.actionRed,
        surface: AppColors.surface,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: AppSizes.fontH1,
          fontWeight: FontWeight.bold,
          color: AppColors.deepNavy,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: AppSizes.fontH2,
          fontWeight: FontWeight.w600,
          color: AppColors.deepNavy,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: AppSizes.fontBodyM,
          color: AppColors.onyxGrey,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: AppSizes.fontBody,
          color: AppColors.onyxGrey,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: AppSizes.fontBody,
          color: AppColors.steelBlue,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryCoral,
          foregroundColor: AppColors.baseSurface,
          minimumSize: const Size(double.infinity, AppSizes.heightButton),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusButton),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: AppSizes.fontBodyM,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.headingDark,
          minimumSize: const Size(double.infinity, AppSizes.heightButton),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusButton),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: AppSizes.fontBodyM,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.baseSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingM,
          vertical: AppSizes.paddingM,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusInput),
          borderSide: const BorderSide(color: AppColors.borderSky),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusInput),
          borderSide: const BorderSide(color: AppColors.borderSky),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusInput),
          borderSide: const BorderSide(color: AppColors.headingDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusInput),
          borderSide: const BorderSide(color: AppColors.actionRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusInput),
          borderSide: const BorderSide(color: AppColors.actionRed, width: 2),
        ),
        labelStyle: GoogleFonts.inter(
          color: AppColors.steelBlue,
          fontSize: AppSizes.fontBody,
        ),
        hintStyle: GoogleFonts.inter(
          color: AppColors.neutralGrey,
          fontSize: AppSizes.fontBody,
        ),
        errorStyle: GoogleFonts.inter(
          color: AppColors.actionRed,
          fontSize: AppSizes.fontCaption,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.baseSurface,
        foregroundColor: AppColors.deepNavy,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: AppSizes.fontTitle,
          fontWeight: FontWeight.w600,
          color: AppColors.deepNavy,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.baseSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
          side: const BorderSide(color: AppColors.surface),
        ),
      ),
    );
  }
}