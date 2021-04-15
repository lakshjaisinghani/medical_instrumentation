clear all;
close all;
clc;

load ECG_Graph2.mat

%% ECG signal sample
Fs = 2*10^3;

%ECG signal specification
seg_start = 110000;            % random sample start
ECG_signal = data(:, 1);       % use only 5 minute data 

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
xlabel("Time (s)")
ylabel("Amplitude (mV)")
title("ECG signal")
ylim([1.5, 2.1])
xlim([0, 310])
hold on

%% 5 sec average HR interval extraction
R_peaks    = islocalmax(ECG_signal_filtered) & (ECG_signal_filtered > 1.9);
peak_times = time(R_peaks);
ECG_peaks  = ECG_signal_filtered(R_peaks);
plot(peak_times, ECG_peaks, 'r*')
legend("ECG Signal", "R-Peaks")

% calculate heart rate
range = 5:5:310; % 5 min
avg_hr = find_avg_hr(ECG_signal_filtered, time, range, 1.9, false);

figure; % plot
plot(range, avg_hr)
xlabel("Time (s)")
ylabel("Heart Rate (bpm)")
xlim([5, 310])
ylim([60, 75])
title("Heart Rate (5s average)")

%% plot the R-R interval
avg_rr_interval = diff(peak_times);
rt = data(:, 2);

% filter specs
window_size = 10; 
b = (1/window_size)*ones(1,window_size);
a = 1; 

avg_rr_interval = filter(b,a,avg_rr_interval);
avg_rr_interval = avg_rr_interval(22:end);

figure;
stairs(avg_rr_interval)
xlabel("Time (s)")
ylabel("R-R interval (s)")
title("R-R interval")

%% FFT of R-R intervals

% remove large signal offset
rr_signal = avg_rr_interval - mean(avg_rr_interval);

% FFT variables
n = length(rr_signal);
fshift = (-n/2:n/2-1)*(5/n); 

% do an FFT and shift frequencies
fft_rr = fftshift(fft(rr_signal));
p = abs(fft_rr).^2 * (1/n); % mV^2

figure;
bar(fshift, p)
ylim([0, 0.18])
xlim([-0.8, 0.8])
xlabel("Frequency (Hz)")
ylabel("Magnitude (mV^2)")
title("FFT of R-R Interval")


