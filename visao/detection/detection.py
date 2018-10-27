######## Picamera Object Detection Using Tensorflow Classifier #########
#
# Author: Evan Juras
# Date: 4/15/18
# Description: 
# This program uses a TensorFlow classifier to perform object detection.
# It loads the classifier uses it to perform object detection on a Picamera feed.
# It draws boxes and scores around the objects of interest in each frame from
# the Picamera. It also can be used with a webcam by adding "--usbcam"
# when executing this script from the terminal.

## Some of the code is copied from Google's example at
## https://github.com/tensorflow/models/blob/master/research/object_detection/object_detection_tutorial.ipynb

## and some is copied from Dat Tran's example at
## https://github.com/datitran/object_detector_app/blob/master/object_detection_app.py

## but I changed it to make it more understandable to me.


# Import packages
import os
import cv2
import numpy as np
import tensorflow as tf
import sys
import threading

from object_detection.utils import label_map_util
from object_detection.utils import visualization_utils as vis_util

class ObjectDetector():
    def __init__(self, MODEL_NAME="model_dir"):
        print("Incializando detector...")
        self.IM_WIDTH = 640    #Use smaller resolution for
        self.IM_HEIGHT = 480   #slightly faster framerate
        # Name of the directory containing the object detection module we're using
        self.MODEL_NAME = MODEL_NAME

        # Grab path to current working directory
        self.CWD_PATH = os.getcwd()
        self.PATH_TO_CKPT = os.path.join(self.CWD_PATH,'models',self.MODEL_NAME,'frozen_inference_graph.pb')
        self.PATH_TO_LABELS = os.path.join(self.CWD_PATH,'models',self.MODEL_NAME,'label_map.pbtxt')
        self.NUM_CLASSES = open(self.PATH_TO_LABELS, 'r').read().count('item')

        ## Load the label map.
        # Label maps map indices to category names, so that when the convolution
        # network predicts `5`, we know that this corresponds to `airplane`.
        # Here we use internal utility functions, but anything that returns a
        # dictionary mapping integers to appropriate string labels would be fine
        label_map = label_map_util.load_labelmap(self.PATH_TO_LABELS)
        categories = label_map_util.convert_label_map_to_categories(label_map, max_num_classes=self.NUM_CLASSES, use_display_name=True)
        self.category_index = label_map_util.create_category_index(categories)

        # Load the Tensorflow model into memory.
        detection_graph = tf.Graph()
        with detection_graph.as_default():
            od_graph_def = tf.GraphDef()
            with tf.gfile.GFile(self.PATH_TO_CKPT, 'rb') as fid:
                serialized_graph = fid.read()
                od_graph_def.ParseFromString(serialized_graph)
                tf.import_graph_def(od_graph_def, name='')

            self.sess = tf.Session(graph=detection_graph)

        # Define input and output tensors (i.e. data) for the object detection classifier

        # Input tensor is the image
        self.image_tensor = detection_graph.get_tensor_by_name('image_tensor:0')

        # Output tensors are the detection boxes, scores, and classes
        # Each box represents a part of the image where a particular object was detected
        self.detection_boxes = detection_graph.get_tensor_by_name('detection_boxes:0')

        # Each score represents level of confidence for each of the objects.
        # The score is shown on the result image, together with the class label.
        self.detection_scores = detection_graph.get_tensor_by_name('detection_scores:0')
        self.detection_classes = detection_graph.get_tensor_by_name('detection_classes:0')

        # Number of objects detected
        self.num_detections = detection_graph.get_tensor_by_name('num_detections:0')

        self.makingInference = False

        (self.boxes, self.scores, self.classes, self.num) = self.detect(np.zeros((1, 480, 640, 3)))
        self.runnedOnce = False

    def detectThread(self, frame):
        if(not self.makingInference):
            t = threading.Thread(target=self.detect, args=(frame,))
            t.daemon = True
            t.start()

    def detect(self, frame):
        self.makingInference = True
        (self.boxes, self.scores, self.classes, self.num) = self.sess.run(
            [self.detection_boxes, self.detection_scores, self.detection_classes, self.num_detections],
            feed_dict={self.image_tensor: frame})
        self.makingInference = False
        self.runnedOnce = True
        return (self.boxes, self.scores, self.classes, self.num)

    def getResults(self):
        return (self.boxes, self.scores, self.classes, self.num)

    def drawDetectionsOnFrame(self, frame, thresh=0.6):
        if(self.makingInference or not self.runnedOnce):
            return
        vis_util.visualize_boxes_and_labels_on_image_array(
            frame,
            np.squeeze(self.boxes),
            np.squeeze(self.classes).astype(np.int32),
            np.squeeze(self.scores),
            self.category_index,
            use_normalized_coordinates=True,
            line_thickness=8,
            min_score_thresh=thresh)

    def getDetectionsCords(self, frame, thresh=0.6):
        if(self.makingInference or not self.runnedOnce):
            return
        coordinates = vis_util.return_coordinates(
                            frame,
                            np.squeeze(self.boxes),
                            np.squeeze(self.classes).astype(np.int32),
                            np.squeeze(self.scores),
                            self.category_index,
                            use_normalized_coordinates=True,
                            line_thickness=8,
                            min_score_thresh=thresh)
        return coordinates

# Set up camera constants
#IM_WIDTH = 1280
#IM_HEIGHT = 720

### Picamera ###
if __name__ == '__main__':
    print('Inicio do Programa')
    frame_rate_calc = 1
    freq = cv2.getTickFrequency()
    font = cv2.FONT_HERSHEY_SIMPLEX
    
    detector = ObjectDetector()

    # Initialize USB webcam feed
    camera = cv2.VideoCapture(0)
    ret = camera.set(3,detector.IM_WIDTH)
    ret = camera.set(4,detector.IM_HEIGHT)

    while(True):

        t1 = cv2.getTickCount()

        # Acquire frame and expand frame dimensions to have shape: [1, None, None, 3]
        # i.e. a single-column array, where each item in the column has the pixel RGB value
        ret, frame = camera.read()
        frame_expanded = np.expand_dims(frame, axis=0)

        # Perform the actual detection by running the model with the image as input
        (boxes, scores, classes, num) = detector.detect(frame_expanded)

        # Draw the results of the detection (aka 'visulaize the results')
        detector.drawDetectionsOnFrame(frame, thresh=0.3)

        cv2.putText(frame,"FPS: {0:.2f}".format(frame_rate_calc),(30,50),font,1,(255,255,0),2,cv2.LINE_AA)
        
        # All the results have been drawn on the frame, so it's time to display it.
        cv2.imshow('Object detector', frame)

        t2 = cv2.getTickCount()
        time1 = (t2-t1)/freq
        frame_rate_calc = 1/time1

        # Press 'q' to quit
        if cv2.waitKey(1) == ord('q'):
            break

    camera.release()

    cv2.destroyAllWindows()