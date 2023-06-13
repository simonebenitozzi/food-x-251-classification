function [images,gt] = extract_data(data_files,N_SIZE,images,gt,folder)

% folder:
%   0 = train
%   1 = validation
%   2 = validation degradato

    data_names = [];
    
    for ii=1:N_SIZE
        if rem(ii,1000)==0
            disp(ii);
        end
        name = string(data_files.rowheaders(ii,1));
        if folder == 0
            name = strcat('G:\Progetto VIPM\train\train_set\',name);
        elseif folder == 1
            name = strcat('G:\Progetto VIPM\val\val_set\',name);
        else
            name = strcat('G:\Progetto VIPM\val_degraded\val_set_degraded\',name);
        end
        images{ii,1} = imread(name);
        gt{ii,1} = data_files.data(ii,1);
    end

end