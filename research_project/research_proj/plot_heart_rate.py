import serial
import numpy as np
import matplotlib.pyplot as plt
from drawnow import *
import time
import re
import scipy.signal as signal

ECG_data = []
arduinoData = serial.Serial('/dev/ttyACM0', 9600)
cnt = 0
curr_peak = 0
prev_peak = 0

start_time = 0
end_time   = 0
switch     = 0

while True:
    while (arduinoData.inWaiting()==0): 
        pass 
    
    arduinoString = str(arduinoData.readline())
    
    try:
        ECG = float(arduinoString[2:6])
    except:
        ECG = None

    if ECG:
        ECG_data.append(ECG)

    peaks, _ = signal.find_peaks(np.array(ECG_data), distance=10)

    
    try:
        if ECG_data[peaks[0]] > 3:
            curr_peak = ECG_data[peaks[0]]
    except:
        pass

    HR = 0
    if curr_peak != prev_peak and switch:
        start_time = time.time()
        switch = 0 
        prev_peak = curr_peak

    if curr_peak != prev_peak and not switch:
        HR = (time.time() - start_time) * 60
        switch = 1 
        prev_peak = curr_peak

    if HR:
        print(HR)

    cnt += 1
    if cnt > 50:
        ECG_data.pop(0)

