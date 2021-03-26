clear all;
close all;
clc;

load ECG_Graph2.mat
data = data(:, 1);     % use only 5 minute data

%% ECG signal sample
Fs = 2*10^3;

%ECG signal specification
seg_start = 100000; % random sample start
ECG_signal = data(seg_start:seg_start+(222*Fs)-1); % 22 sec ECG signal taken
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
xlim([60, 80])
hold on
R_peaks    = islocalmax(ECG_signal_filtered) & (ECG_signal_filtered > 1.9);
peak_times = time(R_peaks);
ECG_peaks  = ECG_signal_filtered(R_peaks);
plot(peak_times, ECG_peaks, 'r*')
legend("ECG Signal", "R-Peaks")

%% R-R interval extraction
avg_RR_intervals = ones(1, 220);

% pad signal to avoid moving average edge case
ECG_signal_filtered = [ECG_signal_filtered' zeros(1, Fs*5)];
time                = [time zeros(1, Fs*5)];

for i = 1:Fs:(220*Fs + Fs)
    ECG_section = ECG_signal_filtered(i:i+5*Fs-1);    % 1 sec -> 5 sec avg
    time_section = time(i:i+5*Fs-1);
    R_peaks    = islocalmax(ECG_section) & (ECG_section > 1.9);
    peak_times = time_section(R_peaks);

    if i == 1
        avg_RR_intervals(i) = mean(diff(peak_times));
    else
        avg_RR_intervals(((i-1)/Fs) + 1) = mean(diff(peak_times));
    end
end

figure;
avg_hr = (1./avg_RR_intervals).* 60; % BPM

window_size = 25; 
b = (1/window_size)*ones(1,window_size);
cleaned_signal = filter(b,a,avg_hr);

plot(cleaned_signal)
xlabel("Seconds (s)")
ylabel("Heart Rate (bpm)")
title("Heart Rate")
xlim([60, 80])
ylim([65, 75])







