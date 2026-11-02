// Widget tests for the Login & Registration module.
// Place this file at: test/widget_test.dart
//
// Uses the built-in MockAuthService scenarios:
//   valid account     -> test@example.com / 9876543210  with  Password1
//   network error     -> any email containing "offline"
//   duplicate account -> test@example.com / 9876543210

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// NOTE: change `vampire_designs` if your package name (pubspec.yaml `name:`) differs.
import 'package:vampire_designs/core/app_theme.dart';
import 'package:vampire_designs/main.dart';
import 'package:vampire_designs/widgets/pill_toggle.dart';

/// Finds a text field by its hint text (the placeholder shown in the pill).
Finder field(String hint) => find.widgetWithText(TextFormField, hint);

/// The tab buttons inside the Log In / Sign Up toggle.
Finder toggleTab(String label) => find.descendant(
      of: find.byType(PillToggle),
      matching: find.text(label),
    );

/// The big submit button (not the toggle or text links).
Finder submitButton(String label) => find.widgetWithText(FilledButton, label);

/// Lets the mock API's 1.5 s latency elapse, then settles animations.
/// (Can't use pumpAndSettle while the button spinner is animating.)
Future<void> waitForApi(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle();
}

Future<void> openAuthScreen(WidgetTester tester) async {
  await tester.pumpWidget(const AuthApp());
  await tester.pump(const Duration(seconds: 3)); // splash timer (2.8 s)
  await tester.pumpAndSettle(); // fade transition to login
}

Future<void> goToSignUp(WidgetTester tester) async {
  await tester.tap(toggleTab('Sign Up'));
  await tester.pumpAndSettle();
}

Future<void> fillRegistration(
  WidgetTester tester, {
  String name = 'Jane Doe',
  String email = 'jane@example.com',
  String mobile = '9123456780',
  String password = 'Password1',
  String confirm = 'Password1',
}) async {
  await tester.enterText(field('Full name'), name);
  await tester.enterText(field('Email address'), email);
  await tester.enterText(field('Mobile number'), mobile);
  await tester.enterText(field('Password'), password);
  await tester.enterText(field('Confirm password'), confirm);
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    // Avoid network font downloads during tests.
    AppTheme.useGoogleFonts = false;
  });

  /// Tall virtual screen so the long registration form is fully on-screen.
  void useTallScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
  }

  group('Splash', () {
    testWidgets('shows brand, then navigates to login', (tester) async {
      useTallScreen(tester);
      await tester.pumpWidget(const AuthApp());
      await tester.pump(const Duration(milliseconds: 800));

      expect(find.text(AppBrand.name), findsOneWidget);
      expect(find.byType(PillToggle), findsNothing);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(find.byType(PillToggle), findsOneWidget);
      expect(field('Email or mobile number'), findsOneWidget);
    });
  });

  group('Login', () {
    testWidgets('shows required-field errors when submitted empty',
        (tester) async {
      useTallScreen(tester);
      await openAuthScreen(tester);

      await tester.tap(submitButton('Log In'));
      await tester.pump();

      expect(find.text('Email or mobile number is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('rejects an invalid email format', (tester) async {
      useTallScreen(tester);
      await openAuthScreen(tester);

      await tester.enterText(field('Email or mobile number'), 'bad@');
      await tester.enterText(field('Password'), 'Password1');
      await tester.tap(submitButton('Log In'));
      await tester.pump();

      expect(find.text('Enter a valid email address'), findsOneWidget);
    });

    testWidgets('show / hide password toggles obscuring', (tester) async {
      useTallScreen(tester);
      await openAuthScreen(tester);

      bool obscured() => tester
          .widget<EditableText>(find.descendant(
              of: field('Password'), matching: find.byType(EditableText)))
          .obscureText;

      expect(obscured(), isTrue);
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();
      expect(obscured(), isFalse);
      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();
      expect(obscured(), isTrue);
    });

    testWidgets('valid login shows loader then navigates to home',
        (tester) async {
      useTallScreen(tester);
      await openAuthScreen(tester);

      await tester.enterText(
          field('Email or mobile number'), 'test@example.com');
      await tester.enterText(field('Password'), 'Password1');
      await tester.tap(submitButton('Log In'));
      await tester.pump(const Duration(milliseconds: 300));

      // Loading indicator is visible while the mock API responds.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await waitForApi(tester);

      expect(find.text('Hello, Test User!'), findsOneWidget);
      expect(find.byType(PillToggle), findsNothing);
    });

    testWidgets('wrong password shows an error dialog', (tester) async {
      useTallScreen(tester);
      await openAuthScreen(tester);

      await tester.enterText(
          field('Email or mobile number'), 'test@example.com');
      await tester.enterText(field('Password'), 'WrongPass9');
      await tester.tap(submitButton('Log In'));
      await waitForApi(tester);

      expect(find.text('Login failed'), findsOneWidget);
      expect(find.text('Incorrect email/mobile number or password.'),
          findsOneWidget);

      await tester.tap(submitButton('Try again'));
      await tester.pumpAndSettle();
      expect(find.text('Login failed'), findsNothing);
      expect(find.byType(PillToggle), findsOneWidget); // still on login
    });

    testWidgets('network error scenario shows a friendly message',
        (tester) async {
      useTallScreen(tester);
      await openAuthScreen(tester);

      await tester.enterText(
          field('Email or mobile number'), 'offline@example.com');
      await tester.enterText(field('Password'), 'Password1');
      await tester.tap(submitButton('Log In'));
      await waitForApi(tester);

      expect(find.text('Login failed'), findsOneWidget);
      expect(find.textContaining('No internet connection'), findsOneWidget);
    });

    testWidgets('remember me prefills the saved identifier', (tester) async {
      useTallScreen(tester);
      SharedPreferences.setMockInitialValues(
          {'remember_identifier': 'test@example.com'});
      await openAuthScreen(tester);

      expect(find.text('test@example.com'), findsOneWidget);
      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);
    });

    testWidgets('forgot password flow: navigate, submit, return',
        (tester) async {
      useTallScreen(tester);
      await openAuthScreen(tester);

      await tester.tap(find.text('Forgot password?').last);
      await tester.pumpAndSettle();
      expect(submitButton('Send reset link'), findsOneWidget);

      // Validation
      await tester.tap(submitButton('Send reset link'));
      await tester.pump();
      expect(find.text('Email is required'), findsOneWidget);

      // Success
      await tester.enterText(field('Email address'), 'test@example.com');
      await tester.tap(submitButton('Send reset link'));
      await waitForApi(tester);
      expect(find.text('Email sent'), findsOneWidget);

      await tester.tap(submitButton('Back to login'));
      await tester.pumpAndSettle();
      expect(field('Email or mobile number'), findsOneWidget);
    });
  });

  group('Registration', () {
    testWidgets('toggle switches between login and sign-up forms',
        (tester) async {
      useTallScreen(tester);
      await openAuthScreen(tester);
      expect(field('Full name'), findsNothing);

      await goToSignUp(tester);
      expect(field('Full name'), findsOneWidget);
      expect(field('Confirm password'), findsOneWidget);
      expect(field('Email or mobile number'), findsNothing);

      await tester.tap(toggleTab('Log In'));
      await tester.pumpAndSettle();
      expect(field('Email or mobile number'), findsOneWidget);
    });

    testWidgets('shows required-field errors when submitted empty',
        (tester) async {
      useTallScreen(tester);
      await openAuthScreen(tester);
      await goToSignUp(tester);

      await tester.tap(submitButton('Sign Up'));
      await tester.pump();

      expect(find.text('Full name is required'), findsOneWidget);
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Mobile number is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
    });

    testWidgets('validates mobile, password strength and confirmation',
        (tester) async {
      useTallScreen(tester);
      await openAuthScreen(tester);
      await goToSignUp(tester);

      await fillRegistration(
        tester,
        mobile: '123',
        password: 'abc',
        confirm: 'different',
      );
      await tester.tap(submitButton('Sign Up'));
      await tester.pump();

      expect(find.text('Enter a valid mobile number (10-15 digits)'),
          findsOneWidget);
      expect(find.text('Password must be at least 8 characters'),
          findsOneWidget);
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('successful registration shows dialog, returns to login '
        'with email prefilled', (tester) async {
      useTallScreen(tester);
      await openAuthScreen(tester);
      await goToSignUp(tester);

      await fillRegistration(tester);
      await tester.tap(submitButton('Sign Up'));
      await waitForApi(tester);

      expect(find.text('Registration successful'), findsOneWidget);

      await tester.tap(submitButton('Go to login'));
      await tester.pumpAndSettle();

      expect(field('Email or mobile number'), findsOneWidget);
      expect(find.text('jane@example.com'), findsOneWidget);
    });

    testWidgets('duplicate account shows an error dialog', (tester) async {
      useTallScreen(tester);
      await openAuthScreen(tester);
      await goToSignUp(tester);

      await fillRegistration(tester,
          email: 'test@example.com', mobile: '9876543210');
      await tester.tap(submitButton('Sign Up'));
      await waitForApi(tester);

      expect(find.text('Registration failed'), findsOneWidget);
      expect(
        find.text('An account with this email or mobile number already exists.'),
        findsOneWidget,
      );
    });

    testWidgets('a newly registered user can log in', (tester) async {
      useTallScreen(tester);
      await openAuthScreen(tester);
      await goToSignUp(tester);

      await fillRegistration(tester);
      await tester.tap(submitButton('Sign Up'));
      await waitForApi(tester);
      await tester.tap(submitButton('Go to login'));
      await tester.pumpAndSettle();

      await tester.enterText(field('Password'), 'Password1');
      await tester.tap(submitButton('Log In'));
      await waitForApi(tester);

      expect(find.text('Hello, Jane Doe!'), findsOneWidget);
    });
  });
}