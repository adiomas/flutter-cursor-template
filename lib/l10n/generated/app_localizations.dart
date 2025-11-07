import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Application title shown in app bar and task switcher
  ///
  /// In en, this message translates to:
  /// **'GlowAI'**
  String get appTitle;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @goToLogin.
  ///
  /// In en, this message translates to:
  /// **'Go to Login'**
  String get goToLogin;

  /// Generic required field validation message
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validationRequired;

  /// No description provided for @validationEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get validationEmail;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get validationEmailInvalid;

  /// No description provided for @validationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get validationEmailRequired;

  /// No description provided for @validationPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get validationPassword;

  /// No description provided for @validationPasswordWeak.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get validationPasswordWeak;

  /// No description provided for @validationPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationPasswordMismatch;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get validationPasswordRequired;

  /// No description provided for @validationNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get validationNameRequired;

  /// Minimum length validation
  ///
  /// In en, this message translates to:
  /// **'Must be at least {min} characters'**
  String validationMinLength(int min);

  /// Maximum length validation
  ///
  /// In en, this message translates to:
  /// **'Must be no more than {max} characters'**
  String validationMaxLength(int max);

  /// Generic error message when specific error is unknown
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network.'**
  String get errorNetwork;

  /// No description provided for @errorNetworkTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again.'**
  String get errorNetworkTimeout;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again.'**
  String get errorTimeout;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Resource not found'**
  String get errorNotFound;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'You are not authorized to access this resource'**
  String get errorUnauthorized;

  /// No description provided for @errorForbidden.
  ///
  /// In en, this message translates to:
  /// **'Access forbidden'**
  String get errorForbidden;

  /// No description provided for @errorServerError.
  ///
  /// In en, this message translates to:
  /// **'Server error occurred. Please try again later.'**
  String get errorServerError;

  /// No description provided for @errorBadRequest.
  ///
  /// In en, this message translates to:
  /// **'Invalid request. Please check your input.'**
  String get errorBadRequest;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get errorUnknown;

  /// No description provided for @errorOops.
  ///
  /// In en, this message translates to:
  /// **'Oops!'**
  String get errorOops;

  /// No description provided for @errorSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to sign in. Please try again.'**
  String get errorSignInFailed;

  /// No description provided for @errorSignUpFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to sign up. Please try again.'**
  String get errorSignUpFailed;

  /// Error message when email is not confirmed
  ///
  /// In en, this message translates to:
  /// **'Please confirm your email address before signing in.'**
  String get errorEmailNotConfirmed;

  /// Button text to resend email confirmation
  ///
  /// In en, this message translates to:
  /// **'Resend confirmation email'**
  String get authResendConfirmation;

  /// Success message when confirmation email is resent
  ///
  /// In en, this message translates to:
  /// **'Confirmation email sent! Please check your inbox.'**
  String get authConfirmationEmailSent;

  /// Title shown after successful registration
  ///
  /// In en, this message translates to:
  /// **'Registration Successful!'**
  String get authRegistrationSuccessTitle;

  /// Message shown after registration with email confirmation instructions
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a confirmation email to {email}. Please check your inbox and click the confirmation link to activate your account.'**
  String authRegistrationSuccessMessage(String email);

  /// Button text to navigate to login page
  ///
  /// In en, this message translates to:
  /// **'Go to Login'**
  String get authGoToLogin;

  /// Error prefix with error message
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorPrefix(String error);

  /// No description provided for @successSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get successSaved;

  /// No description provided for @successDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted successfully'**
  String get successDeleted;

  /// No description provided for @successUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated successfully'**
  String get successUpdated;

  /// No description provided for @successCreated.
  ///
  /// In en, this message translates to:
  /// **'Created successfully'**
  String get successCreated;

  /// No description provided for @successCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get successCopied;

  /// No description provided for @successSent.
  ///
  /// In en, this message translates to:
  /// **'Sent successfully'**
  String get successSent;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this?'**
  String get confirmDelete;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get confirmLogout;

  /// No description provided for @confirmLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmLogoutTitle;

  /// No description provided for @confirmCancel.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel?'**
  String get confirmCancel;

  /// No description provided for @confirmDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard unsaved changes?'**
  String get confirmDiscard;

  /// Generic empty list title
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyListTitle;

  /// Generic empty list message
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to add your first item'**
  String get emptyListMessage;

  /// No description provided for @emptySearchResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get emptySearchResults;

  /// No description provided for @emptySearchMessage.
  ///
  /// In en, this message translates to:
  /// **'Try different keywords'**
  String get emptySearchMessage;

  /// No description provided for @emptyActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'No activity yet'**
  String get emptyActivityTitle;

  /// No description provided for @emptyActivityMessage.
  ///
  /// In en, this message translates to:
  /// **'Start by uploading your first photo'**
  String get emptyActivityMessage;

  /// No description provided for @authLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authLogin;

  /// No description provided for @authLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get authLogout;

  /// No description provided for @authRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get authRegister;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignIn;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authSignUp;

  /// Button text for email sign up
  ///
  /// In en, this message translates to:
  /// **'Sign up with Email'**
  String get authSignUpWithEmail;

  /// No description provided for @authSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get authSignOut;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPassword;

  /// No description provided for @authFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get authFullName;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get authForgotPassword;

  /// No description provided for @authResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get authResetPassword;

  /// No description provided for @authDontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get authDontHaveAccount;

  /// No description provided for @authAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authAlreadyHaveAccount;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authCreateAccount;

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get authWelcomeBack;

  /// No description provided for @authWelcomeToGlowAI.
  ///
  /// In en, this message translates to:
  /// **'Welcome to GlowAI'**
  String get authWelcomeToGlowAI;

  /// No description provided for @authSignInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get authSignInToContinue;

  /// No description provided for @authSignUpToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Sign up to get started'**
  String get authSignUpToGetStarted;

  /// No description provided for @authGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started now'**
  String get authGetStarted;

  /// No description provided for @authEnterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get authEnterYourName;

  /// No description provided for @authEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get authEnterYourEmail;

  /// No description provided for @authEnterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get authEnterYourPassword;

  /// No description provided for @authReEnterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get authReEnterYourPassword;

  /// No description provided for @authWelcomeBackUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get authWelcomeBackUser;

  /// No description provided for @authUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get authUser;

  /// Label for most recently used email in autocomplete
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get authRecent;

  /// Button text for Google sign in
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authSignInWithGoogle;

  /// Button text for Apple sign in
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get authSignInWithApple;

  /// Text before OAuth buttons
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get authOrContinueWith;

  /// Error message for OAuth sign in failures
  ///
  /// In en, this message translates to:
  /// **'Failed to sign in with {provider}. Please try again.'**
  String authOAuthError(String provider);

  /// Message when user cancels OAuth sign in
  ///
  /// In en, this message translates to:
  /// **'Sign in was cancelled'**
  String get authOAuthCancelled;

  /// Error message when OAuth provider is not configured
  ///
  /// In en, this message translates to:
  /// **'{provider} Sign In is not configured. Please configure {provider} Client IDs in Supabase dashboard.'**
  String authOAuthNotConfigured(String provider);

  /// No description provided for @dashboardProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get dashboardProjects;

  /// No description provided for @dashboardFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get dashboardFavorites;

  /// No description provided for @dashboardAIEdits.
  ///
  /// In en, this message translates to:
  /// **'AI Edits'**
  String get dashboardAIEdits;

  /// No description provided for @dashboardUploads.
  ///
  /// In en, this message translates to:
  /// **'Uploads'**
  String get dashboardUploads;

  /// No description provided for @dashboardQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get dashboardQuickActions;

  /// No description provided for @dashboardUploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get dashboardUploadPhoto;

  /// No description provided for @dashboardUploadPhotoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start a new AI-powered edit'**
  String get dashboardUploadPhotoSubtitle;

  /// No description provided for @dashboardBrowseProjects.
  ///
  /// In en, this message translates to:
  /// **'Browse Projects'**
  String get dashboardBrowseProjects;

  /// No description provided for @dashboardBrowseProjectsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View your saved projects'**
  String get dashboardBrowseProjectsSubtitle;

  /// No description provided for @dashboardAITemplates.
  ///
  /// In en, this message translates to:
  /// **'AI Templates'**
  String get dashboardAITemplates;

  /// No description provided for @dashboardAITemplatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore AI editing templates'**
  String get dashboardAITemplatesSubtitle;

  /// No description provided for @dashboardRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get dashboardRecentActivity;

  /// Debug action button title for logger demo
  ///
  /// In en, this message translates to:
  /// **'🐛 Logger Demo'**
  String get dashboardLoggerDemo;

  /// Debug action button subtitle for logger demo
  ///
  /// In en, this message translates to:
  /// **'Test logging system & shake-to-open console'**
  String get dashboardLoggerDemoSubtitle;

  /// No description provided for @dateToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateToday;

  /// No description provided for @dateYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get dateYesterday;

  /// No description provided for @dateTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get dateTomorrow;

  /// No description provided for @dateThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get dateThisWeek;

  /// No description provided for @dateLastWeek.
  ///
  /// In en, this message translates to:
  /// **'Last Week'**
  String get dateLastWeek;

  /// No description provided for @dateThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get dateThisMonth;

  /// No description provided for @dateLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get dateLastMonth;

  /// No description provided for @timeNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get timeNow;

  /// No description provided for @timeJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get timeJustNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes ago'**
  String timeMinutesAgo(int minutes);

  /// No description provided for @timeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours ago'**
  String timeHoursAgo(int hours);

  /// No description provided for @placeholderSearch.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get placeholderSearch;

  /// No description provided for @placeholderEnterText.
  ///
  /// In en, this message translates to:
  /// **'Enter text'**
  String get placeholderEnterText;

  /// No description provided for @placeholderEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get placeholderEnterEmail;

  /// No description provided for @placeholderEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get placeholderEnterPassword;

  /// No description provided for @placeholderSelectOption.
  ///
  /// In en, this message translates to:
  /// **'Select an option'**
  String get placeholderSelectOption;

  /// Greeting with user name
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}!'**
  String greetingHello(String name);

  /// Welcome message with user name
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}!'**
  String greetingWelcome(String name);

  /// Count of items with pluralization
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No items} =1{1 item} other{{count} items}}'**
  String itemsCount(int count);

  /// Count of search results with pluralization
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No results} =1{1 result} other{{count} results}}'**
  String resultsCount(int count);

  /// Days ago with pluralization
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{today} =1{yesterday} other{{days} days ago}}'**
  String daysAgo(int days);

  /// Formatted date
  ///
  /// In en, this message translates to:
  /// **'Updated on {date}'**
  String formattedDate(DateTime date);

  /// Formatted time
  ///
  /// In en, this message translates to:
  /// **'at {time}'**
  String formattedTime(DateTime time);

  /// Formatted date and time
  ///
  /// In en, this message translates to:
  /// **'{date} at {time}'**
  String formattedDateTime(DateTime date, DateTime time);

  /// Formatted price with currency
  ///
  /// In en, this message translates to:
  /// **'{price}'**
  String formattedPrice(double price);

  /// Formatted percentage
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String formattedPercentage(int percent);

  /// No description provided for @networkOnline.
  ///
  /// In en, this message translates to:
  /// **'Back online'**
  String get networkOnline;

  /// No description provided for @networkOffline.
  ///
  /// In en, this message translates to:
  /// **'No connection'**
  String get networkOffline;

  /// No description provided for @networkReconnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting...'**
  String get networkReconnecting;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Appearance section title
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// Theme setting label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// System theme option (follows device setting)
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// Account section title
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// Delete account button text
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settingsDeleteAccount;

  /// Delete account warning description
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account and all associated data. This action cannot be undone.'**
  String get settingsDeleteAccountDescription;

  /// Delete account confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Account?'**
  String get settingsDeleteAccountConfirmTitle;

  /// Delete account confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This will permanently delete all your data and cannot be undone.'**
  String get settingsDeleteAccountConfirmMessage;

  /// Second delete account confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Final Confirmation'**
  String get settingsDeleteAccountConfirmSecondTitle;

  /// Second delete account confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'This is your last chance to cancel. Deleting your account will permanently remove all your data. Are you absolutely sure?'**
  String get settingsDeleteAccountConfirmSecondMessage;

  /// Success message after account deletion
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get settingsDeleteAccountSuccess;

  /// Error message when account deletion fails
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account. Please try again.'**
  String get settingsDeleteAccountError;

  /// Loading message during account deletion
  ///
  /// In en, this message translates to:
  /// **'Deleting account...'**
  String get settingsDeleteAccountInProgress;

  /// Label for display name field in profile
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get profileDisplayName;

  /// Hint text for display name input
  ///
  /// In en, this message translates to:
  /// **'Enter your display name'**
  String get profileDisplayNameHint;

  /// Title for avatar source selection bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Select Photo Source'**
  String get profileSelectAvatarSource;

  /// Option to select photo from gallery
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get profileSelectFromGallery;

  /// Option to take a new photo
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get profileTakePhoto;

  /// Success message when avatar is updated
  ///
  /// In en, this message translates to:
  /// **'Avatar updated successfully'**
  String get profileAvatarUpdated;

  /// Description text for profile card in settings
  ///
  /// In en, this message translates to:
  /// **'Manage your profile and avatar'**
  String get profileManageDescription;

  /// Label for member since date in profile
  ///
  /// In en, this message translates to:
  /// **'Member since'**
  String get profileMemberSince;

  /// Error message when image picker permission is denied
  ///
  /// In en, this message translates to:
  /// **'Permission denied. Please grant camera/photo access in settings.'**
  String get errorImagePickerPermission;

  /// Error message when selected image file cannot be found
  ///
  /// In en, this message translates to:
  /// **'Selected image file not found. Please try again.'**
  String get errorImagePickerFileNotFound;

  /// Generic error message for image picker failures
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image. Please try again.'**
  String get errorImagePickerGeneric;

  /// Error message for platform-specific errors
  ///
  /// In en, this message translates to:
  /// **'Platform error occurred. Please try again.'**
  String get errorPlatformError;

  /// Bottom navigation label for home tab
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom navigation label for generate tab
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get navGenerate;

  /// Bottom navigation label for profile tab
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// Title for generate page
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generateTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
