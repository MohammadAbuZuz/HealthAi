import 'package:flutter/widgets.dart';

class Responsive {
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  static Orientation orientation(BuildContext context) =>
      MediaQuery.of(context).orientation;

  static bool isMobile(BuildContext context) => screenWidth(context) < 600;
  static bool isTablet(BuildContext context) =>
      screenWidth(context) >= 600 && screenWidth(context) < 1200;
  static bool isDesktop(BuildContext context) => screenWidth(context) >= 1200;

  static double responsiveValue(
    BuildContext context, {
    double mobile = 0,
    double tablet = 0,
    double desktop = 0,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  static EdgeInsets responsivePadding(
    BuildContext context, {
    EdgeInsets mobile = EdgeInsets.zero,
    EdgeInsets tablet = EdgeInsets.zero,
    EdgeInsets desktop = EdgeInsets.zero,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  static double fontSize(
    BuildContext context, {
    double mobile = 14,
    double tablet = 16,
    double desktop = 18,
  }) {
    return responsiveValue(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
}
