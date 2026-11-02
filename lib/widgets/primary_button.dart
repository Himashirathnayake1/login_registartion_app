import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: FilledButton(
        onPressed: isLoading ? () {} : onPressed,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isLoading
              ? SizedBox(
                  key: ValueKey('loader'),
                  height: 22.h,
                  width: 22.w,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.5.w, color: Colors.white),
                )
              : Text(label, key: const ValueKey('label')),
        ),
      ),
    );
  }
}
