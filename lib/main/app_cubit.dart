import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_state.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitAppState());

  static AppCubit get(context) => BlocProvider.of(context);

  late Widget screen;

  /// Show splash screen and delay for 5 sec and then show home screen
  void delayedSplashScreen({
    required BuildContext context,
    required Widget splashScreen,
    required Widget homeScreen
  }){
    screen = splashScreen;
    emit(SetSplashScreenAppState());
    Future.delayed(const Duration(seconds: 5)).then((value) => {
      screen = homeScreen,
      emit(SetHomeScreenAppState()),
    });
  }
  
}
