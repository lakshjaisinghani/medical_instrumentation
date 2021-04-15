clear all;
close all;
clc;

%% import raw sensor data
data =  xlsread("raw data including emg.xlsx");

time = data(1, :)/70;
AccX = data(2, :);
AccY = data(3, :);
AccZ = data(4, :);
EMG  = data(5, :);

%% ploting data
figure;
subplot(3, 1, 1);
plot(time, AccX, 'r')
title("X Acceleration");
ylabel("Acc (G)")
xlabel("Time (s)")
subplot(3, 1, 2);
plot(time, AccY, 'g')
title("Y Acceleration");
ylabel("Acc (G)")
xlabel("Time (s)")
subplot(3, 1, 3);
plot(time, AccZ, 'b')
title("Z Acceleration");
ylabel("Acc (G)")
xlabel("Time (s)")

%% Average peak acceleration during heal strikes (y-axis)
acc_peaks  = islocalmax(AccY) & (AccY > 2);
peak_times = time(acc_peaks);
peak_vals  = AccY(acc_peaks);

% find errored readings
outlier_ind = [];
for i  = 2:length(peak_times)
    if peak_times(i) - peak_times(i-1) < 0.5
        outlier_ind(end + 1) = i-1;
    end
end

% remove outliers
peak_times(outlier_ind) = [];
peak_vals(outlier_ind)  = [];

avg_peak_acc = mean(peak_vals); % m/s^2

figure;
plot(time, AccY);
hold on;
plot(peak_times, peak_vals, 'r*');
legend("Y acceleration (G's)", "heel strikes");
title("Y Acceleration");
ylabel("Acc (G)")
xlabel("Time (s)")

%% Filter AccX signal
Fs = 70;
n = length(AccX);
AccX = AccX * 9.8;

% FFT (for visualisation only)
fshift = (-n/2:n/2-1)*(Fs/n); 
fft_AccX = fftshift(abs(fft(AccX)));

% filter out DC offset frequency noise
f_AccX = highpass(AccX,1,Fs);
f_AccX = lowpass(f_AccX,30,Fs);
fft_AccX_filtered = fftshift(abs(fft(f_AccX))); % (for visualisation only)

% plot
figure;
subplot(2, 1, 1)
plot(time, AccX, 'r')
title("X Acceleration");
ylabel("Acc (m/s^2)")
xlabel("Time (s)")

subplot(2, 1, 2)
plot(time, f_AccX, 'b')
title("X Acceleration Filtered");
ylabel("Acc (m/s^2)")
xlabel("Time (s)")

%% Stride length (time and meters)
% time -> 2.58s (from above)
% length -> 1.2m

% trim to take stride section (x acceleration peak-peak) only
peak_ind  = find(acc_peaks == 1);
AccX_trim = f_AccX(peak_ind(1) - 5:peak_ind(2)); % -5 for shifting  few samples back
time_trim = time(peak_ind(1) - 5:peak_ind(2));

% integrate to find velocity
vel_x  = detrend(cumtrapz(time_trim, AccX_trim)); % detrend sensor shift
vel_x = vel_x + (-1*min(vel_x)); % remove negative values
dist_x = cumtrapz(time_trim, vel_x); % integrate again to find distance 

stride_length = dist_x(end);

%% Step Length
% The step length should be approximately half the stride length.
step_length = stride_length/2;

% step time calculation
step_times = [];
for i  = 2:length(peak_times)
    step_times(end+1) = peak_times(i) - peak_times(i-1);
end
gait_cycle = mean(step_times);
step_length = gait_cycle/2;

%% Gait frequency
gait_frequency = 1/gait_cycle;













