// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/home_layout/home_layout.dart';
import 'package:shop_app/modules/registration/forget_password/forget_password_screen.dart';
import 'package:shop_app/modules/registration/register/register_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constanse.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

import 'login_cubit.dart';
import 'login_states.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is SuccessLoginState) {
            if (state.userResponse.status) {
              debugPrint('***** ${state.userResponse.status} *****');
              if (state.userResponse.user?.token != null) {
                CacheHelper.setData(key: 'token', value: state.userResponse.user?.token)
                .then((value) => {
                  userToken = state.userResponse.user!.token,
                  showToast(message: state.userResponse.message!, toastStates: ToastStates.SUCCESS, longTime: false),
                  navigateToAndFinish(context, const HomeLayout()),
                  debugPrint('***** TOKEN SAVED *****'),
                });
              } else {
                debugPrint(
                    '***** state.userResponse.data?.token == null *****');
              }
            } else {
              showToast(
                  message: state.userResponse.message!,
                  toastStates: ToastStates.ERROR,
                  longTime: true);
            }
          }
          if (state is ErrorLoginState) {
            debugPrint('////// ErrorLoginState => ' +
                state.message.toString() +
                '//////');
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 50.0, bottom: 0.0, left: 20.0, right: 20.0),
                child: IgnorePointer(
                  ignoring: state is LoadingLoginState,
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          'login now to browse our hot offers',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        const SizedBox(
                          height: 100.0,
                        ),
                        defaultFormField(
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
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                            controller: passwordController,
                            prefix: Icons.lock,
                            type: TextInputType.visiblePassword,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Password is too short';
                              }
                              return null;
                            },
                            label: 'Password',
                            isPassword: LoginCubit.get(context).isPassword,
                            suffix: LoginCubit.get(context).suffix,
                            suffixPressed: () {
                              LoginCubit.get(context).changePasswordVisibility();
                            },
                            onSubmit: (value) {
                              userLogin(context);
                            }),
                        const SizedBox(
                          height: 5.0,
                        ),
                        defaultTextButton(
                            onPressed: () {
                              navigateTo(context, ForgetPasswordScreen());
                            },
                            label: 'Forget password ?'),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultButton(
                            onPressed: () {
                              userLogin(context);
                            },
                            label: 'Login',
                            isButtonLoading: state is LoadingLoginState
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account ?',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  ?.copyWith(fontWeight: FontWeight.w400),
                            ),
                            defaultTextButton(
                                onPressed: () {
                                  navigateToAndFinish(context, RegisterScreen());
                                },
                                label: 'Register')
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void userLogin(BuildContext context) {
    if (formKey.currentState!.validate()) {
      LoginCubit.get(context).userLogin(
          email: emailController.text, password: passwordController.text);
    }
  }
}
