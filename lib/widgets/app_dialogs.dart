import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// User-friendly success / error popups.
class AppDialogs {
  AppDialogs._();

  static Future<void> success(BuildContext context,
          {required String title, required String message, String button = 'Continue'}) =>
      _show(context, true, title, message, button);

  static Future<void> error(BuildContext context,
          {required String title, required String message, String button = 'Try again'}) =>
      _show(context, false, title, message, button);

  static Future<void> _show(BuildContext context, bool ok, String title,
      String message, String button) {
    final scheme = Theme.of(context).colorScheme;
    final color = ok ? Colors.green : scheme.error;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        icon: CircleAvatar(
          radius: 30,
          backgroundColor: color.withAlpha(30),
          child: Icon(ok ? Icons.check_rounded : Icons.error_outline_rounded,
              color: color, size: 34.w),
        ),
        title: Text(title, textAlign: TextAlign.center),
        content: Text(message, textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: color,
                padding: EdgeInsets.symmetric(horizontal: 28.w)),
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(button),
          ),
        ],
      ),
    );
  }
}
