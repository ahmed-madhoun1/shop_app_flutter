import 'package:shop_app/models/user/user_response.dart';

abstract class LoginStates {}

class InitLoginState extends LoginStates {}

class LoadingLoginState extends LoginStates {}

class SuccessLoginState extends LoginStates {
  late UserResponse userResponse;

  SuccessLoginState(this.userResponse);
}

class ErrorLoginState extends LoginStates {
  late String message;

  ErrorLoginState(this.message);
}

class ChangePasswordVisibilityLoginState extends LoginStates {}
