import 'package:flutter/material.dart';

class Alertas {
  bool _isLoading = false;

  Future<void> messageAlertDialog(
      BuildContext context, String title, String message) async {
    // TODO Ver sobre usuário verem mensagem antes de

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 25.0),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 25.0),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: const Text("Ok"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
