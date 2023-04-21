from flask import Flask, request, jsonify, render_template
import librosa
import numpy as np
import tensorflow as tf
import json


def serialize_sets(obj):
    if isinstance(obj, set):
        return list(obj)

    return obj


app = Flask(__name__)
@app.route("/")
def Home():
    return render_template("index.html")


@app.route('/predict', methods=['POST','GET'])
def predict():
    # Get the uploaded file
    file = request.files['file']
    # print("KO",file)
    # Load the model
    model = tf.keras.models.load_model('mymodel.h5')

    # Extract the MFCC features from the audio file
    y, sr = librosa.load(file)
    mfccs = np.mean(librosa.feature.mfcc(y=y, sr=sr, n_mfcc=40).T, axis=0)
    test_point = np.reshape(mfccs, newshape=(1, 40, 1))

    # Make a prediction using the model
    emotions = {1: 'neutral', 2: 'calm', 3: 'happy', 4: 'sad', 5: 'angry', 6: 'fearful', 7: 'disgust', 8: 'surprised'}
    print("GET",type(test_point))
    # json_str = json.dumps(test_point, default=serialize_sets)

    predictions = model.predict(test_point)
    # print(predictions)
    emotion = emotions[np.argmax(predictions[0]) + 1]
    # emotion = emotions[1]
    
    
    prediction_text = "The emotion is : " 
    
    response = {"t":prediction_text, "e":emotion}

    # Return the prediction as a JSON response
    # return jsonify(response)
    return render_template('temp.html',audio_type=emotion)


if __name__ == '__main__':
    app.run(debug=True)