import 'package:flutter/material.dart';
import 'package:sufyan/Splash%20Screen.dart';
import 'Camera Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  bool isFirstTimeOpen = true;

  @override
  void initState() {
    super.initState();
    checkFirstTimeOpen();
  }

  void checkFirstTimeOpen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    setState(() {
      isFirstTimeOpen = isFirstTime;
    });
  }

  void setFirstTimeOpen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
  }

  @override
  Widget build(BuildContext context) {
    if (isFirstTimeOpen) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    SlidePage(
                      image: AssetImage('assets/slide_1.jpg'),
                    ),
                    SlidePage(
                      image: AssetImage('assets/slide_2.jpg'),
                    ),
                    SlidePage(
                      image: AssetImage('assets/slide_3.jpg'),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _currentPage == 0
                        ? null
                        : () => _pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Prev'),
                  ),
                  ElevatedButton(
                    onPressed: _currentPage == 2
                        ? () {
                      setFirstTimeOpen();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SplashScreen()),
                      );
                    }
                        : () => _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                    ),
                    child: _currentPage == 2 ? const Text('Next') : const Text('Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return SplashScreen();
    }
  }
}

class SlidePage extends StatelessWidget {
  final ImageProvider? image;

  SlidePage({required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Image(image: image!, fit: BoxFit.cover),
    );
  }
}
