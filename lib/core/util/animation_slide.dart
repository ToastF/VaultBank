import 'package:flutter/material.dart';

class SlidePageRoute extends PageRouteBuilder {
  final Widget page;
  final Offset beginOffset;

  SlidePageRoute({
    required this.page,
    this.beginOffset = const Offset(1.0, 0.0), // Default: slide dari kanan
  }) : super(
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            final tween = Tween(begin: beginOffset, end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeOut));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}