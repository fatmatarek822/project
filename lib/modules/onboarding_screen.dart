import 'package:flutter/material.dart';
import 'package:flutter_app_project1/modules/login/login_screen.dart';
import 'package:flutter_app_project1/shared/components/components.dart';
import 'package:flutter_app_project1/shared/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel ({
    required this.image,
    required this.title,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();

  List<BoardingModel> boarding =
  [
    BoardingModel(
        image: 'assets/images/1.jpg',
        title: 'On Boarding 1 Title',
        body: 'On Board 1 Body'
    ),
    BoardingModel(
        image: 'assets/images/2.jpg',
        title: 'On Boarding 2 Title',
        body: 'On Board 2 Body'
    ),
    BoardingModel(
        image: 'assets/images/3.jpg',
        title: 'On Boarding 3 Title',
        body: 'On Board 3 Body'
    ),
  ];

  bool isLast = false;

  void submit()
  {
    CacheHelper.saveData(key: 'onBoarding', value: true,).then((value) {
      if(value)
      {
        navigateAndFinish(context, LoginScreen(),);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          defaultTextButton(
            function: submit,
            text:'Skip',
          ),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [

            Expanded(
              child: PageView.builder(
                controller: boardController,
                itemBuilder: (context , index) => buildBoardingItem(boarding[index]),
                itemCount: boarding.length ,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (int index)
                {
                  if (index == boarding.length -1 )
                  {
                    setState(() {
                      isLast=true;
                    });
                  }else
                  {
                    setState(() {
                      isLast=false;
                    });
                  }
                },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardController,
                  count: boarding.length,
                  effect: const ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    dotHeight: 10,
                    expansionFactor: 4,
                    dotWidth: 10,
                    spacing: 5.0,
                    activeDotColor: Colors.lightBlue,
                  ),
                ),
                //  Text(
                //   'Indicator' ,
                // ),
                const Spacer(),
                FloatingActionButton(
                  child: const Icon (Icons.arrow_forward),
                  onPressed: ()
                  {
                    if(isLast)
                    {
                      submit();
                    }else
                    {
                      boardController.nextPage(
                          duration: const Duration(
                            milliseconds: 750,
                          ),
                          curve: Curves.fastLinearToSlowEaseIn);
                    }

                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );


  }

  Widget buildBoardingItem(BoardingModel model) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children:
    [
      Expanded(
        child: Image(
          image: AssetImage('${model.image}'),
        ),
      ),
      const SizedBox(
        height: 30.0,
      ),
      Text(
        '${model.title}',
        style: const TextStyle(
          fontSize: 24.0,
        ),
      ),
      const SizedBox(
        height: 15.0,
      ),
      Text(
        '${model.body}',
        style: const TextStyle(
          fontSize: 14.0,
        ),
      ),
      const SizedBox(
        height: 30.0,
      ),
    ],
  );
}