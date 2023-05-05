import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class MockUser extends Mock implements User {}

void main() async {
  // Initialize Firebase App
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize Firebase Auth instance and other dependencies
  final FirebaseAuth auth = FirebaseAuth.instance;

  group('Authentication Tests', () {
    test('Sign up with email and password', () async {
      // Mock FirebaseAuth.instance.createUserWithEmailAndPassword method
      final MockUserCredential mockUserCredential = MockUserCredential();
      when(auth.createUserWithEmailAndPassword(
              email: 'test@example.com', password: 'password123'))
          .thenAnswer((_) => Future.value(mockUserCredential));

      // Define the sign up function
      Future<UserCredential?> signUpWithEmailPassword(
          String email, String password) async {
        try {
          final result = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);
          return result;
        } on FirebaseAuthException catch (e) {
          print('Failed to create user: ${e.message}');
          return null;
        } catch (e) {
          print(e);
          return null;
        }
      }

      // Call the sign up function
      final result =
          await signUpWithEmailPassword('test@example.com', 'password123');

      // Verify that the createUserWithEmailAndPassword method was called exactly once
      verify(auth.createUserWithEmailAndPassword(
              email: 'test@example.com', password: 'password123'))
          .called(1);

      // Verify that the result is an instance of UserCredential
      expect(result, isA<UserCredential>());
    });
  });
}

class MockUserCredential extends Mock implements UserCredential {}
