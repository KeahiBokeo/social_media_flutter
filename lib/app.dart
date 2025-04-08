import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_flutter/features/auth/data/firebase_auth_repo.dart';
import 'package:social_media_flutter/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media_flutter/features/auth/presentation/cubits/auth_states.dart';
import 'package:social_media_flutter/features/auth/presentation/pages/auth_page.dart';
import 'package:social_media_flutter/features/home/presentation/pages/home_page.dart';
import 'package:social_media_flutter/features/profile/data/firebase_profile_repo.dart';
import 'package:social_media_flutter/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:social_media_flutter/features/storage/data/firebase_storage_repo.dart';
import 'package:social_media_flutter/themes/light_mode.dart';

/*

APP - Root Level
Repositories: for the database
  - firebase

Bloc Providers: for state management
  - auth
  - profile
  - post
  - search
  - theme

Check Auth State
  - unauthenticated -> auth page(login/register)
  - authenticated -> home page

*/

class MyApp extends StatelessWidget {
  //auth repo
  final firebaseAuthRepo = FirebaseAuthRepo();
  //profile repo
  final firebaseProfileRepo = FirebaseProfileRepo();
  //storage repo
  final firebaseStorageRepo = FirebaseStorageRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create:
              (context) => AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),

        BlocProvider<ProfileCubit>(
          create:
              (context) => ProfileCubit(
                profileRepo: firebaseProfileRepo,
                storageRepo: firebaseStorageRepo,
              ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {
            print(authState);
            //unauthenticated -> auth page
            if (authState is Unauthenticated) {
              return const AuthPage();
            }

            //authenticated -> homepage
            if (authState is Authenticated) {
              return const HomePage();
            }
            //loading
            else {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
          listener: (context, authState) {
            if (authState is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(authState.message)));
            }
          },
        ),
      ),
    );
  }
}
