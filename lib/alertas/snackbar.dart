import 'package:flutter/material.dart';

class CustomSnackBar {
  final BuildContext context;
  final String message;
  final bool isError;

  CustomSnackBar({
    required this.context,
    required this.message,
    this.isError = false,
  });

  void show() {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ],
      ),
      backgroundColor: isError
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
