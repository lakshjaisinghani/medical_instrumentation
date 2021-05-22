import serial
import numpy as np
import matplotlib.pyplot as plt
from drawnow import *
import time
import re


HR_data  = []
ECG_data = []
arduinoData = serial.Serial('/dev/ttyACM0', 9600) #Creating our serial object named arduinoData
plt.ion() #Tell matplotlib you want interactive mode to plot live data
cnt=0

def makeFig(): #Create a function that makes our desired plot
    plt.ylim(0,200)                                 #Set y min and max values
    plt.title('Current Heart Rate: ' + str(round(HR_data[-1])) + 'BPM')      #Plot the title
    plt.grid(True)                                  #Turn the grid on
    plt.ylabel('Heart Rate')                            #Set ylabels
    plt.plot(HR_data, 'ro-', label='BPM')       #plot the height array
    plt.legend(loc='upper left')                    #plot the legend

ECG_bucket = 0
hit_max = 0

while True:
    while (arduinoData.inWaiting()==0): #Wait here until there is data
        pass #do nothing
    arduinoString = str(arduinoData.readline())
    try:
        ECG = float(arduinoString[2:6])
        ECG_data.append(ECG)

        if ECG > 3:
            if hit_max:
                hr_det_end = time.time()
                HR = (hr_det_end - hr_det_start) * 60
                if HR > 40:
                    HR_data.append(HR)
                else:
                    HR = None
                hit_max = 0

            hr_det_start = time.time()
            hit_max = 1

        
        if HR:
            print(HR)
            drawnow(makeFig)
            plt.pause(.000001) 
            cnt=cnt+1
            if(cnt>20):                            
                HR_data.pop(0)                       
    except:
        pass