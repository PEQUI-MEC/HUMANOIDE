import time
import threading

import numpy as np
import struct

def translate(value, leftMin, leftMax, rightMin, rightMax):
    # Figure out how 'wide' each range is
    leftSpan = leftMax - leftMin
    rightSpan = rightMax - rightMin

    # Convert the left range into a 0-1 range (float)
    valueScaled = float(value - leftMin) / float(leftSpan)

    # Convert the 0-1 range into a value in the right range.
    return rightMin + (valueScaled * rightSpan)

class Servo:
    def __init__(self, step=1, delay = 0.01, angle_min_max=(-35,35), tolerancia=2):

        self.step = step
        self.angle_min_max = angle_min_max
        self.delay = delay

        self.target_angle_var = 0 #variação do angulo a ser movido e levado

        self.abs_angle = 0 #Sempre atulizado pela comunicação
        self.rel_angle = 0 #Sempre atulizado pela comunicação
        
        self.abs_angle_snapshot = 0 #Atualizado pela função snapshot do gimbal
        self.abs_angle_target = 0 #Atualizado pela função setTarget() do gimbal / O enviado de volta para o controle

        self.tolerancia = tolerancia

    def moveToRelAngleBlocked(rel_angle_target):
        while(True):
            if(self.rel_angle >= rel_angle_target-self.tolerancia or self.rel_angle <= rel_angle_target+self.tolerancia):
                break
            else:
                self.abs_angle_target = self.abs_angle
                self.target_angle_var = rel_angle_target-rel_angle
            time.sleep(self.delay)

class Gimbal():
    def __init__(self, servoPan, servoTilt, delay = 0.001):
        self.servoTilt = servoTilt
        self.servoPan = servoPan
        self.searchTilt_target = 0.2
        self.statesPan = np.linspace(-1,1,7)
        self.runned_states = []

    def snapshot(self):
        self.servoTilt.abs_angle_snapshot = self.servoTilt.abs_angle
        self.servoPan.abs_angle_snapshot = self.servoPan.abs_angle
        
    def setTarget(self):
        self.servoTilt.abs_angle_target = self.servoTilt.abs_angle_snapshot
        self.servoPan.abs_angle_target = self.servoPan.abs_angle_snapshot

    def search(self):
        tilt_angle = self.servoTilt.angle_min_max[1]
        pan_angle = self.servoPan.angle_min_max[1]
        self.servoTilt.moveToRelAngleBlocked(self.searchTilt_target*tilt_angle)

        for state in self.statesPan:
            if state not in runned_states:
                self.servoPan.moveToRelAngleBlocked(state*pan_angle)
                return True
        
        return False

    def restartSearch(self):
        self.runned_states = []
        

if __name__ == "__main__":
    tilt = Servo(angle_min_max=(-35,35),delay = 0.0075)
    pan = Servo(angle_min_max=(-90,90),delay = 0.0025)
    gimbal = Gimbal(pan,tilt)
    #pan.loop()
    #tilt.loop()
    gimbal.run()
    pan.moveToAngle(60)
    
    while True:
        for i in range(-90,90,1):
            pan.moveToAngle(i)
            time.sleep(0.1)
        
    
