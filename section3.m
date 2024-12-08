function [fNy, F, s_raw_fft, s_raw_magnitude, s_raw_power, s_raw_phase] = section3(S_raw, t, fs,s_raw_PeakTresh)

% Section 3 - Signal Analysis
% Variables that needs to be computed
fNy = fs/2 ; % Nyquist frequency: the spectrum is defined until the "fs/2" frequency, where fs=1/(t(2)-t(1))
F = linspace(0,1,length(S_raw)/2+1)*fNy ; % Frequencies: returns the coefficients for # of signal length frequencies "F" linearly distributed between 0 and Ny_EMG (Hz)
s_raw_fft = fft(S_raw); % Fourier Transform of EMG signal
s_raw_magnitude = abs(s_raw_fft)/length(s_raw_fft); % Magnitude of EMG signal [in mV]
s_raw_power = s_raw_magnitude.^2; % Power of EMG signal [in mV²]
s_raw_phase = angle(s_raw_fft); % Phase of EMG signal (rad)

% Graph the raw data in the time and frequency domains to allow the
% determination of corner/cutoff frequency values for the Stop-Band/Notch &
% Band-Pass Filters 
figure;
fig = tiledlayout('vertical','TileSpacing','tight');
sgtitle(fig, 'RAW SIGNAL - OVERVIEW', 'FontSize', 18, 'FontWeight', 'bold')

nexttile, plot(t, S_raw, 'LineWidth', 3);
xlabel('Time (s)', 'FontSize', 18, 'FontWeight', 'bold');
ylabel('Amplitude (mV)', 'FontSize', 18, 'FontWeight', 'bold');
title('Signal in the Time Domain');
box("off"); ax = gca; ax.FontSize = 14; ax.FontWeight = 'bold';

nexttile, plot(F, s_raw_magnitude(1:length(s_raw_magnitude)/2+1), 'LineWidth', 3);
xlabel('Frequency (Hz)', 'FontSize', 18, 'FontWeight', 'bold');
ylabel('Magnitude (mV)', 'FontSize', 18, 'FontWeight', 'bold');
xlim([0 fNy]);
title('Signal in the Frequency Domain - Frequency');
box("off"); ax = gca; ax.FontSize = 14; ax.FontWeight = 'bold';

nexttile, plot(F, s_raw_phase(1:length(s_raw_phase)/2+1), 'LineWidth', 3);
xlabel('Frequency (Hz)', 'FontSize', 18, 'FontWeight', 'bold');
ylabel('Phase (rad)', 'FontSize', 18, 'FontWeight', 'bold');
xlim([0 fNy]);
title('Signal in the Frequency Domain - Phase');
box("off"); ax = gca; ax.FontSize = 14; ax.FontWeight = 'bold';

figure;
fig = tiledlayout('vertical','TileSpacing','tight');
sgtitle(fig, 'RAW SIGNAL - POWER SPECTRUM OVERVIEW', 'FontSize', 18, 'FontWeight', 'bold')

nexttile, plot(F, s_raw_power(1:length(s_raw_power)/2+1), 'LineWidth', 3); hold on;
findpeaks(s_raw_power(1:length(s_raw_power)/2+1),F,'Threshold',s_raw_PeakTresh);
xlabel('Frequency (Hz)', 'FontSize', 18, 'FontWeight', 'bold');
ylabel('Power Spectrum (mV²)', 'FontSize', 18, 'FontWeight', 'bold');
xlim([0 fNy]);
title('Signal in the Frequency Domain - Power Spectrum in mV²');
box("off"); ax = gca; ax.FontSize = 14; ax.FontWeight = 'bold';

nexttile, pspectrum(S_raw, fs);
wLine = findobj(gca, 'Type', 'Line'); % Find line objects in the current axes
set(wLine, 'LineWidth', 3);           % Set the line width to 2 (or any value)
xlabel('Frequency (Hz)', 'FontSize', 18, 'FontWeight', 'bold');
ylabel('Power Spectrum (dB)', 'FontSize', 18, 'FontWeight', 'bold');
title('Signal in the Frequency Domain - Power Spectrum in dB');
box("off"); ax = gca; ax.FontSize = 14; ax.FontWeight = 'bold';