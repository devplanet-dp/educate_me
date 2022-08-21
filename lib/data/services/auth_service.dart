import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../../core/utils/app_controller.dart';
import '../../locator.dart';
import '../firebase_result.dart';
import '../user.dart';
import 'firestore_service.dart';
import 'local_storage_service.dart';

class AuthenticationService {
  final localStorage = locator<LocalStorageService>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _fireService = locator<FirestoreService>();
  final AppController controller = Get.find<AppController>();

  bool isUserLogged() => localStorage.isUserLogged;

  Future saveUserToken(String token) async {}

  Future<FirebaseResult> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await populateCurrentUser(authResult.user!.uid);
      return FirebaseResult(data: authResult.user);
    } on FirebaseAuthException catch (e) {
      var msg = 'Sorry! Please try again later';
      if (e.code == 'user-not-found') {
        msg = 'No user found for the email.';
      } else if (e.code == 'wrong-password') {
        msg = 'Wrong password provided';
      }
      return FirebaseResult.error(errorMessage: msg);
    }
  }

  Future<FirebaseResult> sendEmailVerification(email, password) async {
    try {
      var user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user.user?.emailVerified ?? false) {
        await user.user?.sendEmailVerification();
      }

      return FirebaseResult(data: true);
    } catch (e) {
      return FirebaseResult.error(errorMessage: e.toString());
    }
  }

  Future<FirebaseResult> resendEmailVerification() async {
    try {
      User? user = _firebaseAuth.currentUser;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }

      return FirebaseResult(data: true);
    } catch (e) {
      return FirebaseResult.error(errorMessage: e.toString());
    }
  }

  Future<FirebaseResult> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return FirebaseResult(data: true);
    } catch (e) {
      return FirebaseResult.error(errorMessage: e.toString());
    }
  }

  Future<FirebaseResult> signUpUserWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return await createNewUserForEmail(UserModel(
          name: email,
          email: email,
          userId: authResult.user!.uid,
          createdDate: Timestamp.now(),
          role: null));
    } on FirebaseAuthException catch (e) {
      var msg = 'Sorry! Please try again later';
      if (e.code == 'weak-password') {
        msg = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        msg = 'The account already exists for that email.';
      }
      return FirebaseResult.error(errorMessage: msg);
    }
  }

  Future<FirebaseResult> sendEmailLink() async {
    try {
      User? user = _firebaseAuth.currentUser;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
      return FirebaseResult(data: true);
    } on FirebaseAuthException catch (e) {
      return FirebaseResult.error(errorMessage: e.message ?? '');
    }
  }

  Future<bool> isEmailVerified() async {
    try {
      await _firebaseAuth.currentUser?.reload();
      return _firebaseAuth.currentUser?.emailVerified ?? false;
    } on FirebaseAuthException catch (e) {
      return false;
    }
  }

  Future<FirebaseResult> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      var result = await _firebaseAuth.signInWithCredential(credential);
      if (result.user != null) {
        var exist = await _fireService.isUserExists(result.user?.uid ?? '');
        if (exist) {
          return populateCurrentUser(result.user!.uid);
        }
        return await createNewUserForEmail(UserModel(
            name: result.user!.email!,
            email: result.user!.email!,
            userId: result.user!.uid,
            createdDate: Timestamp.now(),
            role: null));
      } else {
        return FirebaseResult.error(errorMessage: 'error_common'.tr);
      }
    } catch (e) {
      return FirebaseResult.error(errorMessage: e.toString());
    }
  }

  Future<FirebaseResult> signInWithApple(
      {List<Scope> scopes = const []}) async {
    // 1. perform the sign-in request
    final response = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    // 2. check the result
    switch (response.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = response.credential!;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode!),
        );
        // Once signed in, return the UserCredential
        var result = await _firebaseAuth.signInWithCredential(credential);
        if (result.user != null) {
          var exist = await _fireService.isUserExists(result.user?.uid ?? '');
          if (exist) {
            return populateCurrentUser(result.user!.uid);
          }
          return await createNewUserForEmail(UserModel(
              name: result.user!.email!,
              email: result.user!.email!,
              userId: result.user!.uid,
              createdDate: Timestamp.now(),
              role: null));
        } else {
          return FirebaseResult.error(errorMessage: 'error_common'.tr);
        }
      case AuthorizationStatus.error:
        return FirebaseResult.error(errorMessage: response.error.toString());

      case AuthorizationStatus.cancelled:
        return FirebaseResult.error(errorMessage: 'Sign in aborted by user');
      default:
        return FirebaseResult.error(errorMessage: 'error_common'.tr);
    }
  }

  Future<FirebaseResult> isUserLoggedIn() async {
    try {
      var user = _firebaseAuth.currentUser;
      await populateCurrentUser(user!.uid);
      return FirebaseResult(data: controller.appUser);
    } catch (e) {
      return FirebaseResult.error(errorMessage: e.toString());
    }
  }

  Future<FirebaseResult> populateCurrentUser(String uid) async {
    var result = await _fireService.getUser(uid);
    if (!result.hasError) {
      controller.appUser = result.data;
      return FirebaseResult(data: result);
    } else {
      return FirebaseResult(data: null);
    }
  }

  Future<FirebaseResult> createNewUserForEmail(UserModel userModel) async {
    var result = await _fireService.createUser(userModel);
    if (result is bool) {
      controller.appUser = userModel;
      return FirebaseResult(data: userModel);
    } else {
      return FirebaseResult.error(errorMessage: 'error_common'.tr);
    }
  }

  Future signOut() async {
    localStorage.userToken = '';
    controller.appUser = null;
    await _firebaseAuth.signOut();
    // Get.offAll(() => const SignInView());
  }

  Future deleteUserProfile() async {
    await _fireService.deleteCurrentUser(controller.appUser?.userId ?? '');
    localStorage.userToken = '';
    controller.appUser = null;
    await _firebaseAuth.currentUser?.delete();
    // Get.offAll(() => const SignInView());
  }
}
