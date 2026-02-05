import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manage_x/core/di/injection.dart';
import 'package:manage_x/core/utils/notification_service.dart';
import 'package:manage_x/features/admin/presentation/bloc/admin_event.dart';
import 'package:manage_x/features/admin/presentation/bloc/project/project_bloc.dart';
import 'package:manage_x/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:manage_x/features/auth/presentation/bloc/auth_form_validation/login_form/login_form_cubit.dart';
import 'package:manage_x/features/auth/presentation/bloc/auth_form_validation/signup_form/signup_form_cubit.dart';
import 'package:manage_x/features/auth/presentation/bloc/password_visibility_bloc/password_visibility_cubit.dart';
import 'package:manage_x/features/auth/presentation/pages/login.dart';
import 'package:manage_x/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:manage_x/features/lead/presentation/bloc/lead_project_bloc.dart';
import 'package:manage_x/features/user/presentation/bloc/user_profile_bloc.dart';
import 'package:manage_x/features/user/presentation/bloc/user_project_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().initialize();
  await initDependency();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PasswordVisibilityCubit>(
          create: (_) => sl<PasswordVisibilityCubit>(),
        ),
        BlocProvider<LoginFormCubit>(create: (_) => sl<LoginFormCubit>()),
        BlocProvider<SignupFormCubit>(create: (_) => SignupFormCubit()),
        BlocProvider(create: (_)=> sl<AuthBloc>()),
        BlocProvider(create: (_)=> sl<AdminBloc>()..add(GetPendingUsersEvent())),
        BlocProvider(create: (_)=> sl<ProjectBloc>()),
        BlocProvider(create: (_)=> sl<ProfileBloc>()),
        BlocProvider(create: (_)=>sl<LeadProjectBloc>()),
        BlocProvider(create: (_)=> sl<UserProjectBloc>())
      ],
      child: MaterialApp(
        theme: ThemeData(textTheme: GoogleFonts.interTextTheme()),
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}
