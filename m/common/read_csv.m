function [pointNumbers, channelData, t_start, t_increment] = read_csv(fileName)
%%
% read_csv - read .csv file with data from oscillograph.
% 
    fid = fopen(fileName);
    
    header = textscan(fid, '%*s %*s %f %f', 1, 'HeaderLines', 1, 'Delimiter', ',');
    t_start = header{1};
    t_increment = header{2};
    
    data = textscan(fid, '%*u %f', 'HeaderLines', 2, ...
                    'Delimiter', ',', 'CollectOutput', 1);
    channelData = data{1};
    
    pointNumbers = 0:(length(channelData)-1);
    
    pointNumbers = pointNumbers';
    
    fclose(fid);
 end
