function [n_peaks, freq] = peak_analysis(data)

% Determine fixed sign intervals.
r_plus_starts = [];
r_plus_ends = [];
r_minus_starts = [];
r_minus_ends = [];

% Treat boundary condition.
if data(1) < 0
    r_minus_starts = [r_minus_starts 1];
else
    r_plus_starts = [r_plus_starts 1];
end
if data(end) < 0
    r_minus_ends = [r_minus_ends length(data)];
else
    r_plus_ends = [r_plus_ends length(data)];
end

for i = 2 : length(data) - 1
    if data(i) <= 0 && data(i+1) > 0
        r_plus_starts = [r_plus_starts i];
    end
    if data(i) < 0 && data(i+1) >= 0
        r_minus_ends = [r_minus_ends i-1];
    end
    if data(i) >= 0 && data(i+1) < 0
        r_minus_starts = [r_minus_starts i];
    end
    if data(i) > 0 && data(i+1) <= 0
        r_plus_ends = [r_plus_ends i-1];
    end
end

% Integrate sign-fixed intervals and throw away peaks with too low absolute values.
thresh_area = 100;
ispeaks_num = length(r_plus_starts) ;
% r_plus_starts_out = r_plus_starts;
% r_plus_ends_out = r_plus_ends;
% r_minus_starts_out = r_minus_starts;
% r_minus_ends_out = r_minus_ends;
not_peaks_i = [];
for i = 1 : ispeaks_num
    sum = cumsum(data(r_plus_starts(i) : r_plus_ends(i)));
    if sum < thresh_area
        % r_plus_starts_out(i) = [];
        % r_plus_ends_out(i) = [];
        not_peaks_i = [not_peaks_i i];
    end
end
r_plus_starts(not_peaks_i) = [];
r_plus_ends(not_peaks_i) = [];

ispeaks_num = length(r_minus_starts);
not_peaks_i = [];
for i = 1 : ispeaks_num
    sum = cumsum(abs(data(r_minus_starts(i) : r_minus_ends(i))));
    if sum < thresh_area
        % r_minus_starts_out(i) = [];
        % r_minus_ends_out(i) = [];
        not_peaks_i = [not_peaks_i i];
    end
end
r_minus_starts(not_peaks_i) = [];
r_minus_ends(not_peaks_i) = [];

r_minus_starts
r_minus_ends
r_plus_starts
r_plus_ends
not_peaks_i

% Find out extremums on the intervals.
n_peaks = floor((length(r_plus_starts) + length(r_plus_ends) + length(r_minus_starts) + length(r_minus_ends)) / 4);
freq = n_peaks / length(data);
