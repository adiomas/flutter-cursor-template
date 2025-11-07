import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Supabase service provider
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService(ref.watch(supabaseClientProvider));
});

class SupabaseService {
  final SupabaseClient client;

  SupabaseService(this.client);

  // Auth helpers
  User? get currentUser => client.auth.currentUser;
  String? get currentUserId => client.auth.currentUser?.id;
  bool get isAuthenticated => client.auth.currentUser != null;

  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  // Sign in with email and password
  Future<AuthResponse> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign up with email and password
  Future<AuthResponse> signUpWithEmailPassword({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: metadata,
    );
  }

  // Sign out
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await client.auth.resetPasswordForEmail(email);
  }

  // Resend email confirmation
  Future<void> resendEmailConfirmation(String email) async {
    await client.auth.resend(
      type: OtpType.signup,
      email: email,
    );
  }

  // Update user metadata
  Future<UserResponse> updateUserMetadata(Map<String, dynamic> data) async {
    return await client.auth.updateUser(
      UserAttributes(data: data),
    );
  }

  // Delete user account
  // Note: Requires a database RPC function 'delete_user_account' to be set up
  // The RPC function should handle account deletion with proper cleanup
  Future<void> deleteAccount() async {
    final userId = currentUser?.id;
    if (userId == null) {
      throw Exception('No authenticated user');
    }

    // Call RPC function to delete account
    // This requires a database function to be created:
    // CREATE OR REPLACE FUNCTION delete_user_account()
    // RETURNS void AS $$
    // BEGIN
    //   DELETE FROM auth.users WHERE id = auth.uid();
    // END;
    // $$ LANGUAGE plpgsql SECURITY DEFINER;
    await client.rpc('delete_user_account');
  }

  // OAuth: Sign in with Google
  // Requires Google Client IDs to be configured in Supabase dashboard
  // and passed as parameters (webClientId is required, iosClientId is optional)
  Future<AuthResponse> signInWithGoogle({
    required String webClientId,
    String? iosClientId,
  }) async {
    // Initialize GoogleSignIn with client IDs
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );

    // Sign in with Google
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google sign in was cancelled');
    }

    // Get authentication tokens
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final String? accessToken = googleAuth.accessToken;
    final String? idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw Exception('No Access Token found');
    }
    if (idToken == null) {
      throw Exception('No ID Token found');
    }

    // Sign in with Supabase using the ID token
    return await client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  // OAuth: Sign in with Apple
  // Requires Apple Sign In to be configured in Supabase dashboard
  Future<AuthResponse> signInWithApple() async {
    // Generate a random nonce
    final rawNonce = client.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    // Request Apple ID credential
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException(
        'Could not find ID Token from generated credential.',
      );
    }

    // Sign in with Supabase using the ID token
    return await client.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
  }
}
