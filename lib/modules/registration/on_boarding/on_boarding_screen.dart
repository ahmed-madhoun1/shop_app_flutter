
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:shop_app/models/boarding_item/boarding_item.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../login/login_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  List<BoardingItem> boardingItems = [
    BoardingItem(
        image: 'assets/images/shop_1.jpg', title: 'Title 1', body: 'Body 1'),
    BoardingItem(
        image: 'assets/images/shop_2.jpg', title: 'Title 2', body: 'Body 2'),
    BoardingItem(
        image: 'assets/images/shop_2.jpg', title: 'Title 3', body: 'Body 3'),
  ];

  var pageViewController = PageController();
  var pageIndex = 0;

  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                navigateToLoginScreen(context);
              },
              child: const Text(
                'Skip',
                style: TextStyle(color: Colors.black),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageViewController,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  pageIndex = index;
                  return buildBoardingItem(boardingItems[index]);
                },
                itemCount: boardingItems.length,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: pageViewController,
                  count: boardingItems.length,
                  effect: ExpandingDotsEffect(
                      spacing: 10.0,
                      radius: 5.0,
                      dotWidth: 10.0,
                      dotHeight: 10.0,
                      dotColor: Colors.grey,
                      activeDotColor: primaryColor),
                ),
                const Spacer(),
                FloatingActionButton(
                  backgroundColor: primaryColor,
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (pageIndex == boardingItems.length - 1) {
                      navigateToLoginScreen(context);
                    } else {
                      pageViewController.nextPage(
                          duration: const Duration(
                            milliseconds: 700,
                          ),
                          curve: Curves.fastLinearToSlowEaseIn);
                    }
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void navigateToLoginScreen(BuildContext context){
    CacheHelper.setData(key: 'onBoarding', value: true).then((value) => {
      navigateToAndFinish(context,  LoginScreen()),
    });
  }

  Widget buildBoardingItem(BoardingItem item) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image(
              image: AssetImage(item.image),
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Text(
            item.title,
            style: const TextStyle(fontSize: 24.0),
          ),
          const SizedBox(
            height: 14.0,
          ),
          Text(item.body),
          const SizedBox(
            height: 14.0,
          ),
        ],
      );
}
