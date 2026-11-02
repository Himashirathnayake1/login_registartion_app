import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../core/validators.dart';
import '../../widgets/app_dialogs.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
    required this.onRegistered,
    required this.onSwitchToLogin,
  });

  final ValueChanged<String> onRegistered;
  final VoidCallback onSwitchToLogin;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
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
    final email = _email.text.trim();
    final result = await context.read<AuthController>().register(
          fullName: _name.text,
          email: email,
          mobile: _mobile.text,
          password: _password.text,
        );
    if (!mounted) return;
    if (result.success) {
      await AppDialogs.success(context,
          title: 'Registration successful',
          message: result.message,
          button: 'Go to login');
      if (mounted) widget.onRegistered(email);
    } else {
      AppDialogs.error(context,
          title: 'Registration failed', message: result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<AuthController>().isLoading;
    return Form(
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
              label: 'Sign Up', isLoading: loading, onPressed: _submit),
          SizedBox(height: 12.h),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
             Text('Already have an account?',style: TextStyle(fontSize: 13.sp),),
              
              TextButton(
                onPressed: loading ? null : widget.onSwitchToLogin,
                child: const Text('Log In'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
