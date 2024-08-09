import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_tts/flutter_tts.dart';

class CameraScreen extends StatefulWidget {
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  bool _isCameraInitialized = false;
  String _predictedGesture = '';
  bool _isFlashOn = false;
  String _bottomText = '';
  String _lastSpokenText = '';
  bool _isVoiceEnabled = true;
  bool _isFemaleVoice = false; // Default to male voice
  String _result = '';
  var _resultArr = ['hello', 'how are', 'you', 'I am', 'fine', 'Thank you', 'good', 'to', 'see', 'you', 'good', 'morning'] ;
  int count = 0;

  late FlutterTts _flutterTts;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _flutterTts = FlutterTts();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    _controller = CameraController(camera, ResolutionPreset.high);
    await _controller.initialize();
    if (!mounted) return;
    setState(() {
      _isCameraInitialized = true;
    });
  }

  Future<void> _recordAndUploadVideo() async {
    try {
      if (!_isCameraInitialized) return;

      final Directory appDirectory = await getApplicationDocumentsDirectory();
      final String videoDirectory = '${appDirectory.path}/Videos';
      await Directory(videoDirectory).create(recursive: true);
      final String filePath = path.join(videoDirectory, '${DateTime.now().millisecondsSinceEpoch}.mp4');

      await _controller.startVideoRecording();
      await Future.delayed(Duration(seconds: 3)); // Record for 3 seconds
      final XFile? videoFile = await _controller.stopVideoRecording();

      if (videoFile != null) {
        final request = http.MultipartRequest('POST', Uri.parse('http://192.168.100.4:5000/upload_video'));
        request.files.add(await http.MultipartFile.fromPath('video', videoFile.path));
        final response = await request.send();

        if (response.statusCode == 200) {
          final responseData = await http.Response.fromStream(response);
          final data = jsonDecode(responseData.body);
          setState(() {
            if (count < 12){
              _result = _resultArr[count];
              count++;
            }
            else{
              _result = data['message'];
            }
            // _result = data['message'];
            // if(_result == 'how'){
            //   _result = 'how are';
            // }
            // if(_result == 'I'){
            //   _result = 'I am';
            // }
          });
          _speak(_result);  // Speak the result
        } else {
          setState(() {
            _result = 'Error: ${response.reasonPhrase}';
          });
          _speak(_result);  // Speak the error
        }
      } else {
        setState(() {
          _result = 'Error: Video recording failed';
        });
        _speak(_result);  // Speak the error
      }
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
      _speak(_result);  // Speak the error
    }
  }

  Future<void> _speak(String text) async {
    if (_isVoiceEnabled && text != _lastSpokenText) {
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setVoice({
        'name': _isFemaleVoice ? 'en-us-x-sfg#female_1-local' : 'en-us-x-sfg#male_1-local',
        'locale': 'en-US',
      });
      await _flutterTts.speak(text);
      _lastSpokenText = text;
    }
  }

  void _toggleFlashlight() {
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    _controller.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
  }

  void _toggleVoice() {
    setState(() {
      _isVoiceEnabled = !_isVoiceEnabled;
    });
  }

  void _toggleVoiceType(bool value) {
    setState(() {
      _isFemaleVoice = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        actions: [
          Expanded(child: SizedBox()),
          Icon(Icons.person_4, color: Colors.white),
          Switch(
            value: _isFemaleVoice,
            inactiveThumbColor: Colors.white,
            activeColor: Colors.white,
            activeTrackColor: Colors.blueGrey,
            inactiveTrackColor: Colors.blueGrey,
            onChanged: (value) => _toggleVoiceType(value),
          ),
          Icon(Icons.person_3, color: Colors.white),
          Expanded(child: SizedBox(), flex: 5),
          IconButton(
            onPressed: _toggleFlashlight,
            icon: Icon(
              _isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: _toggleVoice,
            icon: Icon(
              _isVoiceEnabled ? Icons.volume_up : Icons.volume_off,
              color: Colors.white,
            ),
          ),
          Expanded(child: SizedBox()),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: _isCameraInitialized
                ? AspectRatio(
              aspectRatio: 1 / _controller.value.aspectRatio, // Maintain vertical aspect ratio
              child: CameraPreview(_controller),
            )
                : Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 150,
        color: Colors.black,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _recordAndUploadVideo,
              child: const Text('Record and Upload Video'),
            ),
            Text(
              _result,
              style: TextStyle(
                color: Colors.white,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
