
import 'package:flutter/material.dart';

class ResponsiveUtils {
  ResponsiveUtils._();

  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 900;

  static bool isMobile(BuildContext context){
    return MediaQuery.of(context).size.width <= mobileMaxWidth;
  }
  static bool isTablet(BuildContext context){
    double width = MediaQuery.of(context).size.width;
    return width > mobileMaxWidth && width <= tabletMaxWidth;
  }
  static bool isDesktop(BuildContext context){
    return MediaQuery.of(context).size.width > tabletMaxWidth;
  }
}