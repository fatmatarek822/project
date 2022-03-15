import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_project1/layout/layout_screen.dart';
import 'package:flutter_app_project1/modules/cubit/cubit.dart';
import 'package:flutter_app_project1/modules/cubit/states.dart';
import 'package:flutter_app_project1/modules/login/login_screen.dart';
import 'package:flutter_app_project1/modules/onboarding_screen.dart';
import 'package:flutter_app_project1/shared/components/constant.dart';
import 'package:flutter_app_project1/shared/network/local/cache_helper.dart';
import 'package:flutter_app_project1/shared/styles/themes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
   // options: DefaultFirebaseOptions.currentPlatform,
  );

  await CacheHelper.init();

  bool isDark = CacheHelper.getData(key: 'isDark');

  Widget widget;
  // token = CacheHelper.getData(key: 'token');
  uid = CacheHelper.getData(key: 'uid');
  bool? onboarding = CacheHelper.getData(key: 'onBoarding');

 // print(uid);

  if (onboarding != null)
  {
    if (uid != null)
    {
      widget = LayoutScreen();
    } else
      {
      widget = LoginScreen();
      }
  } else
    {
    widget = OnBoardingScreen();
    }

  // if(uid !=null)
  // {
  //   widget = LayoutScreen();
  // }else
  // {
  //   widget = LoginScreen();
  // }

  runApp(MyApp(
      startWidget: widget,
      isDark: isDark,
  ));
}

class MyApp extends StatelessWidget {

  bool? isDark;
  String? uid;
  Widget? startWidget;
  MyApp({this.startWidget, this.uid, this.isDark});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..getUserData()..changeAppMode(
        themeMode: isDark,
      ),
      child: BlocConsumer<AppCubit, AppStates>(
       listener: (context, state) {},
        builder: (context, state)
        {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            // theme: ThemeData(
            //   primarySwatch: Colors.lightBlue,
            //   scaffoldBackgroundColor: Colors.white,
            //   appBarTheme: const AppBarTheme(
            //     titleSpacing: 20.0,
            //     backwardsCompatibility: false,
            //     systemOverlayStyle: SystemUiOverlayStyle(
            //       statusBarColor: Colors.white,
            //       statusBarIconBrightness: Brightness.dark,
            //     ),
            //     backgroundColor: Colors.white,
            //     elevation: 0.0,
            //     titleTextStyle: TextStyle(
            //       color: Colors.black,
            //       fontSize: 20.0,
            //       fontWeight: FontWeight.bold,
            //     ),
            //     iconTheme: IconThemeData(
            //       color: Colors.black,
            //     ),
            //
            //   ),
            //   floatingActionButtonTheme: const FloatingActionButtonThemeData(
            //     backgroundColor: Colors.lightBlue,
            //   ),
            //   bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            //     type: BottomNavigationBarType.fixed,
            //     selectedItemColor: Colors.lightBlue,
            //     unselectedItemColor: Colors.grey,
            //     elevation: 20.0,
            //     backgroundColor: Colors.white,
            //
            //   ),
            //   textTheme: const TextTheme(
            //     bodyText1:TextStyle(
            //       fontSize: 16.0,
            //       fontWeight: FontWeight.w600,
            //       color: Colors.black,
            //     ),
            //   ),
            // ),
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            //  themeMode: AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: AnimatedSplashScreen(
              splash: Icons.house_outlined,
              nextScreen: startWidget!,
              backgroundColor: Colors.white,
              duration: 2500,
              centered: true,
              splashIconSize: 100,
              splashTransition: SplashTransition.fadeTransition,
            ),
          );
        },
      ),
    );
  }
}
