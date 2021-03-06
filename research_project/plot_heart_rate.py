import serial
import numpy as np
import matplotlib.pyplot as plt
from drawnow import *
import time
import re
import csv
import scipy.signal as signal
plt.ion()

thresh = 10    

ECG_data = []
HR_data  = []
HR_print = []
arduinoData = serial.Serial('/dev/ttyACM0', 9600)

cnt = 0
cnt_hr_1 = 0
cnt_hr_2 = 0

curr_peak = 0
prev_peak = 0

start_time = 0
end_time   = 0
switch     = 0

def makeFig():
    plt.ylim(0,150)                               
    plt.title('Current Heart Rate: ' + str(round(HR_print[-1])) + 'BPM')     
    plt.grid(True)                                 
    plt.ylabel('Heart Rate')                            
    plt.plot(HR_print, 'ro-', label='BPM')      
    plt.legend(loc='upper left')                    

with open("ecg.csv", 'w', newline='') as file :
    writer = csv.writer(file)
    writer.writerow(['Time', 'ECG'])

while True:
    while (arduinoData.inWaiting()==0): 
        pass 
    
    try:
        arduinoString = str(arduinoData.readline())
        
        ECG = float(arduinoString[2:6])
        ECG = ECG * ECG

        if ECG:
            ECG_data.append(ECG)

            with open("ecg.csv", 'a', newline='') as file :
                writer = csv.writer(file)
                writer.writerow([time.time(), ECG])

        peaks, _ = signal.find_peaks(np.array(ECG_data), distance=10)

        
        if ECG_data[peaks[0]] > thresh:
            curr_peak = ECG_data[peaks[0]]

        HR = 0
        if curr_peak != prev_peak and switch:
            start_time = time.time()
            switch = 0 
            prev_peak = curr_peak

        if curr_peak != prev_peak and not switch:
            HR = (1/(time.time() - start_time)) * 60
            switch = 1 
            prev_peak = curr_peak

        if HR > 30 and HR < 200:
            HR_data.append(HR)


            cnt_hr_1 += 1
            if cnt_hr_1 > 7:
                HR_data.pop(0)
            
            mean_hr = np.mean(np.array(HR_data))
            HR_print.append(mean_hr)

            cnt_hr_2 += 1
            if cnt_hr_2 > 10:
                HR_print.pop(0)

            if len(HR_print) > 1:
                drawnow(makeFig)
                plt.pause(.000001) 

        cnt += 1
        if cnt > 50:
            ECG_data.pop(0)
            
    except:
        pass

