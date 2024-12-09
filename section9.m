function [S_filtered_combined,S_filtered_combined_Rect,S_filtered_combined_RectLE,s_filtered_combined_fft,s_filtered_combined_magnitude,s_filtered_combined_phase] = section9(S_raw,S_raw_Rect,S_raw_RectLE,b_LE, a_LE, s_raw_magnitude,s_raw_phase,t,F, fNy, filterBS,filtering_type_BS,filterBP,filtering_type_BP)

% Combination of the filtering by the 2 filters
if strcmp(filtering_type_BS, 'bidirectional')
        S_filtered_combined = filtfilt(filterBS, S_raw); % Zero-phase filtering
else
        S_filtered_combined = filter(filterBS, S_raw); % Forward filtering
end

if strcmp(filtering_type_BP, 'bidirectional')
        S_filtered_combined = filtfilt(filterBP, S_filtered_combined); % Zero-phase filtering
else
        S_filtered_combined = filter(filterBP, S_filtered_combined); % Forward filtering
end

S_filtered_combined_Rect = abs(S_filtered_combined-mean(S_filtered_combined)); % Signal Rectification
S_filtered_combined_RectLE = filtfilt(b_LE, a_LE, S_filtered_combined_Rect); % Signal Linear Enveloppe

% Combination of the filters by multiplying the signals' Fourier transforms
s_filtered_combined_fft = fft(S_filtered_combined);
s_filtered_combined_magnitude = abs(s_filtered_combined_fft)/length(s_filtered_combined_fft);
s_filtered_combined_phase = angle(s_filtered_combined_fft); 

% Plot
figure;
fig = tiledlayout('vertical','TileSpacing','tight');
sgtitle(fig, 'RAW SIGNAL VS FILTERED SIGNAL WITH CHOSEN FILTERS', 'FontSize', 18, 'FontWeight', 'bold')

nexttile, plot(t, S_raw, 'LineWidth', 3); hold on; plot(t, S_filtered_combined, 'LineWidth', 3);
xlabel('Time (s)', 'FontSize', 18, 'FontWeight', 'bold');
ylabel('Amplitude (mV)', 'FontSize', 18, 'FontWeight', 'bold');
title('Signals in the Time Domain');
box("off"); ax = gca; ax.FontSize = 14; ax.FontWeight = 'bold';

nexttile, plot(F, s_raw_magnitude(1:length(s_raw_magnitude)/2+1), 'LineWidth', 3); hold on;
plot(F, s_filtered_combined_magnitude(1:length(s_filtered_combined_magnitude)/2+1), 'LineWidth', 3);
xlabel('Frequency (Hz)', 'FontSize', 18, 'FontWeight', 'bold');
ylabel('Magnitude (mV)', 'FontSize', 18, 'FontWeight', 'bold');
legend('Raw Signal', 'Filtered Signal with Final Selection')
xlim([0 fNy]);
title('Signals in the Frequency Domain - Frequency');
box("off"); ax = gca; ax.FontSize = 14; ax.FontWeight = 'bold';

nexttile, plot(F, s_raw_phase(1:length(s_raw_phase)/2+1), 'LineWidth', 3); hold on;
plot(F, s_filtered_combined_phase(1:length(s_filtered_combined_phase)/2+1), 'LineWidth', 3);
xlabel('Frequency (Hz)', 'FontSize', 18, 'FontWeight', 'bold');
ylabel('Phase (rad)', 'FontSize', 18, 'FontWeight', 'bold');
xlim([0 fNy]);
title('Signals in the Frequency Domain - Phase');
box("off"); ax = gca; ax.FontSize = 14; ax.FontWeight = 'bold';