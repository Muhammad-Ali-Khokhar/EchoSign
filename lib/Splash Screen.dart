import 'package:flutter/material.dart';
import 'package:sufyan/Camera%20Screen.dart';

import 'Welcome Screen.dart';

class SplashScreen extends StatelessWidget {

  Future<bool> fakeLoading() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulating a 3-second delay
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FutureBuilder<bool>(
          future: fakeLoading(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Text(
                  'EchoSign',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            } else {
              return CameraScreen();
            }
          },
        ),
      ),
    );
  }
}