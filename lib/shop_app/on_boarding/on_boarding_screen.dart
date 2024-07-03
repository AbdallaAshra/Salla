import 'package:flutter/material.dart';
import 'package:news_app/network/local/cache_helper.dart';
import 'package:news_app/shared/components.dart';
import 'package:news_app/shop_app/login_screen/login_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel
{
  final String image;
  final String body;
  final String title;
  BoardingModel({
    required this.image,
    required this.body,
    required this.title,
});

}

class OnBoardingScreen extends StatefulWidget {
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<BoardingModel> boarding = [
    BoardingModel(
      image: 'assets/images/onboard.jpg',
      body: 'on board 1 body',
      title: 'on board 1 title',
    ),
    BoardingModel(
      image: 'assets/images/onboard.jpg',
      body: 'on board 2 body',
      title: 'on board 2 title',
    ),
    BoardingModel(
      image: 'assets/images/onboard.jpg',
      body: 'on board 3 body',
      title: 'on board 3 title',
    ),
  ];

  var boardController = PageController();
  bool isLast = false;

  void submit()
  {
    CacheHelper.saveData(
        key: 'onBoarding',
        value: true,).then((value)
    {
      if(value)
      {
        navigateAndFinish(context, ShopLoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        actions: [
          defaultTextButton(
            text: 'SKIP',
            function: submit,
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
                itemBuilder: (context,index)=> buidBoardingItem(boarding[index]),
                itemCount: boarding.length,
                onPageChanged: (index)
                {
                  if(index == boarding.length - 1)
                  {
                    setState(() {
                      isLast = true;
                    });
                  }else{
                    setState(() {
                      isLast =false;
                    });
                  }
                },
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                    controller: boardController,
                    count: boarding.length,
                    effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    activeDotColor: Colors.deepOrange,
                    dotHeight: 10,
                    dotWidth:10,
                    spacing: 5.0,
                  ),
                ),
                Spacer(),
                FloatingActionButton(
                  onPressed: (){
                    if(isLast)
                    {
                      submit;
                    }else{
                      boardController.nextPage(
                        duration: Duration(
                          milliseconds: 750,
                        ),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: Icon(Icons.arrow_forward_ios,),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buidBoardingItem(BoardingModel model) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Image(
          image: AssetImage('${model.image}'),
        ),
      ),
      SizedBox(
        height: 20.0,
      ),
      Text(
        '${model.title}',
        style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        '${model.body}',
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
