import 'package:flutter/material.dart';

class SlidePageRoute extends PageRouteBuilder {
  final Widget page;
  final Offset beginOffset;

  SlidePageRoute({
    required this.page,
    this.beginOffset = const Offset(1.0, 0.0),
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
            final tween = Tween(begin: beginOffset, end: Offset.zero);

            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            );

            final offsetAnimation = tween.animate(curvedAnimation);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}