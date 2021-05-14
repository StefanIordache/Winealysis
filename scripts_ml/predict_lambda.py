import numpy as np
import pandas as pd
import os
import pickle
from google.cloud import storage
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
from tensorflow.keras.layers.experimental import preprocessing


## Gloabl model variable
model = None


# Download model file from cloud storage bucket
def download_model_file():

    from google.cloud import storage

    # Model Bucket details
    BUCKET_NAME        = "predict_bucket_r"
    PROJECT_ID         = "third-container-310616"
    GCS_MODEL_FILE     = "model.h5"

    # Initialise a client
    client   = storage.Client(PROJECT_ID)
    
    # Create a bucket object for our bucket
    bucket   = client.get_bucket(BUCKET_NAME)
    
    # Create a blob object from the filepath
    blob     = bucket.blob(GCS_MODEL_FILE)
    
    folder = '/tmp/'
    if not os.path.exists(folder):
      os.makedirs(folder)
    # Download the file to a destination
    blob.download_to_filename(folder + "local_model.h5")

    # Main entry point for the cloud function
def predict_wine_price(request):

    # Use the global model variable 
    global model

    if not model:

        download_model_file()
        model = keras.Sequential([
                    layers.Dense(1024, activation='relu'),
                    #layers.Dense(64, activation='relu'),
                    layers.Dense(1)
                  ])
        model.compile(loss='mean_absolute_error',optimizer='adam')
        model = keras.models.load_model('/tmp/local_model.h5')
    
    # Get the features sent for prediction
    params = request.get_json()

    if (params is not None) and ('features' in params):
        # Run a test prediction
        pred_species  = model.predict(np.array([params['features']]))
        return str(pred_species[0])
        
    else:
        return "nothing sent for prediction"