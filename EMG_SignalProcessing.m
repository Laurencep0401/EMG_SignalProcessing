%% Code description and table of contents
% General infos:
%   - Made by: Laurence Poirier
%   - Last update: 29/11/2024

% Description:
% This code was made to design different filters and test them on a
% specific signal of interest to compare which of these filters will be
% the best to use for the actual data collection of your study.

% Systems & Functions required for running this code:
% - Signal Processing Toolbox
% - 'filtering' function
% - 'section1' function
% - 'section3' function
% - 'section9' function

% Note to the user: 
% This code was made with the idea of using it with EMG
% signals. However, it can work for other types of biological signals (e.g.
% ECG, EEG, etc.) So bare in mind the comments inside the code might state
% 'EMG' more precisely when they mention the signal, but this only refers
% to the signal you want to analyze.

% Table of contents:
%   Section 0 - Data Acquisition: Note the data formats required to use 
%               this code is either '.mat' '.xls', '.xlsx', '.csv', '.txt'.
%               For other formats, modification in 'section1' function will
%               be needed.
%   Section 1 - Data Importation
%   Section 2 - Data Preparation - Data Section of Interest Isolation
%   Section 3 - Signal Analysis: Values Determination of Corner/Cutoff 
%               Frequencies of the Band-Stop/Notch & Band-Pass Filters
%   Section 4 - Filter Design of the desired Linear Enveloppe
%   Section 5 - Band-Stop/Notch (BS) Filter Design and Signal Processing 
%               (but can be change to any other type of filter)
%               a. Filtered Signal (with Band-Stop and its harmonics)
%               b. Rectified Filtered Signal
%               c. Rectified Filtered Signal with Linear Enveloppe
%   Section 6 - Band-Pass (BP) Filter Design and Signal Processing 
%               (but can be change to any other type of filter)
%               a. Filtered Signal (with Band-Pass)
%               b. Rectified Filtered Signal
%               c. Rectified Filtered Signal with Linear Enveloppe
%   Section 7 - Raw Signal Processing
%               a. Rectified Signal (not filtered by BS and/or BP)
%               b. Rectified Signal with Linear Enveloppe
%   Section 8 - Filtered Signals and Filter Designs Overviews: Interesting Plots
%   Section 9 - Final choices: Quick Overview

% License:
% This code is provided as-is for educational and research purposes. Use 
% and modify at your own risk. Proper citation of this repository in 
% academic work is strongly appreciated, for all the hours and efforts put 
% into this work by the developer. Hope it can help you out with your data 
% processing and analysis!

%% Section 1 - Data Importation
clear
clc
% DATA PREPARATION
filePath = ("C:\Users\Laurence Poirier\OneDrive - UBC\Applications\MATLAB\KIN501\Pushup Data copy\Lab3_0dgs.mat");
                                   % File pathway. File extension options: 
                                   % '.mat' '.xls', '.xlsx', '.csv', '.txt'

% FUNCTION
[data] = section1(filePath);

%% Section 2 - Data Preparation - Data Section of Interest Isolation
% For getting the right data to arrays (only the part(s) of interest of the
% recording, isolated)

% DATA PREPARATION
fs = 200; % Variable name (or value) of the sampling frequency of EMG signal (Hz)
S_raw = data.data(data.datastart(3)+159: data.dataend(3)); % Variable name of the signal vector of the EMG signal chanel of interest [in V]
t = (data.datastart(3)+159:data.dataend(3))*(1/fs) - (data.datastart(3)+159)*(1/fs); % Variable name of the time vector of EMG signal [in sec]
               % If there is no time vector, you can create one using this
               % format: linspace(0,EnterNumberOfSecTotalHere, length(S_raw)); or 
               % (Column#WhenDataStarts:Column#WhenDataEnds)*(1/fs) - (Column#WhenDataStarts+159)*(1/fs);
s_raw_PeakTresh = 20; % Minimum height difference value between the peaks

%% Section 3 - Signal Analysis
% For computing other required variables such as sampling rate (fs), 
% Nyquist frequency (fNy), ... and for analyzing the signal components in 
% the time & frequency domains to allow the determination of corner/cutoff 
% frequency values for the Band-Stop/Notch & Band-Pass Filters

% FUNCTION
[fNy, F, s_raw_fft, s_raw_magnitude, s_raw_power, s_raw_phase] = section3(S_raw, t, fs,s_raw_PeakTresh);

%% Section 4 - Filter Design of Linear Enveloppe
% Default Filter Design: A Digital 2nd Order Butterworth Low-Pass Filter

% DATA PREPARATION
fc_LE = 10; % Low Cut frequency (Hz). Recommendation:
            % The cutoff frequency (fc_LE) defines the smoothness of the
            % envelope. Typically, fc_LE is chosen between 2-10 Hz for EMG
            % signals. Other signals might require higher fcl. If you are
            % interested in global trend, choose a lower fc_LE (e.g. 2 Hz).
            % If you want to retain more detail, choose a higher fc_LE
            % (e.g. 10 Hz).  

% FUNCTION            
[b_LE,a_LE]=butter(2,fc_LE*1.25/fNy);     
    % Note: cutoff frequency is adjusted upward by 25% because the filter
    % will be applied twice in the next line (forward and backward). The
    % adjustment assures that the actual frequency after two passes will be
    % the desired fcl_EMG specified above.            

%% Section 5 - Band-Stop/Notch (BS) Filter Design and Signal Processing
% For designing all the BS Filters you want to test and compare. To do so,
% just change the parameters in the Data Preparation section along with the 
% name (beware nomination comnditions below) and run that section again.

% DATA PREPARATION
BS= 'BS1'; % Variable Name of the BS Filter. Here is how to name the  
        % filter: ! Start its name with 'BS' ! (e.g. BS1, BS2, BS3)
filter_order_BS = 2; % BS Filter order
hum_freq_BS = 60; % Hum Frequency to eliminate (Hz).
cutoff_freq_range_BS = 1;
        % That means the cutoff frequencies will be 
        % (hum_freq_BS-cutoff_freq_range_BS) and
        % (hum_freq_BS+cutoff_freq_range_BS)
        % E.g. If the hum_freq_BS = 60 Hz and the cutoff_freq_range_BS = 1 Hz, 
        % the cutoff frequencies will be 59 Hz and 61 Hz, respectively.
n_harm_BS = floor(fNy/hum_freq_BS); % Number of harmonics
        % If not manually precised, enter: floor(fNy/cutoff_freq_BS)
filter_type_BS = 'bandstopiir'; % BS Filter response and type. Options:
        % 'lowpassfir' | 'lowpassiir' | 'highpassfir' | 'highpassiir' |
        % 'bandpassfir' | 'bandpassiir' | 'bandstopfir' | 'bandstopiir' |
        % 'differentiatorfir' | 'hilbertfir' | 'arbmagfir'
filter_choice_BS = 'butter'; % BS Filter Design Method. Options:
        % 'butter' | 'cheby1' | 'cheby2' | 'cls' | 'ellip' | 'equiripple' |
        % 'freqsamp' | 'kaiserwin' | 'ls' | 'maxflat' | 'window'         
filtering_type_BS = 'bidirectional'; % The filtering process. Options: 'forward' or 'bidirectional'

% FUNCTION
[varName_BS, d_BS, filtered_BS, filtered_Rect_BS, filtered_LE_BS] = filtering(BS, filter_type_BS, filter_order_BS,hum_freq_BS,filter_choice_BS,filtering_type_BS,fs,S_raw,b_LE,a_LE,n_harm_BS,cutoff_freq_range_BS);
eval([ varName_BS ' = d_BS']);
eval(['S_' varName_BS ' = filtered_BS']);
eval(['S_Rect_' varName_BS ' = filtered_Rect_BS']);
eval(['S_RectLE_' varName_BS ' = filtered_LE_BS']);      

%% Section 6 - Band-Pass (BP) Filter Design and Signal Processing
% For designing all the BP Filters you want to test and compare. To do so,
% just change the parameters in the Data Preparation section along with the 
% name (beware nomination comnditions below) and run that section again.

% DATA PREPARATION
BP = 'BP30'; % Variable Name of the BS Filter. Here is how to name the  
        % filter: ! Start its name with 'BP' ! (e.g. BP1, BP2, BP3)
filter_order_BP = 2; % BP Filter order
cutoff_freq_BP = [30, 95]; % BP Cutoff frequencies (Hz)
filter_type_BP = 'bandpassiir'; % BP Filter response and type. Options:
        % 'lowpassfir' | 'lowpassiir' | 'highpassfir' | 'highpassiir' |
        % 'bandpassfir' | 'bandpassiir' | 'bandstopfir' | 'bandstopiir' |
        % 'differentiatorfir' | 'hilbertfir' | 'arbmagfir'
filter_choice_BP = 'butter'; % BP Filter Design Method. Options:
        % 'butter' | 'cheby1' | 'cheby2' | 'cls' | 'ellip' | 'equiripple' |
        % 'freqsamp' | 'kaiserwin' | 'ls' | 'maxflat' | 'window'
       
filtering_type_BP = 'bidirectional'; % The filtering process. Options: 'forward' or 'bidirectional'

% FUNCTION
[varName_BP, d_BP, filtered_BP, filtered_Rect_BP, filtered_LE_BP] = filtering(BP, filter_type_BP, filter_order_BP,cutoff_freq_BP,filter_choice_BP,filtering_type_BP,fs,S_raw,b_LE,a_LE);
eval([ varName_BP ' = d_BP']);
eval(['S_' varName_BP ' = filtered_BP']);
eval(['S_Rect_' varName_BP ' = filtered_Rect_BP']);
eval(['S_RectLE_' varName_BP ' = filtered_LE_BP']);

%% Section 7 - Raw Signal Processing
% Raw Signal Rectification and Linear Enveloppe for comparison with the
% equivalent filtered signals

% FUNCTION
S_raw_Rect = abs(S_raw-mean(S_raw));
S_raw_RectLE = filtfilt(b_LE, a_LE, S_raw_Rect);

%% Section 8 - Filtered Signals and Filter Designs Overviews: Interesting Plots

% FUNCTION
filterAnalyzer
signalAnalyzer

%% Section 9 - Final choices: Quick Overview

% DATA PREPARATION
filterBS = BS1; % Selected Band-Stop Filter
filtering_type_BS = 'bidirectional'; % The filtering process. Options: 'forward' or 'bidirectional'
filterBP = BP30; % Selected Band-Pass Filter
filtering_type_BP = 'bidirectional'; % The filtering process. Options: 'forward' or 'bidirectional'

% FUNCTION
[S_filtered_combined,S_filtered_combined_Rect,S_filtered_combined_RectLE,s_filtered_combined_fft,s_filtered_combined_magnitude,s_filtered_combined_phase] = section9(S_raw,S_raw_Rect,S_raw_RectLE,b_LE, a_LE, s_raw_magnitude,s_raw_phase,t,F, fNy, filterBS,filtering_type_BS,filterBP,filtering_type_BP); % For a quick overview
signalAnalyzer % To compare S_filtered_combined, S_filtered_combined_Rect or S_filtered_combined_RectLE with S_raw, S_raw_Rect or S_raw_RectLE respectively