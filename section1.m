function [data] = section1(filePath)

[~,~,ext] = fileparts(filePath);
                                    
 switch lower(ext)
        case '.mat' % Matlab files
            data = load(filePath);
        case {'.xls', '.xlsx'} % Excel files
            data = readmatrix(filePath); % Read entire sheet
            
        case '.csv' % CSV files
            data = readmatrix(filePath);
            
        case '.txt' % Text files
            data = load(filePath);       % Load data from the text file
           
        otherwise
            error('Unsupported file type: %s', ext);
 end 