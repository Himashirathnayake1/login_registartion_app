import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../core/validators.dart';
import '../widgets/app_dialogs.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _mobile = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    for (final c in [_name, _email, _mobile, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final result = await context.read<AuthController>().register(
          fullName: _name.text,
          email: _email.text,
          mobile: _mobile.text,
          password: _password.text,
        );
    if (!mounted) return;
    if (result.success) {
      await AppDialogs.success(context,
          title: 'Registration successful',
          message: result.message,
          button: 'Go to login');
      if (mounted) Navigator.of(context).pop();
    } else {
      AppDialogs.error(context,
          title: 'Registration failed', message: result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<AuthController>().isLoading;
    return AuthScaffold(
      showBack: true,
      title: 'Create account',
      subtitle: 'Fill in your details to get started',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppTextField(
              controller: _name,
              label: 'Full name',
              icon: Icons.badge_outlined,
              keyboardType: TextInputType.name,
              validator: Validators.fullName,
              enabled: !loading,
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _email,
              label: 'Email address',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
              enabled: !loading,
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _mobile,
              label: 'Mobile number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s-]')),
              ],
              validator: Validators.mobile,
              enabled: !loading,
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _password,
              label: 'Password',
              icon: Icons.lock_outline,
              isPassword: true,
              validator: Validators.strongPassword,
              enabled: !loading,
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _confirm,
              label: 'Confirm password',
              icon: Icons.lock_reset_outlined,
              isPassword: true,
              textInputAction: TextInputAction.done,
              validator: Validators.confirmPassword(() => _password.text),
              onSubmitted: _submit,
              enabled: !loading,
            ),
            SizedBox(height: 24.h),
            PrimaryButton(
                label: 'Register', isLoading: loading, onPressed: _submit),
            SizedBox(height: 8.h),
            TextButton(
              onPressed: loading ? null : () => Navigator.of(context).pop(),
              child: const Text('Already have an account? Log in'),
            ),
          ],
        ),
      ),
    );
  }
}
