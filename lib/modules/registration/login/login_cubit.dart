import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/user/user_response.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(InitLoginState());

  static LoginCubit get(BuildContext context) => BlocProvider.of(context);

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoadingLoginState());
    DioHelper.postData(
        url: LOGIN, data: {'email': email, 'password': password}
    ).then((value) => {
      debugPrint('LoginCubit (userLogin then)${value.data['status'].toString()}'),
      emit(SuccessLoginState(UserResponse.fromJson(value.data)))}
    ).catchError((error) => {
      debugPrint('LoginCubit (userLogin catchError then)${error.toString()}'),
      emit(ErrorLoginState(error.toString()))}
    );
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility(){
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ChangePasswordVisibilityLoginState());
  }

}
