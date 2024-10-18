import 'package:flipmlkitocr/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    navigateToNext();
  }

  void navigateToNext() async {
    await Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen2()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0XFF900C3F),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                child: Image.asset('assets/flipkartBG.png')),
          ],
        ),
      ),
    );
  }
}
