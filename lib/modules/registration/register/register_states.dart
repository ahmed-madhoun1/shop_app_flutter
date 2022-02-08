import 'package:shop_app/models/user/user_response.dart';

abstract class RegisterStates {}

class InitRegisterState extends RegisterStates {}

class LoadingRegisterState extends RegisterStates {}

class SuccessRegisterState extends RegisterStates {
  late UserResponse userResponse;

  SuccessRegisterState(this.userResponse);
}

class ErrorRegisterState extends RegisterStates {
  late String message;

  ErrorRegisterState(this.message);
}

class ChangePasswordVisibilityRegisterState extends RegisterStates {}
