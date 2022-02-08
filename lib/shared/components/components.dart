import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/shared/styles/colors.dart';

/// Custom Field
TextFormField defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function(String)? onSubmit,
  Function(String)? onChange,
  bool isPassword = false,
  required String? Function(String?) validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function()? suffixPressed,
  Function()? onTap,
  bool autoFocus = false
}) =>
    TextFormField(
      autofocus: autoFocus,
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      validator: validate,
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(suffix),
              )
            : null,
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)),
      ),
      onTap: onTap,
    );

/// Custom Button
Widget defaultButton({
  required Function() onPressed,
  required String label,
  required bool isButtonLoading,
  double? radius}) =>
    MaterialButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 20.0),
        ),
          const SizedBox(width: 20.0,),
          if(isButtonLoading)
          Container(
              width: 20.0,
              height: 20.0,
              child: const CircularProgressIndicator(color: Colors.white,strokeWidth: 2.0,)
          ),
        ],
      ),
      minWidth: double.infinity,
      height: 50.0,
      color: Colors.blue,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 5)),
    );

/// Custom Text Button
Widget defaultTextButton(
        {required Function() onPressed, required String label}) =>
    TextButton(
        onPressed: onPressed,
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(color: Colors.blue),
        ));

void navigateTo(BuildContext context, Widget widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void navigateToAndFinish(BuildContext context, Widget widget) =>
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => widget),
        result: (route) {
      return false;
    });

Widget splashScreen() => Container(
    color: Colors.white,
    width: double.infinity,
    height: double.infinity,
    child: Image.asset("assets/images/app_icon.png"));

SnackBar internetSnackBar = const SnackBar(
  behavior: SnackBarBehavior.floating,
  margin: EdgeInsets.only(bottom: 70.0, left: 20.0, right: 20.0),
  dismissDirection: DismissDirection.none,
  content: Text("No Internet Connection"),
  duration: Duration(days: 365),
);

showToast(
        {required String message,
        required ToastStates toastStates,
        required bool longTime}) =>
    Fluttertoast.showToast(
        msg: message,
        toastLength: longTime ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: longTime ? 5 : 1,
        backgroundColor: toastColor(toastStates),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastStates { SUCCESS, ERROR, WARNING }

Color toastColor(ToastStates toastStates) {
  Color color;
  switch (toastStates) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}
