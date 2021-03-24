function avg_hr = find_avg_hr(ECG, time, range, thresh, verbose)
% params:
% ECG     - the ecg signal
% range   - hr average range in seconds
% thresh  - threshold to clasify R-peak
% verbose - plot

R_peaks    = islocalmax(ECG) & (ECG > thresh);
peak_times = time(R_peaks);
ECG_peaks  = ECG(R_peaks);

if verbose
    plot(peak_times, ECG_peaks, 'r*')
    legend("ECG Signal", "R-Peaks")
end

% calculate heart rate
avg_rr_interval = ones(1, length(range));

for i = 1:length(range)
    sum = 0;
    cnt = 0;
    for j = 2:length(peak_times)
        if peak_times(j) < range(i)
            sum = sum + (peak_times(j) - peak_times(j-1));
            cnt = cnt + 1;
        end
    end
    avg_rr_interval(i) = sum/cnt;    % 1 beat -> sec
end

avg_hr = (1./avg_rr_interval).* 60; % BPM

end
