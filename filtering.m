function [varName, d, filtered, filtered_Rect, filtered_LE] = filtering(filter_name, filter_type, filter_order,cutoff_freq,filter_choice,filtering_type,fs,rawSignal,b_LE,a_LE,n_harm_BS,cutoff_freq_range_BS)

varName = filter_name; % Get the name of variable as a string
    
    % Check if the variable name starts with 'BS' or 'BP'
    if startsWith(varName, 'BS')
       for i = 1: n_harm_BS
           if i == 1 
               d = designfilt(filter_type,'FilterOrder',filter_order, 'HalfPowerFrequency1',(cutoff_freq*i)-cutoff_freq_range_BS,'HalfPowerFrequency2',(cutoff_freq*i)+cutoff_freq_range_BS,'DesignMethod',filter_choice,'SampleRate',fs);
               if strcmp(filtering_type, 'bidirectional')
                    filtered = filtfilt(d, rawSignal); % Zero-phase filtering
               else
                    filtered = filter(d, rawSignal); % Forward filtering
               end

           else 
               d = designfilt(filter_type,'FilterOrder',filter_order, 'HalfPowerFrequency1',(cutoff_freq*i)-cutoff_freq_range_BS,'HalfPowerFrequency2',(cutoff_freq*i)+cutoff_freq_range_BS,'DesignMethod',filter_choice,'SampleRate',fs);
               if strcmp(filtering_type, 'bidirectional')
                    filtered = filtfilt(d, filtered); % Zero-phase filtering
               else
                    filtered = filter(d, filtered); % Forward filtering
               end
           end
       end
        filtered_Rect = abs(filtered-mean(filtered)); % Signal Rectification
        filtered_LE = filtfilt(b_LE, a_LE, filtered_Rect); % Signal Linear Enveloppe
    elseif startsWith(varName, 'BP')
        d = designfilt(filter_type,'FilterOrder',filter_order, 'HalfPowerFrequency1',cutoff_freq(1),'HalfPowerFrequency2',cutoff_freq(2),'DesignMethod',filter_choice,'SampleRate',fs);
        if strcmp(filtering_type, 'bidirectional')
            filtered = filtfilt(d, rawSignal); % Zero-phase filtering
        else
            filtered = filter(d, rawSignal); % Forward filtering
        end
        filtered_Rect = abs(filtered-mean(filtered)); % Signal Rectification
        filtered_LE = filtfilt(b_LE, a_LE, filtered_Rect); % Signal Linear Enveloppe
    end
