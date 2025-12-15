class SignupFormState {
  final String email;
  final String password;
  final String id;
  final String role;
  final String? emailError;
  final String? passwordError;
  final String? idError;
  final String? roleError;

  const SignupFormState({
    this.email = '',
    this.password = '',
    this.emailError,
    this.passwordError,
    this.id='',
    this.role='',
    this.idError,
    this.roleError
  });

  bool get isValid => emailError == null && passwordError == null && idError==null && roleError==null;

  SignupFormState copyWith({
    String? email,
    String? password,
    String? id,
    String? role,
    String? emailError,
    String? passwordError,
    String? idError,
    String? roleError
  }) {
    return SignupFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      id: id?? this.id,
      role: role?? this.role,
      emailError: emailError,
      passwordError: passwordError,
      idError: idError,
      roleError: roleError

    );
  }
}
