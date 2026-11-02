# Vampire Designs

A responsive Flutter authentication app that demonstrates a complete sign-in and account-registration experience. It includes login, registration, password reset, remember-me, form validation, and a signed-in home screen.

> **Current backend status:** Authentication uses an in-memory `MockAuthService`. It is for local development and demonstrations only. It does not connect to a production API, save registered accounts across app restarts, or send real password-reset emails.

## Features

- Animated splash screen and branded authentication layout.
- Login with email address or mobile number.
- Login and registration forms on a single screen, switched with an animated toggle.
- Registration with full name, email, mobile number, password, and password confirmation.
- Show/hide controls for password fields.
- Remember-me preference for the login identifier, stored with `shared_preferences`.
- Password-reset request screen with input validation.
- Loading states and success/error dialogs.
- Home screen showing the signed-in user's name, email, and mobile number; logout returns to login.
- Responsive layouts and dimensions using `flutter_screenutil`, based on a **375 × 812** design size. Authentication content scrolls to accommodate smaller screens and the keyboard.
- Widget and validator tests.

## Requirements

- Flutter SDK **3.29.3 or later** (Dart SDK constraint: `^3.7.2`).
- Flutter-supported platform tooling for the target device, such as Android Studio/Android SDK for Android or Xcode for iOS.

Check the local Flutter installation:

```shell
flutter doctor
```

## Get started

From the project directory:

```shell
flutter pub get
flutter run
```

To select a connected device:

```shell
flutter devices
flutter run -d <device-id>
```

## Demo account

The mock service starts with this account:

| Field | Value |
|---|---|
| Email | `test@example.com` |
| Mobile | `9876543210` |
| Password | `Password1` |

Use either the email or mobile number to sign in. Accounts created from the registration screen are kept in memory only and are lost when the app process restarts.

### Mock service scenarios

The mock service adds a 1.5-second delay to authentication operations. For demonstration purposes, entering an email or identifier containing `offline` simulates a network error, and an identifier containing `server` simulates a server error. The password-reset flow succeeds only for an email already present in the mock service; it displays a confirmation but does not send an email.

## Validation rules

- **Full name:** Required; at least 3 characters; letters, spaces, periods, apostrophes, and hyphens are accepted.
- **Email:** Required and must have a valid email format.
- **Mobile:** Required; 10–15 digits, optionally prefixed with `+`. Spaces and hyphens are ignored.
- **Login identifier:** Required; must be a valid email address or mobile number.
- **Password at registration:** At least 8 characters and must contain an uppercase letter, a lowercase letter, and a number.
- **Confirm password:** Required and must match the password.

## Run checks

Run the analyzer and all tests:

```shell
flutter analyze
flutter test
```

Tests live in [`test/`](test/). The widget tests cover splash navigation, login and registration validation, password visibility, remember-me, password reset, authentication errors, and successful sign-in/registration flows.

## Project structure

```text
lib/
  main.dart                     App entry point, providers, ScreenUtil, and theme
  controllers/
    auth_controller.dart        Authentication state and remember-me persistence
  core/
    app_routes.dart             Named routes and page transitions
    app_theme.dart              Brand, color palette, and Material theme
    validators.dart             Reusable field validators
  models/
    auth_result.dart            Uniform success/failure result
    user_model.dart             User data model and JSON conversion
  screens/
    splash_screen.dart          Animated splash screen
    auth_screen.dart            Login/register toggle screen
    forgot_password_screen.dart Password-reset request form
    home_screen.dart            Signed-in user summary and logout
    forms/
      login_form.dart            Login form and actions
      register_form.dart         Registration form and actions
  services/
    auth_service.dart           AuthService contract and MockAuthService
  widgets/
    auth_scaffold.dart           Shared branded, scrollable auth layout
    app_text_field.dart          Reusable text field with password visibility
    primary_button.dart          Reusable full-width submit button
    pill_toggle.dart             Login/register selector
    app_dialogs.dart             Success and error dialogs
```

## App flow and routes

The app starts at the splash screen, which navigates to login after its animation. Login and registration share a screen; the separate registration route opens that screen with registration selected.

| Route | Screen |
|---|---|
| `/` | Splash |
| `/login` | Login |
| `/register` | Registration selected |
| `/forgot-password` | Password-reset request |
| `/home` | Signed-in home |

## Architecture

- **UI:** Flutter screens and reusable widgets.
- **State management:** `provider` exposes `AuthController` and `AuthService`.
- **Authentication boundary:** `AuthService` defines login, registration, and password-reset operations. `MockAuthService` is the current implementation; replace it with a real service when connecting a backend.
- **Remember-me:** `AuthController` stores the selected login identifier in `shared_preferences`. Passwords are not stored by the remember-me feature.
- **Responsive sizing:** `ScreenUtilInit` is configured in `lib/main.dart` with `Size(375, 812)`. Layout values use ScreenUtil extensions such as `.w`, `.h`, `.r`, and `.sp`.

## Dependencies

Key packages declared in [`pubspec.yaml`](pubspec.yaml):

- [`provider`](https://pub.dev/packages/provider) — app state and dependency access.
- [`flutter_screenutil`](https://pub.dev/packages/flutter_screenutil) — responsive sizing.
- [`shared_preferences`](https://pub.dev/packages/shared_preferences) — remember-me identifier persistence.
- [`google_fonts`](https://pub.dev/packages/google_fonts) — typography.
- [`cupertino_icons`](https://pub.dev/packages/cupertino_icons) — icon set.

## Production integration notes

Before using this app with real users:

1. Implement `AuthService` against a secure authentication API and provide it in `lib/main.dart`.
2. Use server-side password hashing and secure session/token handling; do not retain plain-text passwords.
3. Implement password-reset email delivery and appropriate anti-enumeration/rate-limiting behavior on the backend.
4. Decide how user accounts and authentication sessions should persist; the current mock account store is process-local.
5. Add environment-specific configuration, secure error handling, and integration tests for the real service.

<p align="center">
  <img width="30%" alt="Screenshot 1" src="https://github.com/user-attachments/assets/8e713085-83c0-4e88-87c5-0d4d695b3894" />
  <img width="30%" alt="Screenshot 2" src="https://github.com/user-attachments/assets/26d0abc9-741a-4d78-b3b9-d0e24e99732f" />
  <img width="30%" alt="Screenshot 3" src="https://github.com/user-attachments/assets/2ff3d408-1e7e-455f-bfcf-ad05bedc099f" />
</p>



## License

No license is currently specified in `pubspec.yaml`. Add a `LICENSE` file before distributing this project if a particular license is intended.
