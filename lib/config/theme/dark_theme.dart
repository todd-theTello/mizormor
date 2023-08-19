import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Define all dark theme data
final ThemeData darkTheme = FlexThemeData.dark(
  scheme: FlexScheme.cyanM3,
  surfaceMode: FlexSurfaceMode.highBackgroundLowScaffold,
  blendLevel: 8,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 8,
    blendTextTheme: true,
    useM2StyleDividerInM3: true,
    outlinedButtonOutlineSchemeColor: SchemeColor.primary,
    outlinedButtonPressedBorderWidth: 2,
    buttonPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    toggleButtonsBorderSchemeColor: SchemeColor.primary,
    segmentedButtonSchemeColor: SchemeColor.primary,
    segmentedButtonBorderSchemeColor: SchemeColor.primary,
    unselectedToggleIsColored: true,
    sliderValueTinted: true,
    inputDecoratorSchemeColor: SchemeColor.primary,
    inputDecoratorBackgroundAlpha: 43,
    inputDecoratorRadius: 12,
    inputDecoratorUnfocusedHasBorder: false,
    popupMenuRadius: 6,
    popupMenuElevation: 8,
    drawerIndicatorSchemeColor: SchemeColor.primary,
    bottomNavigationBarMutedUnselectedLabel: false,
    bottomNavigationBarMutedUnselectedIcon: false,
    menuRadius: 6,
    menuElevation: 8,
    menuBarRadius: 0,
    menuBarElevation: 1,
    navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
    navigationBarMutedUnselectedLabel: false,
    navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
    navigationBarMutedUnselectedIcon: false,
    navigationBarIndicatorSchemeColor: SchemeColor.primary,
    navigationBarIndicatorOpacity: 1,
    navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
    navigationRailMutedUnselectedLabel: false,
    navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
    navigationRailMutedUnselectedIcon: false,
    navigationRailIndicatorSchemeColor: SchemeColor.primary,
    navigationRailIndicatorOpacity: 1,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
// To use the Playground font, add GoogleFonts package and uncomment
  fontFamily: GoogleFonts.inter().fontFamily,
);
