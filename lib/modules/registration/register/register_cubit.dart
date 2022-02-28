import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/user/user_response.dart';
import 'package:shop_app/modules/registration/register/register_states.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(InitRegisterState());

  static RegisterCubit get(BuildContext context) => BlocProvider.of(context);

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility(){
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ChangePasswordVisibilityRegisterState());
  }

  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String image,
  }) {
    emit(LoadingRegisterState());
    DioHelper.postData(
        url: REGISTER, data:
    {
      "email": email,
      "password": password,
      "name": name,
      "phone": phone,
      "image": image
    }).then((value) => {
      debugPrint('RegisterCubit (userRegister then)${value.data['status'].toString()}'),
      emit(SuccessRegisterState(UserResponse.fromJson(value.data)))}
    ).catchError((error) => {
      debugPrint('RegisterCubit (userRegister catchError then)${error.toString()}'),
      emit(ErrorRegisterState(error.toString()))}
    );
  }

}
