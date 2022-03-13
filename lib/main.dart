import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_project1/layout/layout_screen.dart';
import 'package:flutter_app_project1/modules/cubit/cubit.dart';
import 'package:flutter_app_project1/modules/login/login_screen.dart';
import 'package:flutter_app_project1/modules/onboarding_screen.dart';
import 'package:flutter_app_project1/modules/splash_screen.dart';
import 'package:flutter_app_project1/shared/components/constant.dart';
import 'package:flutter_app_project1/shared/network/local/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
   // options: DefaultFirebaseOptions.currentPlatform,
  );

  await CacheHelper.init();

  Widget widget;
  // token = CacheHelper.getData(key: 'token');
  uid = CacheHelper.getData(key: 'uid');
  print(uid);


  if(uid !=null)
  {
    widget = LayoutScreen();
  }else
  {
    widget = LoginScreen();
  }


  runApp(MyApp(
      startWidget: widget
  ));
}

class MyApp extends StatelessWidget {

  final Widget? startWidget;
  MyApp({this.startWidget});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..getUserData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            titleSpacing: 20.0,
            backwardsCompatibility: false,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
            ),
            backgroundColor: Colors.white,
            elevation: 0.0,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(
              color: Colors.black,
            ),

          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.lightBlue,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.lightBlue,
            unselectedItemColor: Colors.grey,
            elevation: 20.0,
            backgroundColor: Colors.white,

          ),
          textTheme: const TextTheme(
            bodyText1:TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        home: startWidget,
      ),
    );
  }
}
