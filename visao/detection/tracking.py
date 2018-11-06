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
#imutils
from imutils.video import FPS, VideoStream
# Import utilites

from communication import Communication

from utils.servo_gimbal import Servo, Gimbal
from utils.servo_gimbal import translate

from detection import ObjectDetector

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

objectDetector = ObjectDetector(MODEL_NAME='model_dir')

# Initialize webcam feed
#vs = cv2.vsCapture(0)
#ret = vs.set(3,1280)
#ret = vs.set(4,720)
tilt = Servo(angle_min_max=(-35,35),delay = 0.1)
pan = Servo(angle_min_max=(-90,90),delay = 0.0025,step=20)
gimbal = Gimbal(pan,tilt)
#gimbal.run()
#tilt.moveToAngle(20)

flags = {
		"search": 1,
		"ball": 0,
		"turn90": 0,
	}

c = Communication(gimbal, flags)
c.start()

print('Iniciando camera')

vs = VideoStream(False).start()
time.sleep(1.0)
frame = vs.read()
time.sleep(1.0)
fps = None
algorithm = 'None'
print('Agoritimo de tracking.py executando')
while(True):

    # Acquire frame and expand frame dimensions to have shape: [1, None, None, 3]
    # i.e. a single-column array, where each item in the column has the pixel RGB value
    frame = vs.read()
    frame_expanded = np.expand_dims(frame, axis=0)
    (H, W) = frame.shape[:2]
    print(frame_expanded.shape)

    gimbal.snapshot()

    # initialize the set of information we'll be displaying on
    # the frame

    # check to see if we are currently tracking an object
    if initBB is not None:
        # grab the new bounding box coordinates of the object
        #objectDetector.detectThread(frame_expanded)
        (success, box) = tracker.update(frame)

        # check to see if the tracking was a success
        if success:
            #Get init cord
            (x, y, w, h) = [int(v) for v in box]
            #draw on frame bouding box
            cv2.rectangle(frame, (x, y), (x + w, y + h),
                (0, 255, 0), 2)

            centroid = ((x+x+w)/2,(y+y+h)/2)

            angle_horizontal = translate(centroid[0], 0, W, -78/2, 78/2)
            angle_vertical = translate(centroid[1], 0, H, -48/2, 48/2)

            gimbal.setTarget()
            if(abs(angle_horizontal) > 5):
                pan.target_angle_var = angle_horizontal
            if(abs(angle_vertical) > 3):
                tilt.target_angle_var = angle_vertical
            
        else:
            continue

        

        algorithm = 'tracker'

    else:
        algorithm = 'Neural-Net'
        # Perform the actual detection by running the model with the image as input
        objectDetector.detectThread(frame_expanded)
        while(objectDetector.makingInference):
            time.sleep(0.005)

        (boxes, scores, classes, num) = objectDetector.getResults()

        # Draw the results of the detection (aka 'visulaize the results')
        objectDetector.drawDetectionsOnFrame(frame)
        
        coordinates = objectDetector.getDetectionsCords(frame)

        for detection in coordinates:
            if(detection[-1] > 1):
                print(detection)
                initBB = (detection[3],detection[1],abs(detection[4]-detection[3]),abs(detection[2]-detection[1])) #trial and error
                print(initBB)
                tracker.init(frame, initBB)
                fps = FPS().start()
                pan.step = 1
                pan.delay = 0.08
                tilt.delay = 0.08
                flags['search'] = 0
                flags['ball'] = 1
                # All the results have been drawn on the frame, so it's time to display it.
        
        if initBB is None:
            """if(not gimbal.search()):
                flags['turn90'] = 1
                while(controlador_state != 'TURN90'):
                    time.sleep(0.01)
                flags['turn90'] = 0
                while(controlador_state != 'IDDLE'):
                    time.sleep(0.01)"""
        

    if(fps is None):
        fps = FPS().start()

    # update the FPS counter
    fps.update()
    fps.stop()

    info = [
        ("Algorithm", algorithm),
        ("FPS", "{:.2f}".format(fps.fps())),
    ]

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

    print(pan.target_angle_var,tilt.target_angle_var,pan.old_angle,tilt.old_angle)

# Clean up

vs.release()
cv2.destroyAllWindows()
