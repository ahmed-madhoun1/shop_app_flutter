import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/user/send_email_verification_response.dart';
import 'package:shop_app/modules/registration/forget_password/forget_password_states.dart';
import 'package:shop_app/modules/registration/login/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constanse.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordStates> {
  ForgetPasswordCubit() : super(InitForgetPasswordState());

  static ForgetPasswordCubit get(BuildContext context) => BlocProvider.of(context);

  SendEmailVerificationResponse? sendEmailVerificationResponse;
  late int time = 0;

  void sendEmailVerificationCode({required String email}){
    emit(SendEmailVerificationLoadingForgetPasswordState());
    DioHelper.postData(
        url: VERIFY_EMAIL, data: {'email': email}
    ).then((value) => {
      sendEmailVerificationResponse = SendEmailVerificationResponse.fromJson(value.data),
      debugPrint('ForgetPasswordCubit (sendEmailVerificationCode then) => ${sendEmailVerificationResponse!.data!.email.toString()}'),
      emit(SendEmailVerificationSuccessForgetPasswordState(sendEmailVerificationResponse!)),
    }).catchError((error){
      debugPrint('ForgetPasswordCubit (sendEmailVerificationCode catchError) => ${error.toString()}');
      emit(SendEmailVerificationErrorForgetPasswordState(error.toString()));
    });
  }
  
  void resetPassword({required String email, required String code, required String password}){
    emit(ResetPasswordLoadingForgetPasswordState());
    DioHelper.postData(
        url: RESET_PASSWORD,
        data: {'email':email, 'code': code, "password": password}
    ).then((value) => {
      if(!sendEmailVerificationResponse!.status){
          showToast(message: sendEmailVerificationResponse!.message.toString(), toastStates: ToastStates.ERROR, longTime: true),
          emit(ResetPasswordErrorForgetPasswordState('Something went wrong')),
    }else{
        sendEmailVerificationResponse = SendEmailVerificationResponse.fromJson(value.data),
        debugPrint('ForgetPasswordCubit (resetPassword then) => ${sendEmailVerificationResponse!.data!.email.toString()}'),
        emit(ResetPasswordSuccessForgetPasswordState(sendEmailVerificationResponse!)),
      },
    }).catchError((error){
      debugPrint('ForgetPasswordCubit (resetPassword catchError) => ${error.toString()}');
      emit(ResetPasswordErrorForgetPasswordState(error.toString()));
    });
  }

  void startTimer(){
    time = sendCodeAgainTime;
    Timer.periodic(const Duration(seconds: 1), (timer){
      if(time > 0){
        time--;
      }else{
        timer.cancel();
      }
      emit(TimerForgetPasswordState());
    });
  }

}
