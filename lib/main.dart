import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sufyan/Welcome%20Screen.dart';
import 'Splash Screen.dart';
import 'constraints.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black)
      )
    );
  }
}
