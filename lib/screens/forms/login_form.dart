import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../core/app_routes.dart';
import '../../core/validators.dart';
import '../../widgets/app_dialogs.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.onSwitchToRegister,
    this.initialIdentifier,
  });

  final VoidCallback onSwitchToRegister;
  final String? initialIdentifier;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late final _identifier =
      TextEditingController(text: widget.initialIdentifier ?? '');
  final _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AuthController>().loadRemembered().then((saved) {
      if (mounted && saved != null && _identifier.text.isEmpty) {
        _identifier.text = saved;
      }
    });
  }

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final result = await context
        .read<AuthController>()
        .login(_identifier.text, _password.text);
    if (!mounted) return;
    if (result.success) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } else {
      AppDialogs.error(context, title: 'Login failed', message: result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<AuthController>();
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppTextField(
            controller: _identifier,
            label: 'Email or mobile number',
            icon: Icons.person_outline,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.emailOrMobile,
            enabled: !ctrl.isLoading,
          ),
          SizedBox(height: 16.h),
          AppTextField(
            controller: _password,
            label: 'Password',
            icon: Icons.lock_outline,
            isPassword: true,
            textInputAction: TextInputAction.done,
            validator: Validators.requiredPassword,
            onSubmitted: _submit,
            enabled: !ctrl.isLoading,
          ),
          SizedBox(height: 4.h),
          // Wrap prevents overflow on narrow screens / large text scale.
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(8.r),
                onTap: ctrl.isLoading
                    ? null
                    : () => ctrl.setRememberMe(!ctrl.rememberMe),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 32.w,
                      height: 32.h,
                      child: Checkbox(
                        value: ctrl.rememberMe,
                        onChanged: ctrl.isLoading
                            ? null
                            : (v) => ctrl.setRememberMe(v ?? false),
                      ),
                    ),
                    Text(
                      'Remember me',
                      style: TextStyle(fontSize: 13.sp),
                    ),
                    SizedBox(width: 8.w),
                  ],
                ),
              ),
              TextButton(
                onPressed: ctrl.isLoading
                    ? null
                    : () => Navigator.of(context)
                        .pushNamed(AppRoutes.forgotPassword),
                child: const Text('Forgot password?'),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          PrimaryButton(
              label: 'Log In', isLoading: ctrl.isLoading, onPressed: _submit),
          SizedBox(height: 12.h),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: TextStyle(fontSize: 13.sp),
              ),
              TextButton(
                onPressed: ctrl.isLoading ? null : widget.onSwitchToRegister,
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
