import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Events
abstract class AuthEvent {}

class SignUpRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  SignUpRequested({required this.name, required this.email, required this.password});
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;
  SignInRequested({required this.email, required this.password});
}

class SignOutRequested extends AuthEvent {}

class AuthStatusChecked extends AuthEvent {}

class PasswordResetRequested extends AuthEvent {
  final String email;
  PasswordResetRequested({required this.email});
}

// States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;
  AuthSuccess({required this.user});
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure({required this.message});
}

class AuthSignedOut extends AuthState {}

class PasswordResetSent extends AuthState {}

// BLoC Implementation
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<AuthStatusChecked>(_onAuthStatusChecked);
    on<PasswordResetRequested>(_onPasswordResetRequested);
  }

  Future<void> _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      await userCredential.user?.updateDisplayName(event.name);
      await userCredential.user?.sendEmailVerification();
      emit(AuthSuccess(user: userCredential.user!));
    } catch (e) {
      emit(AuthFailure(message: _getFirebaseErrorMessage(e)));
    }
  }

  Future<void> _onSignInRequested(SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthSuccess(user: userCredential.user!));
    } catch (e) {
      emit(AuthFailure(message: _getFirebaseErrorMessage(e)));
    }
  }

  Future<void> _onSignOutRequested(SignOutRequested event, Emitter<AuthState> emit) async {
    try {
      // ✅ Properly sign out from Firebase
      await _firebaseAuth.signOut();
      emit(AuthSignedOut());
    } catch (e) {
      emit(AuthFailure(message: 'Sign-out failed: ${e.toString()}'));
    }
  }

  Future<void> _onAuthStatusChecked(AuthStatusChecked event, Emitter<AuthState> emit) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      emit(AuthSuccess(user: user));
    } else {
      emit(AuthSignedOut());
    }
  }

  Future<void> _onPasswordResetRequested(PasswordResetRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: event.email);
      emit(PasswordResetSent());
    } catch (e) {
      emit(AuthFailure(message: _getFirebaseErrorMessage(e)));
    }
  }

  String _getFirebaseErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'weak-password':
          return 'The password provided is too weak.';
        case 'email-already-in-use':
          return 'An account already exists with this email.';
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        case 'invalid-email':
          return 'The email address is not valid.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        case 'user-disabled':
          return 'This user account has been disabled.';
        case 'operation-not-allowed':
          return 'Email/password accounts are not enabled.';
        default:
          return error.message ?? 'Authentication failed. Please try again.';
      }
    }
    return error.toString();
  }
}
