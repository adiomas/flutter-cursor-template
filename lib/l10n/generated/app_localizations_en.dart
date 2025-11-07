// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'GlowAI';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get done => 'Done';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get refresh => 'Refresh';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get sort => 'Sort';

  @override
  String get settings => 'Settings';

  @override
  String get help => 'Help';

  @override
  String get about => 'About';

  @override
  String get profile => 'Profile';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get goToLogin => 'Go to Login';

  @override
  String get validationRequired => 'This field is required';

  @override
  String get validationEmail => 'Please enter a valid email';

  @override
  String get validationEmailInvalid => 'Invalid email format';

  @override
  String get validationEmailRequired => 'Please enter your email';

  @override
  String get validationPassword => 'Password must be at least 8 characters';

  @override
  String get validationPasswordWeak => 'Password is too weak';

  @override
  String get validationPasswordMismatch => 'Passwords do not match';

  @override
  String get validationPasswordRequired => 'Please enter your password';

  @override
  String get validationNameRequired => 'Please enter your name';

  @override
  String validationMinLength(int min) {
    return 'Must be at least $min characters';
  }

  @override
  String validationMaxLength(int max) {
    return 'Must be no more than $max characters';
  }

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork =>
      'No internet connection. Please check your network.';

  @override
  String get errorNetworkTimeout => 'Request timed out. Please try again.';

  @override
  String get errorTimeout => 'Request timed out. Please try again.';

  @override
  String get errorNotFound => 'Resource not found';

  @override
  String get errorUnauthorized =>
      'You are not authorized to access this resource';

  @override
  String get errorForbidden => 'Access forbidden';

  @override
  String get errorServerError =>
      'Server error occurred. Please try again later.';

  @override
  String get errorBadRequest => 'Invalid request. Please check your input.';

  @override
  String get errorUnknown => 'An unknown error occurred';

  @override
  String get errorOops => 'Oops!';

  @override
  String get errorSignInFailed => 'Failed to sign in. Please try again.';

  @override
  String get errorSignUpFailed => 'Failed to sign up. Please try again.';

  @override
  String get errorEmailNotConfirmed =>
      'Please confirm your email address before signing in.';

  @override
  String get authResendConfirmation => 'Resend confirmation email';

  @override
  String get authConfirmationEmailSent =>
      'Confirmation email sent! Please check your inbox.';

  @override
  String get authRegistrationSuccessTitle => 'Registration Successful!';

  @override
  String authRegistrationSuccessMessage(String email) {
    return 'We\'ve sent a confirmation email to $email. Please check your inbox and click the confirmation link to activate your account.';
  }

  @override
  String get authGoToLogin => 'Go to Login';

  @override
  String errorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get successSaved => 'Saved successfully';

  @override
  String get successDeleted => 'Deleted successfully';

  @override
  String get successUpdated => 'Updated successfully';

  @override
  String get successCreated => 'Created successfully';

  @override
  String get successCopied => 'Copied to clipboard';

  @override
  String get successSent => 'Sent successfully';

  @override
  String get confirmDelete => 'Are you sure you want to delete this?';

  @override
  String get confirmDeleteTitle => 'Confirm Delete';

  @override
  String get confirmLogout => 'Are you sure you want to logout?';

  @override
  String get confirmLogoutTitle => 'Confirm Logout';

  @override
  String get confirmCancel => 'Are you sure you want to cancel?';

  @override
  String get confirmDiscard => 'Discard unsaved changes?';

  @override
  String get emptyListTitle => 'Nothing here yet';

  @override
  String get emptyListMessage => 'Tap the + button to add your first item';

  @override
  String get emptySearchResults => 'No results found';

  @override
  String get emptySearchMessage => 'Try different keywords';

  @override
  String get emptyActivityTitle => 'No activity yet';

  @override
  String get emptyActivityMessage => 'Start by uploading your first photo';

  @override
  String get authLogin => 'Login';

  @override
  String get authLogout => 'Logout';

  @override
  String get authRegister => 'Register';

  @override
  String get authSignIn => 'Sign In';

  @override
  String get authSignUp => 'Sign Up';

  @override
  String get authSignUpWithEmail => 'Sign up with Email';

  @override
  String get authSignOut => 'Sign Out';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authConfirmPassword => 'Confirm Password';

  @override
  String get authFullName => 'Full Name';

  @override
  String get authForgotPassword => 'Forgot Password?';

  @override
  String get authResetPassword => 'Reset Password';

  @override
  String get authDontHaveAccount => 'Don\'t have an account?';

  @override
  String get authAlreadyHaveAccount => 'Already have an account?';

  @override
  String get authCreateAccount => 'Create Account';

  @override
  String get authWelcomeBack => 'Welcome back!';

  @override
  String get authWelcomeToGlowAI => 'Welcome to GlowAI';

  @override
  String get authSignInToContinue => 'Sign in to continue';

  @override
  String get authSignUpToGetStarted => 'Sign up to get started';

  @override
  String get authGetStarted => 'Get started now';

  @override
  String get authEnterYourName => 'Enter your name';

  @override
  String get authEnterYourEmail => 'Enter your email';

  @override
  String get authEnterYourPassword => 'Enter your password';

  @override
  String get authReEnterYourPassword => 'Re-enter your password';

  @override
  String get authWelcomeBackUser => 'Welcome back,';

  @override
  String get authUser => 'User';

  @override
  String get authRecent => 'Recent';

  @override
  String get authSignInWithGoogle => 'Continue with Google';

  @override
  String get authSignInWithApple => 'Continue with Apple';

  @override
  String get authOrContinueWith => 'Or continue with';

  @override
  String authOAuthError(String provider) {
    return 'Failed to sign in with $provider. Please try again.';
  }

  @override
  String get authOAuthCancelled => 'Sign in was cancelled';

  @override
  String authOAuthNotConfigured(String provider) {
    return '$provider Sign In is not configured. Please configure $provider Client IDs in Supabase dashboard.';
  }

  @override
  String get dashboardProjects => 'Projects';

  @override
  String get dashboardFavorites => 'Favorites';

  @override
  String get dashboardAIEdits => 'AI Edits';

  @override
  String get dashboardUploads => 'Uploads';

  @override
  String get dashboardQuickActions => 'Quick Actions';

  @override
  String get dashboardUploadPhoto => 'Upload Photo';

  @override
  String get dashboardUploadPhotoSubtitle => 'Start a new AI-powered edit';

  @override
  String get dashboardBrowseProjects => 'Browse Projects';

  @override
  String get dashboardBrowseProjectsSubtitle => 'View your saved projects';

  @override
  String get dashboardAITemplates => 'AI Templates';

  @override
  String get dashboardAITemplatesSubtitle => 'Explore AI editing templates';

  @override
  String get dashboardRecentActivity => 'Recent Activity';

  @override
  String get dashboardLoggerDemo => '🐛 Logger Demo';

  @override
  String get dashboardLoggerDemoSubtitle =>
      'Test logging system & shake-to-open console';

  @override
  String get dateToday => 'Today';

  @override
  String get dateYesterday => 'Yesterday';

  @override
  String get dateTomorrow => 'Tomorrow';

  @override
  String get dateThisWeek => 'This Week';

  @override
  String get dateLastWeek => 'Last Week';

  @override
  String get dateThisMonth => 'This Month';

  @override
  String get dateLastMonth => 'Last Month';

  @override
  String get timeNow => 'Now';

  @override
  String get timeJustNow => 'Just now';

  @override
  String timeMinutesAgo(int minutes) {
    return '$minutes minutes ago';
  }

  @override
  String timeHoursAgo(int hours) {
    return '$hours hours ago';
  }

  @override
  String get placeholderSearch => 'Search...';

  @override
  String get placeholderEnterText => 'Enter text';

  @override
  String get placeholderEnterEmail => 'Enter your email';

  @override
  String get placeholderEnterPassword => 'Enter your password';

  @override
  String get placeholderSelectOption => 'Select an option';

  @override
  String greetingHello(String name) {
    return 'Hello, $name!';
  }

  @override
  String greetingWelcome(String name) {
    return 'Welcome, $name!';
  }

  @override
  String itemsCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString items',
      one: '1 item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String resultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results',
      one: '1 result',
      zero: 'No results',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days ago',
      one: 'yesterday',
      zero: 'today',
    );
    return '$_temp0';
  }

  @override
  String formattedDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Updated on $dateString';
  }

  @override
  String formattedTime(DateTime time) {
    final intl.DateFormat timeDateFormat = intl.DateFormat.jm(localeName);
    final String timeString = timeDateFormat.format(time);

    return 'at $timeString';
  }

  @override
  String formattedDateTime(DateTime date, DateTime time) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);
    final intl.DateFormat timeDateFormat = intl.DateFormat.jm(localeName);
    final String timeString = timeDateFormat.format(time);

    return '$dateString at $timeString';
  }

  @override
  String formattedPrice(double price) {
    final intl.NumberFormat priceNumberFormat = intl.NumberFormat.currency(
      locale: localeName,
      symbol: '\$',
      decimalDigits: 2,
    );
    final String priceString = priceNumberFormat.format(price);

    return '$priceString';
  }

  @override
  String formattedPercentage(int percent) {
    return '$percent%';
  }

  @override
  String get networkOnline => 'Back online';

  @override
  String get networkOffline => 'No connection';

  @override
  String get networkReconnecting => 'Reconnecting...';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsDeleteAccount => 'Delete Account';

  @override
  String get settingsDeleteAccountDescription =>
      'Permanently delete your account and all associated data. This action cannot be undone.';

  @override
  String get settingsDeleteAccountConfirmTitle => 'Delete Account?';

  @override
  String get settingsDeleteAccountConfirmMessage =>
      'Are you sure you want to delete your account? This will permanently delete all your data and cannot be undone.';

  @override
  String get settingsDeleteAccountConfirmSecondTitle => 'Final Confirmation';

  @override
  String get settingsDeleteAccountConfirmSecondMessage =>
      'This is your last chance to cancel. Deleting your account will permanently remove all your data. Are you absolutely sure?';

  @override
  String get settingsDeleteAccountSuccess => 'Account deleted successfully';

  @override
  String get settingsDeleteAccountError =>
      'Failed to delete account. Please try again.';

  @override
  String get settingsDeleteAccountInProgress => 'Deleting account...';

  @override
  String get profileDisplayName => 'Display Name';

  @override
  String get profileDisplayNameHint => 'Enter your display name';

  @override
  String get profileSelectAvatarSource => 'Select Photo Source';

  @override
  String get profileSelectFromGallery => 'Choose from Gallery';

  @override
  String get profileTakePhoto => 'Take Photo';

  @override
  String get profileAvatarUpdated => 'Avatar updated successfully';

  @override
  String get profileManageDescription => 'Manage your profile and avatar';

  @override
  String get profileMemberSince => 'Member since';

  @override
  String get errorImagePickerPermission =>
      'Permission denied. Please grant camera/photo access in settings.';

  @override
  String get errorImagePickerFileNotFound =>
      'Selected image file not found. Please try again.';

  @override
  String get errorImagePickerGeneric =>
      'Failed to pick image. Please try again.';

  @override
  String get errorPlatformError => 'Platform error occurred. Please try again.';

  @override
  String get navHome => 'Home';

  @override
  String get navGenerate => 'Generate';

  @override
  String get navProfile => 'Profile';

  @override
  String get generateTitle => 'Generate';
}
