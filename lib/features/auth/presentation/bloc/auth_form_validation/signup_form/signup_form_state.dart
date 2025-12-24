class SignupFormState {
  final String name;
  final String email;
  final String password;
  final String id;
  final String role;
  final String department;

final String? nameError;
  final String? emailError;
  final String? passwordError;
  final String? idError;
  final String? roleError;
  final String? departmentError;

  const SignupFormState({
    this.name='',
    this.email = '',
    this.password = '',
    this.id = '',
    this.role = '',
    this.department = '',
    this.emailError,
    this.nameError,
    this.passwordError,
    this.idError,
    this.roleError,
    this.departmentError,
  });

  bool get isValid =>
  nameError ==null&&
      emailError == null &&
      passwordError == null &&
      idError == null &&
      roleError == null &&
      departmentError == null;

  SignupFormState copyWith({
    String?name,
    String? email,
    String? password,
    String? id,
    String? role,
    String? department,
    String? nameError,
    String? emailError,
    String? passwordError,
    String? idError,
    String? roleError,
    String? departmentError,
  }) {
    return SignupFormState(
      name: name??this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      id: id ?? this.id,
      role: role ?? this.role,
      department: department ?? this.department,
      nameError: nameError,
      emailError: emailError,
      passwordError: passwordError,
      idError: idError,
      roleError: roleError,
      departmentError: departmentError,
    );
  }
}
