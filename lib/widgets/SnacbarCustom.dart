import 'package:flutter/material.dart';

enum SnackbarType { normal, custom }

enum SnackbarStatusType { normal, success, warning, error }

class SnackbarCustom {
  static void show(
    BuildContext context, {
    required String message,
    required SnackbarStatusType status,
    required SnackbarType type,
  }) {
    final Map<SnackbarStatusType, Color> colors = {
      SnackbarStatusType.normal: Colors.grey,
      SnackbarStatusType.success: Colors.green,
      SnackbarStatusType.warning: Colors.orange,
      SnackbarStatusType.error: Colors.red,
    };

    final Map<SnackbarStatusType, IconData> icons = {
      SnackbarStatusType.normal: Icons.timelapse_sharp,
      SnackbarStatusType.success: Icons.check_circle_outline,
      SnackbarStatusType.warning: Icons.warning_amber_rounded,
      SnackbarStatusType.error: Icons.error_outline,
    };

    switch (type) {
      case SnackbarType.custom:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icons[status], color: colors[status]),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.black87,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.82,
              left: 20,
              right: 20,
            ),
          ),
        );

        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: colors[status],
            duration: const Duration(seconds: 3),
          ),
        );
    }
  }
}
