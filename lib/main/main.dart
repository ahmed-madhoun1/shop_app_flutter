import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/home_layout/home_cubit.dart';
import 'package:shop_app/layout/home_layout/home_states.dart';
import 'package:shop_app/main/app_cubit.dart';
import 'package:shop_app/shared/components/constanse.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/styles/themes.dart';

import '../layout/home_layout/home_layout.dart';
import '../layout/registration_layout/registration_layout.dart';

Future<void> main() async {
  /// Mean it will finish all the operation then execute runApp Function
  WidgetsFlutterBinding.ensureInitialized();

  /// Dio API Handler
  await DioHelper.init();

  /// Shared Preferences
  await CacheHelper.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    onBoarding = CacheHelper.getData(key: 'onBoarding');
    userToken = CacheHelper.getData(key: 'token');
    bool? isDark = CacheHelper.getData(key: 'isDark');
    debugPrint('MainApp (token) => ' + userToken.toString());
    debugPrint('MainApp (onBoarding) => ' + onBoarding.toString());
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => AppCubit()
          ),
          BlocProvider(
            create: (context) => HomeCubit()..changeAppMode(isDarkShared: isDark)..getProducts()..getCategories()..getUserFavoriteProducts()..getUserCartProducts()..getUserProfile(),
          ),
        ],
        child: BlocConsumer<HomeCubit, HomeStates>(
            listener: (context, state){},
            builder: (context, state) => MaterialApp(
              debugShowCheckedModeBanner: false,
              home: onBoarding != null && userToken != null
                  ? const HomeLayout()
                  : const RegistrationLayout(),
              theme: lightTheme(),
              darkTheme: darkTheme(),
              themeMode: HomeCubit.get(context).isDark
                  ? ThemeMode.dark
                  : ThemeMode.light,
            ))
    );
  }
}
