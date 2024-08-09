from flask import Flask, request, jsonify
import os
import cv2
import numpy as np
import tensorflow as tf

app = Flask(__name__)

# Load the TFLite model
def load_tflite_model(tflite_model_path):
    interpreter = tf.lite.Interpreter(model_path=tflite_model_path)
    interpreter.allocate_tensors()
    return interpreter

checkpoint_path = r"D:\M.Ali\Semester 8\FYP-2\Final DataSet\InceptionV3 Trained Model\InceptionV3.tflite"
interpreter = load_tflite_model(checkpoint_path)

IMG_SIZE = 224
N_FRAMES = 60

def load_video(video_path, max_frames=N_FRAMES):
    cap = cv2.VideoCapture(video_path)
    frames = []
    while len(frames) < max_frames:
        ret, frame = cap.read()
        if not ret:
            break
        frame = cv2.resize(frame, (IMG_SIZE, IMG_SIZE))
        frames.append(frame)
    cap.release()

    if len(frames) < max_frames:
        frames.extend([frames[-1]] * (max_frames - len(frames)))  # Pad with last frame

    frames = np.array(frames)
    frames = frames / 255.0  # Normalize
    return frames

DATASET_DIR = r'D:\M.Ali\Semester 8\FYP-2\Final DataSet\DataSet 1.2'
def load_dataset_paths(dataset_dir):
    label_map = {}
    for i, label in enumerate(os.listdir(dataset_dir)):
        label_map[i] = label
    return label_map

# Load dataset paths
label_map = load_dataset_paths(DATASET_DIR)

def get_word_from_label(label):
    return label_map.get(label, 'Unknown')

@app.route('/sum', methods=['POST'])
def calculate_sum():
    data = request.get_json()
    num1 = data.get('num1')
    num2 = data.get('num2')
    
    if num1 is None or num2 is None:
        return jsonify({'error': 'Invalid input'}), 400

    try:
        num1 = int(num1)
        num2 = int(num2)
    except ValueError:
        return jsonify({'error': 'Invalid number format'}), 400
    
    result = num1 + num2
    return jsonify({'sum': result})

@app.route('/upload_video', methods=['POST'])
def upload_video():
    if 'video' not in request.files:
        return jsonify({'message': 'No video file provided'}), 400

    video = request.files['video']
    save_path = os.path.join('videos', video.filename)

    if not os.path.exists('videos'):
        os.makedirs('videos')

    video.save(save_path)

    # Load and preprocess the video
    video_frames = load_video(save_path)
    
    # Add batch dimension
    video_frames = np.expand_dims(video_frames, axis=0).astype(np.float32)
    
    # Get input and output details
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()
    
    # Set the input tensor
    interpreter.set_tensor(input_details[0]['index'], video_frames)
    
    # Run inference
    interpreter.invoke()
    
    # Get the output tensor
    predictions = interpreter.get_tensor(output_details[0]['index'])
    
    predicted_class = np.argmax(predictions, axis=-1)
    predicted_word = get_word_from_label(predicted_class[0])

    return jsonify({'message': predicted_word})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
