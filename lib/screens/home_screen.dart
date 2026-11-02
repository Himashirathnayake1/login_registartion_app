import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../core/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthController>().currentUser;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64.h,
        title: Text('Home', style: TextStyle(fontSize: 20.sp)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: IconButton(
              tooltip: 'Logout',
              iconSize: 25.w,
              padding: EdgeInsets.all(12.r),
              constraints: BoxConstraints(
                minWidth: 56.w,
                minHeight: 56.h,
              ),
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthController>().logout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.login, (route) => false);
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.r),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 440.w),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_user_outlined, size: 56.w),
                    SizedBox(height: 12.h),
                    Text('Hello, ${user?.fullName ?? 'User'}!',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center),
                    SizedBox(height: 8.h),
                    Text(user?.email ?? ''),
                    Text(user?.mobile ?? ''),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
