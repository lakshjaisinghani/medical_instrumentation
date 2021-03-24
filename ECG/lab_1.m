clear all;
close all;
clc;

load ECG_Graph2.mat
data = data(:, 1);     % use only 5 minute data

%% ECG signal sample
Fs = 2*10^3;

%ECG signal specification
seg_start = 110000;                               % random sample start
ECG_signal = data(seg_start:seg_start+(20*Fs)-1); % 20 sec ECG signal  

% time specification
time = 0:1/Fs:length(ECG_signal)/Fs-1/Fs;         


%% Clean signal
% filter specs
window_size = 50; 
b = (1/window_size)*ones(1,window_size);
a = 1; 

ECG_signal_filtered = filter(b,a,ECG_signal);

% plot ECG
plot(time, ECG_signal_filtered)
xlabel("Seconds (s)")
ylabel("Amplitude (mV)")
title("ECG signal")
ylim([1.5, 2.1])
hold on

%% R-R interval extraction
R_peaks    = islocalmax(ECG_signal_filtered) & (ECG_signal_filtered > 1.9);
peak_times = time(R_peaks);
ECG_peaks  = ECG_signal_filtered(R_peaks);
plot(peak_times, ECG_peaks, 'r*')
legend("ECG Signal", "R-Peaks")

% calculate heart rate
range = [5 10 15 20];
avg_hr = find_avg_hr(ECG_signal_filtered, time, range, 1.9, false);

figure; % plot
stairs(range, avg_hr)





