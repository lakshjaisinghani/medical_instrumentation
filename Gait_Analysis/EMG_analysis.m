clear all;
close all;
clc;

%% import raw sensor data
data =  xlsread("raw data including emg.xlsx");

time = data(1, :)/70;
EMG  = data(5, :);

%%
figure;
plot(time, EMG)
title("EMG Data")
ylabel("EMG")
xlim([10.5, 28])
xlabel("Time (s)")

%%
Fs = 70;
n = length(EMG);

% filter out DC offset frequency noise
% f_EMG = highpass(EMG,1,Fs);
f_EMG = lowpass(EMG,10,Fs);

% FFT (for visualisation only)
fshift = (-n/2:n/2-1)*(Fs/n); 
fft_EMG = fftshift(abs(fft(f_EMG)))/(10^3);

figure;
plot(fshift, fft_EMG);
title("Filtered frequency spectrum")
xlabel("Frequency (Hz)")
xlabel("Magnitude (dB)")
