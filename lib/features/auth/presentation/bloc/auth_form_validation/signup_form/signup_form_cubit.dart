import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup_form_state.dart';
class SignupFormCubit extends Cubit<SignupFormState> {
  SignupFormCubit() : super(const SignupFormState());
  void nameChanged(String value) {
  emit(state.copyWith(
    name: value,
    nameError: value.isEmpty
        ? 'Name is required'
        : value.length < 3
            ? 'Name must be at least 3 characters'
            : null,
  ));
}


  void emailChanged(String value) {
    emit(state.copyWith(
      email: value,
      emailError: value.isEmpty
          ? 'Email is required'
          : !_isValidEmail(value)
              ? 'Enter a valid email'
              : null,
    ));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(
      password: value,
      passwordError: value.isEmpty
          ? 'Password is required'
          : value.length < 6
              ? 'Password must be at least 6 characters'
              : null,
    ));
  }

  void idChanged(String value) {
    emit(state.copyWith(
      id: value,
      idError: value.isEmpty
          ? 'Employee ID is required'
          : value.length < 3
              ? 'Employee ID must be at least 3 characters'
              : null,
    ));
  }

  void roleChanged(String value) {
    emit(state.copyWith(
      role: value,
      roleError: value.isEmpty ? 'Role is required' : null,
    ));
  }

  void departmentChanged(String value) {
  emit(state.copyWith(
    department: value,
    departmentError:
        value.isEmpty ? 'Department is required' : null,
  ));
}


  void submit() {
    emailChanged(state.email);
    passwordChanged(state.password);
    idChanged(state.id);
    roleChanged(state.role);
    departmentChanged(state.department);
  }
void reset() {
    emit(const SignupFormState());
  }
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
