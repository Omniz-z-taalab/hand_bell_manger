import 'package:flutter/material.dart';

class SnackBarsBuilder {
  static showFeedBackMessage(BuildContext context, String message, Color color,
      {bool addBehaviour = true}) {
    // clear any visible snackbars
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: addBehaviour ? SnackBarBehavior.floating : null,
        action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () => ScaffoldMessenger.of(context).clearSnackBars),
      ),
    );
  }
}
