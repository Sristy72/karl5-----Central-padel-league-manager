import 'package:flutter/material.dart';

/// Responsive utility class to handle different screen sizes
class ResponsiveUtils {
  /// Check if screen width is small (< 350px)
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 350;
  }

  /// Check if screen width is medium (350-400px)
  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 350 &&
        MediaQuery.of(context).size.width < 400;
  }

  /// Check if screen width is large (>= 400px)
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 400;
  }

  /// Get responsive horizontal padding based on screen width
  static double getHorizontalPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 350) {
      return 12.0;
    } else if (screenWidth < 400) {
      return 16.0;
    } else {
      return 24.0;
    }
  }

  /// Get responsive vertical padding based on screen width
  static double getVerticalPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 350) {
      return 8.0;
    } else if (screenWidth < 400) {
      return 12.0;
    } else {
      return 16.0;
    }
  }

  /// Get responsive heading font size
  static double getHeadingFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 350) {
      return 16.0;
    } else if (screenWidth < 400) {
      return 17.0;
    } else {
      return 18.0;
    }
  }

  /// Get responsive body font size
  static double getBodyFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 350) {
      return 12.0;
    } else if (screenWidth < 400) {
      return 13.0;
    } else {
      return 14.0;
    }
  }

  /// Get responsive small font size
  static double getSmallFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 350) {
      return 10.0;
    } else if (screenWidth < 400) {
      return 11.0;
    } else {
      return 12.0;
    }
  }

  /// Get responsive spacing (height between sections)
  static double getSpacing(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 350) {
      return 12.0;
    } else if (screenWidth < 400) {
      return 16.0;
    } else {
      return 20.0;
    }
  }

  /// Get responsive icon size
  static double getIconSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 350) {
      return 20.0;
    } else if (screenWidth < 400) {
      return 22.0;
    } else {
      return 24.0;
    }
  }

  /// Get screen height
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Get screen width
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get device pixel ratio
  static double getDevicePixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  /// Get safe area padding
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Get responsive card elevation
  static double getCardElevation(BuildContext context) {
    return MediaQuery.of(context).size.width < 350 ? 2.0 : 4.0;
  }

  /// Get responsive border radius
  static BorderRadius getResponsiveBorderRadius(BuildContext context) {
    final radius = MediaQuery.of(context).size.width < 350 ? 6.0 : 8.0;
    return BorderRadius.circular(radius);
  }
}
