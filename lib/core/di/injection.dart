import 'package:get_it/get_it.dart';
import 'package:manage_x/features/auth/presentation/bloc/auth_form_validation/login_form/login_form_cubit.dart';
import 'package:manage_x/features/auth/presentation/bloc/auth_form_validation/signup_form/signup_form_cubit.dart';
import 'package:manage_x/features/auth/presentation/bloc/password_visibility_bloc/password_visibility_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependency() async {
  sl.registerFactory(() => PasswordVisibilityCubit());
  sl.registerFactory(() => LoginFormCubit());
  sl.registerFactory(() => SignupFormCubit());
}
