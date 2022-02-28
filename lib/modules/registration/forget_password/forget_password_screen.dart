import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/registration/forget_password/forget_password_cubit.dart';
import 'package:shop_app/modules/registration/forget_password/forget_password_states.dart';
import 'package:shop_app/modules/registration/login/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constanse.dart';
import 'package:shop_app/shared/styles/colors.dart';
import 'package:timer_button/timer_button.dart';

class ForgetPasswordScreen extends StatelessWidget {

  var formKeyEmailVerification = GlobalKey<FormState>();
  var formKeyVerifyCode = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController verificationCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ForgetPasswordCubit(),
      child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordStates>(
        listener: (context, state) {
          if(state is ResetPasswordSuccessForgetPasswordState){
            if(state.sendEmailVerificationResponse.status){
              navigateToAndFinish(context, LoginScreen());
            }
          }
        },
        builder: (context, state) {
          ForgetPasswordCubit forgetPasswordCubit = ForgetPasswordCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Forget Password'),
              toolbarHeight: 150.0,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Send code to verify your email'),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Form(
                      key: formKeyEmailVerification,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 300.0,
                            child: defaultFormField(
                              controller: emailController,
                              prefix: Icons.email_rounded,
                              type: TextInputType.emailAddress,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'Email address required';
                                }
                                return null;
                              },
                              label: 'Email',
                              textSize: 14.0
                            ),
                          ),
                          SizedBox(
                            height: 60.0,
                            child: OutlinedButton(
                              child: forgetPasswordCubit.time > 0 ? Text(forgetPasswordCubit.time.toString()) : const Text('Send') ,
                              onPressed: () {
                                if(forgetPasswordCubit.time == 0){
                                  if(formKeyEmailVerification.currentState!.validate()){
                                    forgetPasswordCubit.startTimer();
                                    forgetPasswordCubit.sendEmailVerificationCode(email: emailController.text);
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Form(
                      key: formKeyVerifyCode,
                      child: Column(
                        children: [
                          defaultFormField(
                            controller: verificationCodeController,
                            prefix: Icons.email_rounded,
                            type: TextInputType.number,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Verification code required';
                              }
                              return null;
                            },
                            label: 'Code',
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          defaultFormField(
                            controller: passwordController,
                            prefix: Icons.remove_red_eye,
                            type: TextInputType.visiblePassword,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Password required';
                              }
                              return null;
                            },
                            label: 'Password',
                          ),
                        ],
                      )
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultButton(
                        onPressed: (){
                          if(formKeyVerifyCode.currentState!.validate()){
                            if(verificationCodeController.text.length == verificationCode){
                              forgetPasswordCubit.resetPassword(
                                  code: verificationCodeController.text,
                                  email: emailController.text,
                                  password: passwordController.text);
                            }else{
                              showToast(message: 'Verification code should be 4 numbers', toastStates: ToastStates.WARNING, longTime: true);
                            }
                          }
                        },
                        label: 'Verify Code',
                        isButtonLoading: state is ResetPasswordLoadingForgetPasswordState
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
