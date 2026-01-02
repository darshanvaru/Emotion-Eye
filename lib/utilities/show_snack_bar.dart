import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message, {bool isError = false}) {
  if (!context.mounted) return;

  final messenger = ScaffoldMessenger.of(context);

  messenger.clearSnackBars();

  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: isError ? Colors.red.shade800 : Colors.green.shade700,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.all(16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 6,
    duration: Duration(seconds: 4),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.red, // text/icon color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          onPressed: () {
            messenger.removeCurrentSnackBar();
          },
          child: Text("Ok"),
        ),
      ],
    ),
  ));
}