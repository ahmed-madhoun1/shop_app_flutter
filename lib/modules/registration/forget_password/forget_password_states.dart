import 'package:shop_app/models/user/send_email_verification_response.dart';

abstract class ForgetPasswordStates {}

class InitForgetPasswordState extends ForgetPasswordStates {}

class SendEmailVerificationLoadingForgetPasswordState extends ForgetPasswordStates {}

class SendEmailVerificationSuccessForgetPasswordState extends ForgetPasswordStates {
  late SendEmailVerificationResponse sendEmailVerificationResponse;

  SendEmailVerificationSuccessForgetPasswordState(this.sendEmailVerificationResponse);
}

class SendEmailVerificationErrorForgetPasswordState extends ForgetPasswordStates {
  late String message;

  SendEmailVerificationErrorForgetPasswordState(this.message);
}

class ResetPasswordLoadingForgetPasswordState extends ForgetPasswordStates {}

class ResetPasswordSuccessForgetPasswordState extends ForgetPasswordStates {
  late SendEmailVerificationResponse sendEmailVerificationResponse;

  ResetPasswordSuccessForgetPasswordState(this.sendEmailVerificationResponse);
}

class ResetPasswordErrorForgetPasswordState extends ForgetPasswordStates {
  late String message;

  ResetPasswordErrorForgetPasswordState(this.message);
}

class TimerForgetPasswordState extends ForgetPasswordStates {}
