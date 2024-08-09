# EchoSign

**EchoSign** is a Flutter-based mobile camera application designed to detect sign language gestures and translate them into text and voice. The app utilizes deep learning, with a model trained on American Sign Language (ASL) gestures, to help bridge communication gaps for the hearing-impaired community.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Model and Server Setup](#model-and-server-setup)
- [Usage](#usage)
- [Screenshots](#screenshots)
- [Contributing](#contributing)

## Features

- **Introductory Sliders**: Guides users on how to use the app. Shown only the first time the app is opened.
- **Splash Screen**: Displays the EchoSign logo.
- **Main Camera Screen**: 
  - **Gesture Recognition**: Uses the camera to capture gestures and convert them into text and voice.
  - **Toggle Button**: Switch between male and female voice.
  - **Flashlight Control**: Turn the flashlight on/off.
  - **Voice Control**: Enable or disable voice output.
  - **Recording Button**: Starts video recording (captures 60 frames) for gesture recognition.
  - **Prediction Display**: Displays the recognized gesture text and converts it into voice.

## Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/EchoSign.git
   cd EchoSign
   ```

2. **Install Dependencies**:
   Make sure you have Flutter installed. Then run:
   ```bash
   flutter pub get
   ```

3. **Run the App**:
   Connect your mobile device or start an emulator, and run:
   ```bash
   flutter run
   ```

## Model and Server Setup

1. **Download the Model**:
   Download the trained InceptionV3 model from [this link](https://github.com/Muhammad-Ali-Khokhar/EchoSign/blob/master/other_resources/InceptionV3_Model.tflite).

2. **Set Up the Server**:
   - Download the `server_code.py` file from [this link](https://github.com/Muhammad-Ali-Khokhar/EchoSign/blob/master/other_resources/server_code.py).
   - Update the model path in the `server_code.py` to match the location of your downloaded model.
   - Start the server using CMD:
     ```bash
     python server_code.py
     ```
   Ensure that your laptop and mobile device are on the same network so the app can communicate with the server.

## Usage

1. **Open the App**: The introductory sliders will guide you through the app features.
2. **Main Camera Screen**:
   - Toggle settings as needed.
   - Press the recording button to capture gestures.
   - Wait for the prediction to be displayed and spoken.
3. **Server**: Ensure your server is running before attempting to use the gesture recognition feature.

## Screenshots

<p align="center">
  <img src="https://github.com/Muhammad-Ali-Khokhar/EchoSign/blob/master/other_resources/one.jpg" alt="Screen 1" width="200"/>
  <img src="https://github.com/Muhammad-Ali-Khokhar/EchoSign/blob/master/other_resources/step%201.jpg" alt="Screen 2" width="200"/>
  <img src="https://github.com/Muhammad-Ali-Khokhar/EchoSign/blob/master/other_resources/step%202.jpg" alt="Screen 3" width="200"/>
  <img src="https://github.com/Muhammad-Ali-Khokhar/EchoSign/blob/master/other_resources/splash.jpg" alt="Splash Screen" width="200"/>
  <img src="https://github.com/Muhammad-Ali-Khokhar/EchoSign/blob/master/other_resources/camera.jpg" alt="Camera Screen" width="200"/>
</p>

## Contributing

Contributions are welcome! Please fork this repository and submit a pull request with your changes. For major changes, please open an issue first to discuss what you would like to change.
