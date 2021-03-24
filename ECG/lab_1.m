clear all;
close all;
clc;

load ECG_Graph2.mat
data = data(:, 1);     % use only 5 minute data

%% ECG signal sample
Fs = 2*10^3;

%ECG signal specification
seg_start = 110000; % random sample start
ECG_signal = data(seg_start:seg_start+(22*Fs)-1); % 22 sec ECG signal taken
                                                  % due to padding issue
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
xlim([0, 20])
hold on
R_peaks    = islocalmax(ECG_signal_filtered) & (ECG_signal_filtered > 1.9);
peak_times = time(R_peaks);
ECG_peaks  = ECG_signal_filtered(R_peaks);
plot(peak_times, ECG_peaks, 'r*')
legend("ECG Signal", "R-Peaks")

%% R-R interval extraction
avg_RR_intervals = ones(1, 20);

% pad signal to avoid moving average edge case
ECG_signal_filtered = [ECG_signal_filtered' zeros(1, Fs*5)];

for i = 1:Fs:(20*Fs + Fs)
    section = ECG_signal_filtered(i:i+5*Fs-1);    % 1 sec -> 5 sec avg
    R_peaks    = islocalmax(section) & (section > 1.9);
    peak_times = time(R_peaks);
    
    if i == 1
        avg_RR_intervals(i) = mean(diff(peak_times));
    else
        avg_RR_intervals((i-1)/Fs) = mean(diff(peak_times));
    end
end

figure;
avg_hr = (1./avg_RR_intervals).* 60; % BPM
plot(avg_hr)
xlabel("Seconds (s)")
ylabel("Heart Rate (bpm)")
title("Heart Rate")
xlim([1, 20])







