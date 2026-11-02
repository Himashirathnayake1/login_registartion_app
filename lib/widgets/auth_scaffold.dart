import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/app_theme.dart';

/// Shared themed shell: blue branded header + curved white sheet.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.child, this.showBack = false, required String title, required String subtitle});

  final Widget child;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final headerHeight = 180.h;
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final minSheet =
                math.max(0.0, constraints.maxHeight - headerHeight);
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: headerHeight,
                    child: _Header(showBack: showBack),
                  ),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 650),
                    curve: Curves.easeOutCubic,
                    builder: (_, v, sheet) => Opacity(
                      opacity: v,
                      child: Transform.translate(
                          offset: Offset(0, (1 - v) * 40), child: sheet),
                    ),
                    child: ClipPath(
                      clipper: _WaveClipper(),
                      child: Container(
                        color: Colors.white,
                        constraints: BoxConstraints(minHeight: minSheet),
                        padding: EdgeInsets.fromLTRB(24.w, 100.h, 24.w, 32.h),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 440.w),
                            child: child,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.showBack});
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (showBack)
          Positioned(
            left: 8.w,
            top: 8.h,
            child: IconButton(
              tooltip: 'Back',
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 40.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppBrand.name, style: AppTheme.script(size: 42)),
                SizedBox(height: 6.h),
                Text(
                  AppBrand.tagline,
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    return Path()
      ..moveTo(0, 70.h)
      ..cubicTo(w * 0.30, 5.h, w * 0.62, 125.h, w, 30.h)
      ..lineTo(w, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
