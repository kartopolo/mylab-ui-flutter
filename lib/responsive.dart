import 'package:flutter/widgets.dart';

const double kMobileBreakpoint = 600.0;
const double kTabletBreakpoint = 1024.0;

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < kMobileBreakpoint) {
      return mobile;
    }
    if (width < kTabletBreakpoint) {
      return tablet;
    }
    return desktop;
  }
}
