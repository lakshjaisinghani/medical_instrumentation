clear all;
close all;
clc;

%% import raw sensor data
data =  xlsread("raw data including emg.xlsx");

time = data(1, :)/70;
AccX = data(2, :);
AccY = data(3, :);
AccZ = data(4, :);


%% Average peak acceleration at heal strike (y-axis)
acc_peaks  = islocalmax(AccY) & (AccY > 2);
peak_times = time(acc_peaks);
peak_vals  = AccY(acc_peaks);

avg_peak_acc = mean(peak_vals); % m/s

figure;
plot(time, AccY);
hold on;
plot(peak_times, peak_vals, 'r*');
legend("Y acceleration (G's)", "heel strikes");

%% Stride length (time and meters)
temp_avg = ones(1, length(peak_times));

for i = 2:length(peak_times)
    temp = peak_times(i) - peak_times(i-1);
    
    if temp > 0.5
        temp_avg()
    end
    
end

avg_time = mean(temp_avg);


