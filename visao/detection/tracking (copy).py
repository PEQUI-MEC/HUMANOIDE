######## Webcam Object Detection Using Tensorflow-trained Classifier #########
#
# Author: Evan Juras
# Date: 1/20/18
# Description: 
# This program uses a TensorFlow-trained classifier to perform object detection.
# It loads the classifier uses it to perform object detection on a webcam feed.
# It draws boxes and scores around the objects of interest in each frame from
# the webcam.

## Some of the code is copied from Google's example at
## https://github.com/tensorflow/models/blob/master/research/object_detection/object_detection_tutorial.ipynb

## and some is copied from Dat Tran's example at
## https://github.com/datitran/object_detector_app/blob/master/object_detection_app.py

## but I changed it to make it more understandable to me.

import json
# Import packages
import os
import sys
import time
import math
import numpy as np

import cv2
import imutils
import tensorflow as tf
#imutils
from imutils.video import FPS, VideoStream
# Import utilites
from object_detection.utils import label_map_util
from object_detection.utils import visualization_utils as vis_util

from utils.servo_gimbal import Servo, Gimbal
from utils.servo_gimbal import translate

#Trackers

OPENCV_OBJECT_TRACKERS = {
		"csrt": cv2.TrackerCSRT_create,
		"kcf": cv2.TrackerKCF_create,
		"boosting": cv2.TrackerBoosting_create,
		"mil": cv2.TrackerMIL_create,
		"tld": cv2.TrackerTLD_create,
		"medianflow": cv2.TrackerMedianFlow_create,
		"mosse": cv2.TrackerMOSSE_create
	}

tracker = OPENCV_OBJECT_TRACKERS['csrt']()

initBB = None

# Name of the directory containing the object detection module we're using
MODEL_NAME = 'model_dir'

# Grab path to current working directory
CWD_PATH = os.getcwd()

# Path to frozen detection graph .pb file, which contains the model that is used
# for object detection.
PATH_TO_CKPT = os.path.join(CWD_PATH,'models',MODEL_NAME,'frozen_inference_graph.pb')

# Path to label map file
PATH_TO_LABELS = os.path.join(CWD_PATH,'models',MODEL_NAME,'label_map.pbtxt')

# Number of classes the object detector can identify
NUM_CLASSES = open(PATH_TO_LABELS, 'r').read().count('item')

## Load the label map.
# Label maps map indices to category names, so that when our convolution
# network predicts `5`, we know that this corresponds to `king`.
# Here we use internal utility functions, but anything that returns a
# dictionary mapping integers to appropriate string labels would be fine
label_map = label_map_util.load_labelmap(PATH_TO_LABELS)
categories = label_map_util.convert_label_map_to_categories(label_map, max_num_classes=NUM_CLASSES, use_display_name=True)
category_index = label_map_util.create_category_index(categories)

# Load the Tensorflow model into memory.
detection_graph = tf.Graph()
with detection_graph.as_default():
    od_graph_def = tf.GraphDef()
    with tf.gfile.GFile(PATH_TO_CKPT, 'rb') as fid:
        serialized_graph = fid.read()
        od_graph_def.ParseFromString(serialized_graph)
        tf.import_graph_def(od_graph_def, name='')

    sess = tf.Session(graph=detection_graph)


# Define input and output tensors (i.e. data) for the object detection classifier

# Input tensor is the image
image_tensor = detection_graph.get_tensor_by_name('image_tensor:0')

# Output tensors are the detection boxes, scores, and classes
# Each box represents a part of the image where a particular object was detected
detection_boxes = detection_graph.get_tensor_by_name('detection_boxes:0')

# Each score represents level of confidence for each of the objects.
# The score is shown on the result image, together with the class label.
detection_scores = detection_graph.get_tensor_by_name('detection_scores:0')
detection_classes = detection_graph.get_tensor_by_name('detection_classes:0')

# Number of objects detected
num_detections = detection_graph.get_tensor_by_name('num_detections:0')

# Initialize webcam feed
#vs = cv2.vsCapture(0)
#ret = vs.set(3,1280)
#ret = vs.set(4,720)
tilt = Servo(angle_min_max=(-35,35),delay = 0.1)
pan = Servo(angle_min_max=(-90,90),delay = 0.0025,step=20)
gimbal = Gimbal(pan,tilt)
gimbal.run()
tilt.moveToAngle(20)

vs = VideoStream(False).start()
time.sleep(1.0)
old_centroid = (0,0)
fps = FPS().start()
fps.update()
fps.stop()
while(True):

    # Acquire frame and expand frame dimensions to have shape: [1, None, None, 3]
    # i.e. a single-column array, where each item in the column has the pixel RGB value
    frame = vs.read()
    frame_expanded = np.expand_dims(frame, axis=0)
    (H, W) = frame.shape[:2]

    # initialize the set of information we'll be displaying on
    # the frame
    info = [
        ("Algorithm", 'Neural net'),
        ("FPS", "{:.2f}".format(fps.fps())),
    ]

    # check to see if we are currently tracking an object
    if initBB is not None:
        # grab the new bounding box coordinates of the object
        (success, box) = tracker.update(frame)

        # check to see if the tracking was a success
        if success:
            (x, y, w, h) = [int(v) for v in box]
            cv2.rectangle(frame, (x, y), (x + w, y + h),
                (0, 255, 0), 2)

            centroid = ((x+x+w)/2,(y+y+h)/2)
            distance_var = np.sqrt(((centroid[0]-old_centroid[0])**2)+(centroid[1]-old_centroid[1])**2)
            #print("centroid={}".format(centroid))
            angle_horizontal = translate(centroid[0], 0, W, -78/2, 78/2)
            angle_vertical = translate(centroid[1], 0, H, -48/2, 48/2)
            if(abs(angle_horizontal) > 5):
                pan.moveToAngle(pan.getAngle()-angle_horizontal)
            if(abs(angle_vertical) > 3):
                tilt.moveToAngle(tilt.getAngle()+angle_vertical)
            
        else:
            continue

        info[0] = ("Algorithm", 'tracker')

    else:
        # Perform the actual detection by running the model with the image as input
        (boxes, scores, classes, num) = sess.run(
            [detection_boxes, detection_scores, detection_classes, num_detections],
            feed_dict={image_tensor: frame_expanded})

        # Draw the results of the detection (aka 'visulaize the results')
        vis_util.visualize_boxes_and_labels_on_image_array(
            frame,
            np.squeeze(boxes),
            np.squeeze(classes).astype(np.int32),
            np.squeeze(scores),
            category_index,
            use_normalized_coordinates=True,
            line_thickness=8,
            min_score_thresh=0.60)
        
        coordinates = vis_util.return_coordinates(
                            frame,
                            np.squeeze(boxes),
                            np.squeeze(classes).astype(np.int32),
                            np.squeeze(scores),
                            category_index,
                            use_normalized_coordinates=True,
                            line_thickness=8,
                            min_score_thresh=0.60)
        for detection in coordinates:
            if(detection[-1] > 90):
                print(detection)
                initBB = (detection[3],detection[1],abs(detection[4]-detection[3]),abs(detection[2]-detection[1])) #trial and error
                print(initBB)
                tracker.init(frame, initBB)
                fps = FPS().start()
                pan.step = 1
                pan.delay = 0.1
                tilt.delay = 0.5
                time.sleep(2)
                # All the results have been drawn on the frame, so it's time to display it.
        
        if initBB is None:
            pan.loopByStep()
            time.sleep(1)

    # update the FPS counter
    fps.update()
    fps.stop()

    # loop over the info tuples and draw them on our frame
    for (i, (k, v)) in enumerate(info):
        text = "{}: {}".format(k, v)
        cv2.putText(frame, text, (10, H - ((i * 20) + 20)),
            cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 0, 255), 2)

    # All the results have been drawn on the frame, so it's time to display it.
    cv2.imshow('Object detector', frame)

    # Press 'q' to quit
    if cv2.waitKey(1) == ord('q'):
        break


# Clean up

vs.release()
cv2.destroyAllWindows()
