import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/home_layout/home_layout.dart';
import 'package:shop_app/modules/registration/login/login_screen.dart';
import 'package:shop_app/modules/registration/register/register_cubit.dart';
import 'package:shop_app/modules/registration/register/register_states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constanse.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

class RegisterScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is SuccessRegisterState) {
            if (state.userResponse.status) {
              debugPrint('RegisterScreen (SuccessRegisterState)${state.userResponse.status}');
              if (state.userResponse.user?.token != null) {
                CacheHelper.setData(key: 'token', value: state.userResponse.user?.token)
                    .then((value) => {
                      if(value){
                        debugPrint('RegisterScreen (CacheHelper.setData then) Token Saved'),
                        userToken = state.userResponse.user!.token,
                        showToast(message: state.userResponse.message!, toastStates: ToastStates.SUCCESS, longTime: false),
                        navigateToAndFinish(context, const HomeLayout()),
                      }
                });
              } else {
                debugPrint('***** state.userResponse.data?.token == null *****');
              }
            } else {
              showToast(
                  message: state.userResponse.message!,
                  toastStates: ToastStates.ERROR,
                  longTime: true);
            }
          }
          if (state is ErrorRegisterState) {
            debugPrint('RegisterScreen (ErrorRegisterState) => ' + state.message.toString());
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 50.0, bottom: 0.0, left: 20.0, right: 20.0),
              child: IgnorePointer(
                ignoring: state is LoadingRegisterState,
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Register',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        'Register now to browse our hot offers',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      const SizedBox(
                        height: 60.0,
                      ),
                      defaultFormField(
                        controller: emailController,
                        prefix: Icons.email_rounded,
                        type: TextInputType.emailAddress,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Email address required';
                          }
                        },
                        label: 'Email',
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      defaultFormField(
                        controller: passwordController,
                        prefix: Icons.lock,
                        type: TextInputType.visiblePassword,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Password is too short';
                          }
                        },
                        label: 'Password',
                        isPassword: RegisterCubit.get(context).isPassword,
                        suffix: RegisterCubit.get(context).suffix,
                        suffixPressed: () {
                          RegisterCubit.get(context).changePasswordVisibility();
                        },
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      defaultFormField(
                        controller: nameController,
                        prefix: Icons.email_rounded,
                        type: TextInputType.name,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Name required';
                          }
                        },
                        label: 'username',
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      defaultFormField(
                        controller: phoneController,
                        prefix: Icons.phone,
                        type: TextInputType.phone,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Phone required';
                          }
                        },
                        label: 'Phone',
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      defaultButton(
                          onPressed: () {
                            userRegister(context);
                          },
                          label: 'Register',
                          isButtonLoading: state is LoadingRegisterState
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Do you have an account ?',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                ?.copyWith(fontWeight: FontWeight.w400),
                          ),
                          defaultTextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              label: 'Login')
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void userRegister(BuildContext context) {
    if (formKey.currentState!.validate()) {
      RegisterCubit.get(context).userRegister(
          email: emailController.text,
          password: passwordController.text,
          name: nameController.text,
          phone: phoneController.text,
          image: '',
      );
    }
  }
}
