import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/registration/login/login_screen.dart';
import 'package:shop_app/modules/registration/on_boarding/on_boarding_screen.dart';
import 'package:shop_app/shared/components/constanse.dart';

import 'registration_cubit.dart';
import 'registration_states.dart';

class RegistrationLayout extends StatelessWidget {
  const RegistrationLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegistrationCubit(),
      child: BlocConsumer<RegistrationCubit, RegistrationStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              body:  onBoarding != null && userToken == null
                  ? LoginScreen()
                  : OnBoardingScreen(),
            );
          }),
    );
  }
}
