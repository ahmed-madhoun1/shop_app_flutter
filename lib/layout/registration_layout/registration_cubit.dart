import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'registration_states.dart';

class RegistrationCubit extends Cubit<RegistrationStates> {
  RegistrationCubit() : super(InitRegistrationState());

  static RegistrationCubit get(BuildContext context) => BlocProvider.of(context);


}
