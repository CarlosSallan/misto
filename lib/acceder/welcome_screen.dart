import 'package:flutter/material.dart';
import 'package:misto/acceder/intro_page1.dart';
import 'package:misto/acceder/intro_page2.dart';
import 'package:misto/acceder/intro_page3.dart';
import 'package:misto/login/login.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class welcomeScreen extends StatefulWidget {
  const welcomeScreen({Key? key}) : super(key: key);

  @override
  State<welcomeScreen> createState() => _welcomeScreenState();
}

class _welcomeScreenState extends State<welcomeScreen> {

  PageController _controller = PageController();
  bool onLastPage =false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller:  _controller,
          onPageChanged: (index){
            setState((){
              onLastPage=(index == 2);
            });
          },
          children: [
              introPage1(),
              introPage2(),
              introPage3(),
          ],
        ),

        Container(
          alignment: Alignment(0, 0.80),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              GestureDetector(
                onTap:(){
                  _controller.jumpToPage(2);
                },
                child: Text('Atras',
                  style: TextStyle(
                    color: Color.fromRGBO(22,53,77,1.000),
                    decoration: TextDecoration.none,
                    fontSize: 20.0,
                  ),),
              ),


              SmoothPageIndicator(controller: _controller, count: 3),


              onLastPage ?
              GestureDetector(
                onTap:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return login();
                  })
                  );
                },
                child: Text('Empezar',
                  style: TextStyle(
                    color: Color.fromRGBO(22,53,77,1.000),
                    decoration: TextDecoration.none,
                    fontSize: 20.0,
                  ),),
              ): GestureDetector(
              onTap:(){
                  _controller.nextPage(
                    duration:  Duration(milliseconds:500),
                  curve: Curves.easeIn
                ) ;
                },
              child: Text('Siguiente',
                style: TextStyle(
                  color: Color.fromRGBO(22,53,77,1.000),
                 decoration: TextDecoration.none,
                  fontSize: 20.0,
                ),
              ),
              ),

            ],
          ),
        ),
      ],
    );
  }
}
