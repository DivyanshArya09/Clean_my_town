import 'dart:convert';

import 'package:app/core/errors/failures.dart';
import 'package:app/core/helpers/user_helpers/user_helper.dart';
import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthDataSources {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult.user;

        return user;
      }
    } catch (error) {
      print(error);
      return null;
    }
    return null;
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<Either<Failure, void>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      firebase_auth.UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user != null) {
        print("========================> ${user.uid}");
        // return const Right(null);
      }

      return const Right(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return const Left(
            ServerFailure(message: 'No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        return const Left(
            ServerFailure(message: 'Wrong password provided for that user.'));
      } else if (e.code == 'invalid-email') {
        return const Left(
            ServerFailure(message: 'The email address is badly formatted.'));
      } else if (e.code == 'email-already-in-use') {
        const Left(
            ServerFailure(message: 'The email address is badly formatted.'));
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
    return const Left(ServerFailure(message: 'Something went wrong'));
  }

  Future<Either<Failure, String>> signInEmailAndPassword(
      String email, String password) async {
    try {
      firebase_auth.UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user != null) {
        print("========================> ${user.uid}");
        // return Right(email);
      }
      await SharedPreferencesHelper.saveUid(email);
      return Right(email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return const Left(
            ServerFailure(message: 'No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        return const Left(
            ServerFailure(message: 'Wrong password provided for that user.'));
      } else if (e.code == 'invalid-email') {
        return const Left(
            ServerFailure(message: 'The email address is badly formatted.'));
      } else if (e.code == 'email-already-in-use') {
        const Left(
            ServerFailure(message: 'The email address is badly formatted.'));
      } else {
        return Left(ServerFailure(message: e.toString()));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
    return Right(email);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await googleSignIn.signOut();
  }
}
