import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup_form_state.dart';

class SignupFormCubit extends Cubit<SignupFormState> {
  SignupFormCubit() : super(const SignupFormState());

  // ---------------- EMAIL ----------------
  void emailChanged(String value) {
    String? error;

    if (value.isEmpty) {
      error = 'Email is required';
    } else if (!_isValidEmail(value)) {
      error = 'Enter a valid email';
    }

    emit(state.copyWith(
      email: value,
      emailError: error,
    ));
  }

  // ---------------- PASSWORD ----------------
  void passwordChanged(String value) {
    String? error;

    if (value.isEmpty) {
      error = 'Password is required';
    } else if (value.length < 6) {
      error = 'Password must be at least 6 characters';
    }

    emit(state.copyWith(
      password: value,
      passwordError: error,
    ));
  }

  // ---------------- JOB ID ----------------
  void idChanged(String value) {
    String? error;

    if (value.isEmpty) {
      error = 'Job ID is required';
    } else if (value.length < 3) {
      error = 'Job ID must be at least 3 characters';
    }

    emit(state.copyWith(
      id: value,
      idError: error,
    ));
  }

  // ---------------- ROLE ----------------
  void roleChanged(String value) {
    String? error;

    if (value.isEmpty) {
      error = 'Role is required';
    }

    emit(state.copyWith(
      role: value,
      roleError: error,
    ));
  }

  // ---------------- SUBMIT ----------------
  void submit() {
    emailChanged(state.email);
    passwordChanged(state.password);
    idChanged(state.id);
    roleChanged(state.role);
  }

  // ---------------- HELPERS ----------------
  bool _isValidEmail(String email) {
    return RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email);
  }
}
