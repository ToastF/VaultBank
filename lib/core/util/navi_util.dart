import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Utility class for navigation
class NavigationHelper {
  // go to, but previous screen is still present
  static void goTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  // go to, while retaining Cubit
  static void goToWithCubit<T extends BlocBase<dynamic>>(
    BuildContext context,
    Widget page,
    T cubit,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(value: cubit, child: page),
      ),
    );
  }

  // replace current screen with another screen
  static void replaceWith(BuildContext context, Widget page) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  // go to previous screen in stack
  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  // clear all screen and replace with new one
  static void goToAndRemoveAll(BuildContext context, Widget page) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => page),
      (Route<dynamic> route) => false,
    );
  }
}
