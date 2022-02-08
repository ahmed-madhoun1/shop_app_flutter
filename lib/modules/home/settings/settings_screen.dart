import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/home_layout/home_cubit.dart';
import 'package:shop_app/layout/home_layout/home_states.dart';
import 'package:shop_app/main.dart';
import 'package:shop_app/models/user/user_response.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/colors.dart';

class SettingsScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if(state is UserLogoutSuccessHomeState){
          if(state.isTokenRemoved! && state.userLogoutResponse!.status!){
            navigateToAndFinish(context, const MainApp());
            showToast(message: state.userLogoutResponse!.message!, toastStates: ToastStates.SUCCESS, longTime: false);
          }else{
            showToast(message: state.userLogoutResponse!.message!, toastStates: ToastStates.ERROR, longTime: true);
          }
        }
      },
      builder: (context, state) {
        HomeCubit homeCubit = HomeCubit.get(context);
        if(homeCubit.userResponse != null){
          User user = homeCubit.userResponse!.user!;
          usernameController.text = user.name;
          emailController.text = user.email;
          phoneController.text = user.phone;
        }
        return homeCubit.userResponse != null ? SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: IgnorePointer(
              ignoring: state is UserLogoutLoadingHomeState,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    defaultFormField(
                        controller: usernameController,
                        type: TextInputType.name,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Username should not be empty!';
                          }
                        },
                        label: 'Username',
                        prefix: Icons.person),
                    const SizedBox(
                      height: 10.0,
                    ),
                    defaultFormField(
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Email should not be empty!';
                          }
                        },
                        label: 'Email',
                        prefix: Icons.email),
                    const SizedBox(
                      height: 10.0,
                    ),
                    defaultFormField(
                        controller: phoneController,
                        type: TextInputType.phone,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Phone should not be empty!';
                          }
                        },
                        label: 'Phone',
                        prefix: Icons.phone),
                    const SizedBox(height: 20.0,),
                    defaultButton(
                        onPressed: (){
                          homeCubit.userLogout(context);
                        },
                        label: 'Logout',
                        isButtonLoading: state is UserLogoutLoadingHomeState
                    ),
                    const SizedBox(height: 20.0,),
                    defaultButton(
                        onPressed: () {
                          updateProfile(context);
                          },
                        label: 'Update',
                        isButtonLoading: state is UpdateUserProfileLoadingHomeState
                    ),
                  ],
                ),
              ),
            ),
          ),
        ) : const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void updateProfile(context){
    if(formKey.currentState!.validate()){
      HomeCubit.get(context).updateUserProfile(
        name: usernameController.text,
        email: emailController.text,
        phone: phoneController.text,
      );
    }
  }
}
