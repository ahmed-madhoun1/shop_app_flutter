import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData lightTheme() => ThemeData(
      scaffoldBackgroundColor: Colors.white,
      cardColor: HexColor('FFFFFF'),
      primarySwatch: Colors.grey,
      indicatorColor: HexColor('FFEC3C36'),
      appBarTheme: AppBarTheme(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        actionsIconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 24.0,
        ),
        toolbarHeight: 80.0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.grey[400],
            statusBarIconBrightness: Brightness.light),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: HexColor('F9F9F9'),
        selectedItemColor: HexColor('FFEC3C36'),
        unselectedItemColor: HexColor('FFAAAAAA'),
      ),
      textTheme: TextTheme(
          headline4: TextStyle(
          fontWeight: FontWeight.w400,
          color: HexColor('000000'),
        ),
          bodyText1: TextStyle(
            fontWeight: FontWeight.w400,
            color: HexColor('000000'),
          ),
          subtitle1: TextStyle(
            color: HexColor('7f8c8d'),
          )),
    );

ThemeData darkTheme() => ThemeData(
      scaffoldBackgroundColor: HexColor('1e272e'),
      cardColor: HexColor('353b48'),
      primarySwatch: Colors.grey,
      indicatorColor: HexColor('d2dae2'),
      appBarTheme: AppBarTheme(
        backgroundColor: HexColor('1e272e'),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0.0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24.0,
        ),
        toolbarHeight: 80.0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: HexColor('485460'),
            statusBarIconBrightness: Brightness.light),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: HexColor('485460'),
        selectedItemColor: HexColor('FFEC3C36'),
        unselectedItemColor: HexColor('d2dae2'),
      ),
      textTheme: TextTheme(
          bodyText1: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.0,
            color: HexColor('FFFFFF'),
          ),
          subtitle1: TextStyle(
            fontSize: 12.0,
            color: HexColor('DCDCDC'),
          )),
    );
