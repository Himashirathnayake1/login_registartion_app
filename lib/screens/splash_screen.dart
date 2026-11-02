import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/app_routes.dart';
import '../core/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..forward();

  late final Animation<double> _logo = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack));
  late final Animation<double> _title = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.8, curve: Curves.easeOut));
  late final Animation<double> _tagline = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 1.0, curve: Curves.easeOut));

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // In a real app, check for a stored session here before choosing a route.
    _timer = Timer(const Duration(milliseconds: 2800), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),
              ScaleTransition(
                scale: _logo,
                child: Container(
                  width: 104.w,
                  height: 104.h,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 24,
                          offset: Offset(0, 10)),
                    ],
                  ),
                  child: Icon(Icons.phone_iphone_rounded,
                      size: 56.w, color: AppColors.primary),
                ),
              ),
              SizedBox(height: 28.h),
              FadeTransition(
                opacity: _title,
                child: SlideTransition(
                  position: Tween(begin: const Offset(0, 0.3), end: Offset.zero)
                      .animate(_title),
                  child: Text(AppBrand.name, style: AppTheme.script(size: 46)),
                ),
              ),
              SizedBox(height: 8.h),
              FadeTransition(
                opacity: _tagline,
                child: Text(AppBrand.tagline,
                    style: TextStyle(color: Colors.white, fontSize: 16.sp)),
              ),
              const Spacer(flex: 3),
              FadeTransition(
                opacity: _tagline,
                child: SizedBox(
                  height: 26.h,
                  width: 26.w,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.5.w, color: Colors.white),
                ),
              ),
              SizedBox(height: 48.h),
            ],
          ),
        ),
      ),
    );
  }
}
