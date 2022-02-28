import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/home_layout/home_cubit.dart';
import 'package:shop_app/layout/home_layout/home_states.dart';
import 'package:shop_app/modules/home/search/search_screen.dart';
import 'package:shop_app/shared/components/components.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        HomeCubit homeCubit = HomeCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(homeCubit.homeBottomNavItems[homeCubit.currentIndex].label.toString()),
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded),
                onPressed: (){
                  navigateTo(context, SearchScreen());
                },
              )
            ],
          ),
          body: homeCubit.homeBottomNavScreens[homeCubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: homeCubit.currentIndex,
            items: homeCubit.homeBottomNavItems,
            onTap: (index){
              homeCubit.changeBottomNavIndex(index);
            },
          ),
        );
      },
    );
  }
}
