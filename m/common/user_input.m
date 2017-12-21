function [file_name_radio, path_radio, file_name_attenuation, path_attenuation, Rmeas, f_p, comment] = user_input()

%% Load Data.
% Check if the data loaded and ask to reload it.
load_data = true;
if (exist('radioData', 'var') && exist('attenuationData', 'var'))
    button = questdlg('Использовать прежде загруженные данные?', 'Вопрос', ...
                      'Да', 'Нет, загрузить из файлов', 'Да');
    if (strcmp(button, 'Да'))
        load_data = false;
    end
end

% Load/reload the data.
if (load_data)
    % Clear workspace.
    clear
    % Return back to directory with this script.
    cd(fileparts(mfilename('fullpath')));
    
        [file_name_radio, path_radio] = uigetfile({'*.csv', 'Файлы данных'}, ...
                                              'Выберите файл с радиовоздействием');
                                          
    if (file_name_radio == 0)
        return;
    end
    
    cd(path_radio);

    [file_name_attenuation, path_attenuation] = uigetfile({'*.csv', 'Файлы данных'}, ...
                                          'Выберите файл с затухающей осциллограммой', ...
                                          path_radio);
    
    if (file_name_attenuation == 0)
        return;
    end
        
    prompt = {'R измер., Ом:', 'f параллельного резонанса, кГц', 'Комментарий'};
    Rmeas_str = '1.0';
    F_p_str = '';
    if (~exist('comment', 'var'))
        comment = '';
    end
    
    % Ask user to type Rmeas value and comment.
    def = {Rmeas_str, F_p_str, comment};
    answer = inputdlg(prompt, 'Введите значения', 1, def);
    if (isempty(answer))
        return
    end
    
    Rmeas = str2num(answer{1});
    f_p = str2num(answer{2});
    comment = answer{3};
end
