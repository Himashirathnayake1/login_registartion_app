import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/pill_toggle.dart';
import 'forms/login_form.dart';
import 'forms/register_form.dart';

/// Login / Register on one screen, switched by the pill toggle.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late int _index = widget.initialIndex;
  String? _prefillIdentifier;

  void _go(int i) {
    if (context.read<AuthController>().isLoading) return;
    FocusScope.of(context).unfocus();
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: _index == 0 ? 'Log In' : 'Sign Up',
      subtitle: _index == 0
          ? 'Welcome back! Please log in to your account.'
          : 'Create a new account to get started.',
      child: Column(
        children: [
          PillToggle(
            labels: const ['Log In', 'Sign Up'],
            index: _index,
            onChanged: _go,
          ),
          SizedBox(height: 24.h),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween(
                          begin: const Offset(0, 0.04), end: Offset.zero)
                      .animate(animation),
                  child: child,
                ),
              ),
              child: _index == 0
                  ? LoginForm(
                      key: const ValueKey('login'),
                      initialIdentifier: _prefillIdentifier,
                      onSwitchToRegister: () => _go(1),
                    )
                  : RegisterForm(
                      key: const ValueKey('register'),
                      onRegistered: (email) {
                        setState(() {
                          _prefillIdentifier = email;
                          _index = 0;
                        });
                      },
                      onSwitchToLogin: () => _go(0),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
