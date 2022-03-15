import 'package:flutter/material.dart';
import 'package:flutter_app_project1/modules/cubit/cubit.dart';
import 'package:flutter_app_project1/modules/cubit/states.dart';
import 'package:flutter_app_project1/modules/search/search_screen.dart';
import 'package:flutter_app_project1/shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AppCubit, AppStates>(
       listener: (context, state) {},
        builder: (context, state)
        {
          var cubit = AppCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              title: Text('Real Estate'),
              actions: [
                IconButton(
                    onPressed: ()
                    {
                      navigateTo(context, SearchScreen());
                    },
                    icon: Icon(Icons.search),
                ),
                IconButton(onPressed: ()
                {
                   AppCubit.get(context).changeAppMode();
                }, icon: Icon(
                    Icons.brightness_4_outlined),
                ),
              ],
            ),
            body: cubit.Screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index)
              {
                cubit.ChangeBottomNav(index);
              },
              currentIndex: cubit.currentIndex,
              items:
              const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  label: 'Map',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Favourite',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.message),
                  label: 'Chat',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Setting',
                ),
              ],
            ),
          );
        },
      );

  }
}

