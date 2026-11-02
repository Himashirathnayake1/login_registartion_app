import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../core/validators.dart';
import '../widgets/app_dialogs.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/primary_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final result =
        await context.read<AuthController>().forgotPassword(_email.text);
    if (!mounted) return;
    if (result.success) {
      await AppDialogs.success(context,
          title: 'Email sent', message: result.message, button: 'Back to login');
      if (mounted) Navigator.of(context).pop();
    } else {
      AppDialogs.error(context, title: 'Request failed', message: result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<AuthController>().isLoading;
    final theme = Theme.of(context);
    return AuthScaffold(
      title: 'Forgot Password',
      subtitle: 'Enter your email to receive a password reset link.',
      showBack: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Forgot password?',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700)),
            SizedBox(height: 6.h),
            Text("Enter your email and we'll send you a reset link.",
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            SizedBox(height: 24.h),
            AppTextField(
              controller: _email,
              label: 'Email address',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              validator: Validators.email,
              onSubmitted: _submit,
              enabled: !loading,
            ),
            SizedBox(height: 24.h),
            PrimaryButton(
                label: 'Send reset link', isLoading: loading, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
